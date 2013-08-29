From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Slow performance with librspreload.so
Date: Thu, 29 Aug 2013 15:03:00 +0200
Message-ID: <CAJH6TXh0ynw8pH26CdA44b2RLODR3KOEFaQ1UUx3E8cob=3jZQ@mail.gmail.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

---------- Forwarded message ----------
From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 2013/8/29
Subject: Re: Slow performance with librspreload.so
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


2013/8/28 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> If you can provide your PCIe information and the results from running the perftest tools (rdma_bw), that could help as well.

node1 (172.17.0.1 is ip configured on ib0):

$ sudo ./rstream -s 172.17.0.1
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       100k    12m         0.26s      0.40       1.28
4k_lat    4k      1       10k     78m         0.17s      3.96       8.28
64k_lat   64k     1       1k      125m        0.11s      9.86      53.19
1m_lat    1m      1       100     200m        0.14s     12.34     679.73
64_bw     64      100k    1       12m         0.06s      1.75       0.29
4k_bw     4k      10k     1       78m         0.06s     11.79       2.78
64k_bw    64k     1k      1       125m        0.09s     12.20      42.97
1m_bw     1m      100     1       200m        0.13s     12.78     656.55

$ lspci | grep -i infiniband
04:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe
2.0 2.5GT/s - IB DDR / 10GigE] (rev a0)


node2 (172.17.0.2 is ip configured on ib0):
$ sudo ./rstream -s 172.17.0.2
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       100k    12m         1.10s      0.09       5.49
4k_lat    4k      1       10k     78m         0.43s      1.53      21.49
64k_lat   64k     1       1k      125m        0.29s      3.64     143.99
1m_lat    1m      1       100     200m        0.37s      4.53    1852.70
64_bw     64      100k    1       12m         0.42s      0.24       2.12
4k_bw     4k      10k     1       78m         0.16s      4.16       7.87
64k_bw    64k     1k      1       125m        0.23s      4.49     116.69
1m_bw     1m      100     1       200m        0.36s      4.63    1813.52

$ lspci | grep -i infiniband
02:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex
(Tavor compatibility mode) (rev 20)
(this is a Voltaire 400Ex-D card)

Same result by using 127.0.0.1 on both hosts, obviously.

I'm unable to run rdma_bw due to different CPU speed any my versions
doesn't have the ignore flag.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
