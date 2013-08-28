From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Wed, 28 Aug 2013 18:19:03 +0200
Message-ID: <CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA937E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/8/28 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> Can you run the rstream test program to verify that you can get faster than 5 Gbps?
>
> rstream without any options will use rsockets directly.  If you use the -T s option, it will use standard TCP sockets.  You can use LD_PRELOAD with -T s to verify that the preload brings your per performance to the same level as using rsockets directly.

5Gb/s with rstream:

$ sudo ./rstream -s 172.17.0.2
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       100k    12m         0.70s      0.15       3.52
4k_lat    4k      1       10k     78m         0.29s      2.23      14.69
64k_lat   64k     1       1k      125m        0.21s      4.94     106.07
1m_lat    1m      1       100     200m        0.30s      5.61    1495.89
64_bw     64      100k    1       12m         0.25s      0.42       1.23
4k_bw     4k      10k     1       78m         0.13s      5.17       6.34
64k_bw    64k     1k      1       125m        0.19s      5.58      94.03
1m_bw     1m      100     1       200m        0.30s      5.64    1486.53
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
