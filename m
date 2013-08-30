From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Fri, 30 Aug 2013 10:23:21 +0200
Message-ID: <CAJH6TXgR=wVGyyHrpTKkBw-5M=A9-tGzjpYcV6NWpk8uKvFn8Q@mail.gmail.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA9C6B@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXiYLKt3b1UFsZt7uFwDbWcDFnHNnS8CTO24Gt-2zn+Qiw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CA9D8A@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXhWWMBbopDLZY2+rrNOm2m5gcmObj7Sr16u2qrNW_NHgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXhWWMBbopDLZY2+rrNOm2m5gcmObj7Sr16u2qrNW_NHgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/8/30 Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> By the way, moving the HBA on the second slot, brought me to 12Gbps on
> both hosts.

This is great:

$ sudo LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so iperf -c 172.17.0.2
------------------------------------------------------------
Client connecting to 172.17.0.2, TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  3] local 172.17.0.1 port 34108 connected with 172.17.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  12.2 GBytes  10.5 Gbits/sec
$ sudo LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so iperf -c
172.17.0.2 -P 2
------------------------------------------------------------
Client connecting to 172.17.0.2, TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  4] local 172.17.0.1 port 55323 connected with 172.17.0.2 port 5001
[  3] local 172.17.0.1 port 36579 connected with 172.17.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  7.46 GBytes  6.41 Gbits/sec
[  3]  0.0-10.0 sec  7.46 GBytes  6.41 Gbits/sec
[SUM]  0.0-10.0 sec  14.9 GBytes  12.8 Gbits/sec


with 2 parallel connection i'm able to reach "rate" speed with iperf,
the same speed archived with rstream.
Is iperf affected by IPoIB MTU size when used with librspreload.so ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
