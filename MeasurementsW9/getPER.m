function per = getPER(RX_SEQ, TX_SEQ)
% GETPER Calculate packet error rate for an RX node with respect to a TX node.
% RX_SEQ - Vector with received packet IDs
% TX_SEQ - Vector with sent packet IDs

% NOTE: Detta är ursprunglig beräkning från Kristian
%       Man får väl alltid samma värde genom att ta 1 - size(RX_SEQ, 1)/size(TX_SEQ, 1)  ??
%       Motsvarande går dock ej för diversity

  % sort, just in case
  RX_SEQ=sort(RX_SEQ);
  TX_SEQ=sort(TX_SEQ);

  vper=zeros(size(TX_SEQ));

  M=length(TX_SEQ);
  N=length(RX_SEQ);

  % Om TX-loggen startar på ett högre värde än RX så stegar vi fram RX
  % så att sekvensnumret är minst lika stort som första TX
  for n=1:N
    if TX_SEQ(1)<=RX_SEQ(n)
      break
    end
    
  end

  % Gå genom hela TX-sekvensen och sätt en etta i vper-vektorn på varje
  % sekvensnummer där inget motsvarande paket finns i RX
  for m=1:M
    if n>N
      vper(m)=1;
    else
      if TX_SEQ(m)==RX_SEQ(n)
        n=n+1;
      else
        vper(m)=1;
      end 
    end
  end

  % Beräkna totala packet error rate som antalet mottagna paket genom
  % antalet sända paket. Resultat i %.
  per=sum(vper)/M*100;

end
