From: "Rupert Dance" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Subject: RE: Slow performance with librspreload.so
Date: Sun, 1 Sep 2013 09:28:33 -0400
Message-ID: <003701cea717$28616140$792423c0$@soft-forge.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>	<CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com>	<CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9C6B@ORSMSX109.amr.corp.intel.com>	<CAJH6TXiYLKt3b1UFsZt7uFwDbWcDFnHNnS8CTO24Gt-2zn+Qiw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9D8A@ORSMSX109.amr.corp.intel.com>	<CAJH6TXhWWMBbopDLZY2+rrNOm2m5gcmObj7Sr16u2qrNW_NHgw@mail.gmail.com>	<CAJH6TXgR=wVG
 yyHrpTKkBw-5M=A9-tGzjpYcV6NWpk8uKvFn8Q@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CAA11B@ORSMSX109.amr.corp.intel.com>	<CAJH6TXgu4L8gnqQX1fKZ=ioZDxUMnj=s3h0qkYh1_35VWpMJ1g@mail.gmai!
 l.com>	<000c01cea63e$1e
	20eae0$5a62c0a0$@soft-forge.com> <CAJH6TXiOToa2-EOj6Hz-rkVHt3tCSh4jnLbKZs69GhT7dFeH0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXiOToa2-EOj6Hz-rkVHt3tCSh4jnLbKZs69GhT7dFeH0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Gandalf Corvotempesta' <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

My guess is that it will not make a huge difference and that the solution
lies elsewhere.

-----Original Message-----
From: Gandalf Corvotempesta [mailto:gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
Sent: Saturday, August 31, 2013 3:51 PM
To: Rupert Dance
Cc: Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Slow performance with librspreload.so

2013/8/31 Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>:
> The Vendor ID indicates that this is a Voltaire card which probably 
> means it is an older card. Some of the early Mellanox based cards did 
> not support anything bigger than 2048.

Yes, it's an older card used just for this test.
By the way, increasing MTU to 4096 will give me more performance?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
