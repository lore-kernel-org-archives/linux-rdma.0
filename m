From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Thu, 29 Aug 2013 15:03:51 +0200
Message-ID: <CAJH6TXggRLroQcNJwMu5cWpp1cNGNowHuKPuGrPLsLbGicK2ZQ@mail.gmail.com>
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
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/8/29 Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> node1 (172.17.0.1 is ip configured on ib0):
>
> $ sudo ./rstream -s 172.17.0.1
> name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
> 64_lat    64      1       100k    12m         0.26s      0.40       1.28
> 4k_lat    4k      1       10k     78m         0.17s      3.96       8.28
> 64k_lat   64k     1       1k      125m        0.11s      9.86      53.19
> 1m_lat    1m      1       100     200m        0.14s     12.34     679.73
> 64_bw     64      100k    1       12m         0.06s      1.75       0.29
> 4k_bw     4k      10k     1       78m         0.06s     11.79       2.78
> 64k_bw    64k     1k      1       125m        0.09s     12.20      42.97
> 1m_bw     1m      100     1       200m        0.13s     12.78     656.55

With standard sockets:

$ sudo ./rstream -s 172.17.0.1 -T s
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       100k    12m         1.07s      0.10       5.36
4k_lat    4k      1       10k     78m         0.13s      4.89       6.70
64k_lat   64k     1       1k      125m        0.06s     18.38      28.52
1m_lat    1m      1       100     200m        0.06s     25.90     323.89
64_bw     64      100k    1       12m         0.98s      0.10       4.91
4k_bw     4k      10k     1       78m         0.12s      5.29       6.20
64k_bw    64k     1k      1       125m        0.04s     27.04      19.39
1m_bw     1m      100     1       200m        0.05s     31.52     266.14
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
