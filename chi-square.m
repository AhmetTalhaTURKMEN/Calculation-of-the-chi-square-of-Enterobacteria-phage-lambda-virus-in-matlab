sekans=getgenbank('NC_001416','SequenceOnly',true);

sitozin=length(strfind(sekans,'C'))/length(sekans);

guanin=length(strfind(sekans,'G'))/length(sekans);

p=(sitozin^2)*(guanin^2);

HpaII='CCGG';

h=length(strfind(sekans,HpaII))/length(sekans);

funce=@(x)p*exp(-p*x);

funco=@(x)h*exp(-h*x);

expectationintegral=zeros(7,1);

enumber=zeros(8,1);% beklenti sayilarinin tutulacagi dizi

observationintegral=zeros(7,1);

onumber=zeros(8,1);% gozlem sayilarinin tutulacagi dizi

% gozlem ve beklenti oranlarini hesaplayan for dongusu
for i=1:6
    expectationintegral(i)=integral(funce,(i-1)*100,i*100);
    observationintegral(i)=integral(funco,(i-1)*100,i*100);
end
expectationintegral(7)=integral(funce,600,48502);
observationintegral(7)=integral(funco,600,48502);

% gozlem ve beklenti adetlerini hesaplayan for dongusu
for i=1:7
    enumber(i)=expectationintegral(i)*length(strfind(sekans,HpaII));
    onumber(i)=observationintegral(i)*length(strfind(sekans,HpaII));
end
enumber(8)=sum(enumber,[7 1]);
% toplam beklenti adedini tabloda yazdirmak icin kullandım
onumber(8)=sum(onumber,[7 1]);
% toplam gozlem adedini tabloda yazdirmak icin kullandım


chisquare=zeros(8,1);

% ki kare degerlerini hesaplayan for dongusu
for i=1:7 
    chisquare(i)=((onumber(i)-enumber(i))^2)/(enumber(i));
end

chisquaretotal=zeros(8,1);

for i=1:7
    chisquaretotal(i)=chisquare(i);
end

% ki kare degerlerini toplayan for dongusu
for i=1:7
    chisquaretotal(i+1)=chisquaretotal(i)+chisquaretotal(i+1);
end
% Bu toplami sum fonksiyonu ile de yapabilirdik ama ben farkli olsun diye 
% for dongusu ile yapmak istedim 
% sum fonksiyonunu kullansaydik chisquaretotal dizinini belirtmemize gerek olmazdi
% chisquaretotali chisquare dizinin verilerini korumak icin olusturdum

chisquare(8)=chisquaretotal(8);

interval={'[0,100)';'[100,200)';'[200,300)';'[300,400)';'[400,500)';'[500,600)';'[600,48502)';'TOTAL'};
 
T=table(categorical(interval),enumber,onumber,chisquare)
T.Properties.VariableNames ={'Aralık','Beklenti','Gözlem','Ki kare'}
% Noktali virgul koymama sebebi komut penceresinde tablo olusmasi icin

writetable(T,'VERİLER.xlsx');
% Tabloda bulunan verileri VERİLER adındaki excel dosyasina atar

if chisquaretotal(8)<12.592
   disp('Gozlem ile beklenti benzerdir ve aynı dagilimdan gelmektedir.');
else
   disp('Gozlem ile beklenti benzer degildir ve farkli dagilimdan geliyor.');
end