From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Slow performance with librspreload.so
Date: Fri, 30 Aug 2013 17:38:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CAA1B9@ORSMSX109.amr.corp.intel.com>
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
 <CAJH6TXidOVJDTokOwxjCT9RRTOO6E_xbyG_K++YVkFx8NbhMTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXidOVJDTokOwxjCT9RRTOO6E_xbyG_K++YVkFx8NbhMTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Another strange issue:
> 
> $ sudo LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so iperf -c
> 172.17.0.2
> ------------------------------------------------------------
> Client connecting to 172.17.0.2, TCP port 5001
> TCP window size:  128 KByte (default)

Increasing the window size may improve the results.  E.g. on my systems I go from 17.7 Gbps at 128 KB to 24.3 Gbps for 512 KB.

> ------------------------------------------------------------
> [  3] local 172.17.0.1 port 57926 connected with 172.17.0.2 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  12.2 GBytes  10.4 Gbits/sec
> 
> $ iperf -c 172.17.0.2
> ------------------------------------------------------------
> Client connecting to 172.17.0.2, TCP port 5001
> TCP window size:  648 KByte (default)
> ------------------------------------------------------------
> [  3] local 172.17.0.1 port 58113 connected with 172.17.0.2 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  14.5 GBytes  12.5 Gbits/sec
> 
> rsocket slower than IPoIB ?

This is surprising to me - just getting 12.5 Gbps out of ipoib is surprising.  Does iperf use sendfile()?

My results with iperf (version 2.0.5) over ipoib (default configurations) vary considerably based on the TCP window size.  (Note that this is a 40 Gbps link.)  Results summarized:

TCP window size: 27.9 KByte (default)
 [  3]  0.0-10.0 sec  12.8 GBytes  11.0 Gbits/sec

TCP window size:  416 KByte (WARNING: requested  500 KByte)
[  3]  0.0-10.0 sec  8.19 GBytes  7.03 Gbits/sec

TCP window size:  250 KByte (WARNING: requested  125 KByte)
 [  3]  0.0-10.0 sec  4.99 GBytes  4.29 Gbits/sec

I'm guessing that there are some settings I can change to increase the ipoib performance on my systems.  Using rspreload, I get:

LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so iperf -c 192.168.0.103
TCP window size:  512 KByte (default)
[  3]  0.0-10.0 sec  28.3 GBytes  24.3 Gbits/sec

It seems that ipoib bandwidth should be close to rsockets, similar to what you see.  I also don't understand the effect that the TCP window size is having on the results.  The smallest window gives the best bandwidth for ipoib?!

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
