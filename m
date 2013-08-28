From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Slow performance with librspreload.so
Date: Wed, 28 Aug 2013 17:20:01 +0200
Message-ID: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi
i'm trying the preloader librspreload.so on two directly connected hosts:

host1:$ sudo ibstatus
Infiniband device 'mlx4_0' port 1 status:
default gid: fe80:0000:0000:0000:0002:c903:004d:dd45
base lid: 0x1
sm lid: 0x1
state: 4: ACTIVE
phys state: 5: LinkUp
rate: 20 Gb/sec (4X DDR)
link_layer: InfiniBand

Infiniband device 'mlx4_0' port 2 status:
default gid: fe80:0000:0000:0000:0002:c903:004d:dd46
base lid: 0x0
sm lid: 0x0
state: 1: DOWN
phys state: 2: Polling
rate: 10 Gb/sec (4X)
link_layer: InfiniBand


host2:$ sudo ibstatus
Infiniband device 'mthca0' port 1 status:
default gid: fe80:0000:0000:0000:0008:f104:0398:14cd
base lid: 0x2
sm lid: 0x1
state: 4: ACTIVE
phys state: 5: LinkUp
rate: 20 Gb/sec (4X DDR)
link_layer: InfiniBand

Infiniband device 'mthca0' port 2 status:
default gid: fe80:0000:0000:0000:0008:f104:0398:14ce
base lid: 0x0
sm lid: 0x0
state: 1: DOWN
phys state: 2: Polling
rate: 10 Gb/sec (4X)
link_layer: InfiniBand



i've connected just one port between two hosts.
Ports is detected properly as 20Gb/s  (4x DDR) but i'm unable to reach
speed over 5Gbit/s:

