From: "Rupert Dance" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Subject: RE: Slow performance with librspreload.so
Date: Fri, 30 Aug 2013 14:19:59 -0400
Message-ID: <00ac01cea5ad$8ce92d20$a6bb8760$@soft-forge.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>	<CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com>	<CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9C6B@ORSMSX109.amr.corp.intel.com>	<CAJH6TXiYLKt3b1UFsZt7uFwDbWcDFnHNnS8CTO24Gt-2zn+Qiw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9D8A@ORSMSX109.amr.corp.intel.com>	<CAJH6TXhWWMBbopDLZY2+rrNOm2m5gcmObj7Sr16u2qrNW_NHgw@mail.gmail.com>	<CAJH6TXgR=wVG
 yyHrpTKkBw-5M=A9-tGzjpYcV6NWpk8uKvFn8Q@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CAA11B@ORSMSX109.amr.corp.intel.com> <CAJH6TXgvViraH4SEcYydCerGyM6kK61eoiaENCy6PSf_1ocSVA@mail.gmai!
 l.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgvViraH4SEcYydCerGyM6kK61eoiaENCy6PSf_1ocSVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Gandalf Corvotempesta' <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

One way to set or check mtu is with the ibportstate utility:

Usage: ibportstate [options] <dest dr_path|lid|guid> <portnum> [<op>]
Supported ops: enable, disable, reset, speed, width, query, down, arm,
active, vls, mtu, lid, smlid, lmc

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Gandalf Corvotempesta
Sent: Friday, August 30, 2013 12:27 PM
To: Hefty, Sean
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Slow performance with librspreload.so

2013/8/30 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> Not directly.  The ipoib mtu is usually set based on the mtu of the IB
link.  The latter does affect rsocket performance.  However if the ipoib mtu
is changed separately from the IB link mtu, it will not affect rsockets.

Actually i'm going faster with IPoIB than rsockets.
How can I change the MTU for IB link ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
