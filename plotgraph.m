function plotgraph(sc_rate,fail_rate)
figure(2)
bar(fail_rate)
title('Rate of fail when HO')
xlabel('UE')
ylabel('Rate of Ping-Pong Movement')
figure(3)
bar(sc_rate)
title('Time in SC event')
xlabel('UE')
ylabel('Time UE stays in SC event(%)')
figure(4)
bar(sc_rate.*fail_rate)
title('Time in PING-PONG')
xlabel('UE')
>>>>>>> 12f25fb4412dad1b6447cb17566d8c7fb874de22
ylabel('Time UE stays in ping-pong event(%)')