host1:$ sudo LD_PRELOAD=/usr/lib/x86_64-linux-gnu/rsocket/librspreload.so
NPtcp -h 172.17.0.2
Send and receive buffers are 131072 and 131072 bytes
(A bug in Linux doubles the requested buffer sizes)
Now starting the main loop
  0:       1 bytes  17008 times -->      1.24 Mbps in       6.13 usec
  1:       2 bytes  16306 times -->      2.02 Mbps in       7.56 usec
  2:       3 bytes  13223 times -->      3.10 Mbps in       7.38 usec
  3:       4 bytes   9037 times -->      4.21 Mbps in       7.25 usec
  4:       6 bytes  10345 times -->      6.49 Mbps in       7.05 usec
  5:       8 bytes   7093 times -->      7.77 Mbps in       7.85 usec
  6:      12 bytes   7957 times -->     17.08 Mbps in       5.36 usec
  7:      13 bytes   7772 times -->     14.75 Mbps in       6.73 usec
  8:      16 bytes   6861 times -->     16.11 Mbps in       7.58 usec
  9:      19 bytes   7424 times -->     18.91 Mbps in       7.67 usec
 10:      21 bytes   8237 times -->     17.69 Mbps in       9.06 usec
 11:      24 bytes   7361 times -->     19.72 Mbps in       9.28 usec
 12:      27 bytes   7628 times -->     24.14 Mbps in       8.53 usec
 13:      29 bytes   5207 times -->     29.81 Mbps in       7.42 usec
 14:      32 bytes   6504 times -->     29.42 Mbps in       8.30 usec
 15:      35 bytes   6401 times -->     39.08 Mbps in       6.83 usec
 16:      45 bytes   8362 times -->     45.19 Mbps in       7.60 usec
 17:      48 bytes   8774 times -->     46.10 Mbps in       7.94 usec
 18:      51 bytes   8654 times -->     55.19 Mbps in       7.05 usec
 19:      61 bytes   5562 times -->     57.42 Mbps in       8.10 usec
 20:      64 bytes   6068 times -->     72.31 Mbps in       6.75 usec
 21:      67 bytes   7636 times -->     42.93 Mbps in      11.91 usec
 22:      93 bytes   4512 times -->     55.84 Mbps in      12.71 usec
 23:      96 bytes   5246 times -->     60.13 Mbps in      12.18 usec
 24:      99 bytes   5558 times -->     59.49 Mbps in      12.70 usec
 25:     125 bytes   2864 times -->     75.25 Mbps in      12.67 usec
 26:     128 bytes   3913 times -->     75.78 Mbps in      12.89 usec
 27:     131 bytes   3940 times -->     74.77 Mbps in      13.37 usec
 28:     189 bytes   3883 times -->    113.42 Mbps in      12.71 usec
 29:     192 bytes   5243 times -->    109.85 Mbps in      13.33 usec
 30:     195 bytes   5038 times -->    115.66 Mbps in      12.86 usec
 31:     253 bytes   2710 times -->    146.61 Mbps in      13.17 usec
 32:     256 bytes   3782 times -->    142.77 Mbps in      13.68 usec
 33:     259 bytes   3683 times -->    144.75 Mbps in      13.65 usec
 34:     381 bytes   3733 times -->    201.64 Mbps in      14.42 usec
 35:     384 bytes   4624 times -->    204.22 Mbps in      14.35 usec
 36:     387 bytes   4665 times -->    204.65 Mbps in      14.43 usec
 37:     509 bytes   2364 times -->    265.12 Mbps in      14.65 usec
 38:     512 bytes   3406 times -->    267.89 Mbps in      14.58 usec
 39:     515 bytes   3442 times -->    266.90 Mbps in      14.72 usec
 40:     765 bytes   3429 times -->    381.51 Mbps in      15.30 usec
 41:     768 bytes   4357 times -->    384.85 Mbps in      15.23 usec
 42:     771 bytes   4387 times -->    386.35 Mbps in      15.23 usec
 43:    1021 bytes   2214 times -->    495.38 Mbps in      15.72 usec
 44:    1024 bytes   3176 times -->    499.56 Mbps in      15.64 usec
 45:    1027 bytes   3203 times -->    497.19 Mbps in      15.76 usec
 46:    1533 bytes   3188 times -->    692.19 Mbps in      16.90 usec
 47:    1536 bytes   3945 times -->    688.52 Mbps in      17.02 usec
 48:    1539 bytes   3920 times -->    693.85 Mbps in      16.92 usec
 49:    2045 bytes   1981 times -->    858.05 Mbps in      18.18 usec
 50:    2048 bytes   2748 times -->    862.22 Mbps in      18.12 usec
 51:    2051 bytes   2761 times -->    832.50 Mbps in      18.80 usec
 52:    3069 bytes   2666 times -->   1174.72 Mbps in      19.93 usec
 53:    3072 bytes   3344 times -->   1183.58 Mbps in      19.80 usec
 54:    3075 bytes   3368 times -->   1177.98 Mbps in      19.92 usec
 55:    4093 bytes   1678 times -->   1495.79 Mbps in      20.88 usec
 56:    4096 bytes   2394 times -->   1486.91 Mbps in      21.02 usec
 57:    4099 bytes   2380 times -->   1490.11 Mbps in      20.99 usec
 58:    6141 bytes   2385 times -->   2417.56 Mbps in      19.38 usec
 59:    6144 bytes   3439 times -->   2491.24 Mbps in      18.82 usec
 60:    6147 bytes   3543 times -->   2393.71 Mbps in      19.59 usec
 61:    8189 bytes   1703 times -->   2486.93 Mbps in      25.12 usec
 62:    8192 bytes   1990 times -->   2501.61 Mbps in      24.98 usec
 63:    8195 bytes   2001 times -->   2470.25 Mbps in      25.31 usec
 64:   12285 bytes   1976 times -->   3335.91 Mbps in      28.10 usec
 65:   12288 bytes   2372 times -->   3346.71 Mbps in      28.01 usec
 66:   12291 bytes   2380 times -->   3325.57 Mbps in      28.20 usec
 67:   16381 bytes   1183 times -->   3404.87 Mbps in      36.71 usec
 68:   16384 bytes   1362 times -->   3396.27 Mbps in      36.81 usec
 69:   16387 bytes   1358 times -->   3338.60 Mbps in      37.45 usec
 70:   24573 bytes   1335 times -->   3952.93 Mbps in      47.43 usec
 71:   24576 bytes   1405 times -->   3870.35 Mbps in      48.45 usec
 72:   24579 bytes   1376 times -->   3947.46 Mbps in      47.50 usec
 73:   32765 bytes    701 times -->   3708.77 Mbps in      67.40 usec
 74:   32768 bytes    741 times -->   3670.93 Mbps in      68.10 usec
 75:   32771 bytes    734 times -->   3713.07 Mbps in      67.34 usec
 76:   49149 bytes    742 times -->   4269.21 Mbps in      87.83 usec
 77:   49152 bytes    759 times -->   4213.58 Mbps in      89.00 usec
 78:   49155 bytes    749 times -->   4261.68 Mbps in      88.00 usec
 79:   65533 bytes    378 times -->   4397.40 Mbps in     113.70 usec
 80:   65536 bytes    439 times -->   4495.83 Mbps in     111.21 usec
 81:   65539 bytes    449 times -->   4373.61 Mbps in     114.33 usec
 82:   98301 bytes    437 times -->   4581.69 Mbps in     163.69 usec
 83:   98304 bytes    407 times -->   4643.01 Mbps in     161.53 usec
 84:   98307 bytes    412 times -->   4574.63 Mbps in     163.95 usec
 85:  131069 bytes    203 times -->   4663.35 Mbps in     214.43 usec
 86:  131072 bytes    233 times -->   4643.97 Mbps in     215.33 usec
 87:  131075 bytes    232 times -->   4663.00 Mbps in     214.46 usec
 88:  196605 bytes    233 times -->   4820.71 Mbps in     311.15 usec
 89:  196608 bytes    214 times -->   4838.05 Mbps in     310.04 usec
 90:  196611 bytes    215 times -->   4833.56 Mbps in     310.34 usec
 91:  262141 bytes    107 times -->   4946.10 Mbps in     404.35 usec
 92:  262144 bytes    123 times -->   4955.13 Mbps in     403.62 usec
 93:  262147 bytes    123 times -->   4940.46 Mbps in     404.83 usec
 94:  393213 bytes    123 times -->   5061.76 Mbps in     592.67 usec
 95:  393216 bytes    112 times -->   5053.05 Mbps in     593.70 usec
 96:  393219 bytes    112 times -->   5022.92 Mbps in     597.27 usec
 97:  524285 bytes     55 times -->   5125.96 Mbps in     780.34 usec
 98:  524288 bytes     64 times -->   5117.60 Mbps in     781.62 usec
 99:  524291 bytes     63 times -->   5122.30 Mbps in     780.90 usec
