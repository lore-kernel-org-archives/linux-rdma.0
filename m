From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Tue, 3 Sep 2013 11:17:55 +0200
Message-ID: <CAJH6TXh_TPMdfxz56KbB=tE7Z_szk3PjBvAuS-Ni8thCVZYCxQ@mail.gmail.com>
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
	<CAJH6TXgR=wVGyyHrpTKkBw-5M=A9-tGzjpYcV6NWpk8uKvFn8Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CAA11B@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXiOToa2-EOj6Hz-rkVHt3tCSh4jnLbKZs69GhT7dFeH0A@mail.gmail.com>
	<003701cea717$28616140$792423c0$@soft-forge.com>
	<CAJH6TXj53RZmzqA94CfPJjXBetK7us5v=cFyoMmjVUNQ-oeqpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXj53RZmzqA94CfPJjXBetK7us5v=cFyoMmjVUNQ-oeqpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/9/1 Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> What is strange to me is that rsocket is slower than IPoIB and limited
> to 10Gbit more or less. With IPoIB i'm able to reach 12.5 Gbit

qperf is giving the same strange speed:

FROM NODE1 to NODE2:
$ sudo qperf -ub 77.95.175.106 ud_lat ud_bw
ud_lat:
    latency  =  12.5 us
ud_bw:
    send_bw  =  12.5 Gb/sec
    recv_bw  =  12.5 Gb/sec


FROM NODE1 TO NODE2, slower and with more latency than remote host!
$ sudo qperf -ub 172.17.0.1 ud_lat ud_bw
ud_lat:
    latency  =  13.8 us
ud_bw:
    send_bw  =  11.9 Gb/sec
    recv_bw  =  11.9 Gb/sec


how can I check if this is due to an hardware bottleneck ? CPU and RAM are good.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
