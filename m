From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Mon, 16 Sep 2013 18:18:46 +0200
Message-ID: <CAJH6TXjX+w-i-3w_XKqo2La+Dxg2nLkyjBZkiAeFc1sNySxDXw@mail.gmail.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
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
	<CAJH6TXgu4L8gnqQX1fKZ=ioZDxUMnj=s3h0qkYh1_35VWpMJ1g@mail.gmail.com>
	<000c01cea63e$1e20eae0$5a62c0a0$@soft-forge.com>
	<CAJH6TXiOToa2-EOj6Hz-rkVHt3tCSh4jnLbKZs69GhT7dFeH0A@mail.gmail.com>
	<5225D0DD.7060803@dev.mellanox.co.il>
	<CAJH6TXhSoxFshtuE0YqdVShQKSgX_wNwxekjy1+ZcGHR0vjC9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXhSoxFshtuE0YqdVShQKSgX_wNwxekjy1+ZcGHR0vjC9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/9/3 Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> $ sudo qperf -ub  172.17.0.2 rc_bi_bw rc_lat rc_bw rc_rdma_read_lat
> rc_rdma_read_bw rc_rdma_write_lat rc_rdma_write_bw tcp_lat tcp_bw
> rc_bi_bw:
>     bw  =  20.5 Gb/sec
> rc_lat:
>     latency  =  15.4 us
> rc_bw:
>     bw  =  13.7 Gb/sec
> rc_rdma_read_lat:
>     latency  =  12.9 us
> rc_rdma_read_bw:
>     bw  =  11.5 Gb/sec
> rc_rdma_write_lat:
>     latency  =  15.2 us
> rc_rdma_write_bw:
>     bw  =  13.7 Gb/sec
> tcp_lat:
>     latency  =  48.8 us
> tcp_bw:
>     bw  =  12.5 Gb/sec
>
> I don't know if they are good for a DDR fabric.

Just to clarify, why I'm getting the same bandwidth with
librspreload.so and with plain use of IPoIB ?
Should I check something ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