100:  786429 bytes     64 times -->   5189.59 Mbps in    1156.16 usec
101:  786432 bytes     57 times -->   5186.53 Mbps in    1156.84 usec
102:  786435 bytes     57 times -->   5183.52 Mbps in    1157.52 usec
103: 1048573 bytes     28 times -->   5217.00 Mbps in    1533.44 usec
104: 1048576 bytes     32 times -->   5198.91 Mbps in    1538.78 usec
105: 1048579 bytes     32 times -->   5218.60 Mbps in    1532.98 usec
106: 1572861 bytes     32 times -->   5242.06 Mbps in    2289.17 usec
107: 1572864 bytes     29 times -->   5242.86 Mbps in    2288.83 usec
108: 1572867 bytes     29 times -->   5249.47 Mbps in    2285.95 usec
109: 2097149 bytes     14 times -->   5252.47 Mbps in    3046.18 usec
110: 2097152 bytes     16 times -->   5260.67 Mbps in    3041.44 usec
111: 2097155 bytes     16 times -->   5255.55 Mbps in    3044.40 usec
112: 3145725 bytes     16 times -->   5255.34 Mbps in    4566.78 usec
113: 3145728 bytes     14 times -->   5259.21 Mbps in    4563.43 usec
114: 3145731 bytes     14 times -->   5263.82 Mbps in    4559.43 usec
115: 4194301 bytes      7 times -->   5256.99 Mbps in    6087.13 usec
116: 4194304 bytes      8 times -->   5265.97 Mbps in    6076.75 usec
117: 4194307 bytes      8 times -->   5257.70 Mbps in    6086.32 usec
118: 6291453 bytes      8 times -->   5242.18 Mbps in    9156.50 usec
119: 6291456 bytes      7 times -->   5238.10 Mbps in    9163.64 usec
120: 6291459 bytes      7 times -->   5223.28 Mbps in    9189.64 usec
121: 8388605 bytes      3 times -->   5192.27 Mbps in   12326.00 usec
122: 8388608 bytes      4 times -->   5206.80 Mbps in   12291.61 usec
123: 8388611 bytes      4 times -->   5197.97 Mbps in   12312.50 usec


host1:$ sudo LD_PRELOAD=/usr/lib/x86_64-linux-gnu/rsocket/librspreload.so
iperf -c 172.17.0.2
------------------------------------------------------------
Client connecting to 172.17.0.2, TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  3] local 172.17.0.1 port 36085 connected with 172.17.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  7.82 GBytes  6.72 Gbits/sec



I'm also trying to set connected as IB mode but without success:

host1:$ sudo echo connected > /sys/class/net/ib0/mode
host1:$ sudo cat /sys/class/net/ib0/mode
datagram


Any advice ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
