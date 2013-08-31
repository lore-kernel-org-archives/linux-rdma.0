From: "Rupert Dance" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Subject: RE: Slow performance with librspreload.so
Date: Sat, 31 Aug 2013 07:34:55 -0400
Message-ID: <000c01cea63e$1e20eae0$5a62c0a0$@soft-forge.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>	<CAJH6TXjEx+41G_7wvQybMXzb60tu-ha2d2Bu_J_erNDPJRbQFw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com>	<CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com>	<CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9C6B@ORSMSX109.amr.corp.intel.com>	<CAJH6TXiYLKt3b1UFsZt7uFwDbWcDFnHNnS8CTO24Gt-2zn+Qiw@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CA9D8A@ORSMSX109.amr.corp.intel.com>	<CAJH6TXhWWMBbopDLZY2+rrNOm2m5gcmObj7Sr16u2qrNW_NHgw@mail.gmail.com>	<CAJH6TXgR=wVG
 yyHrpTKkBw-5M=A9-tGzjpYcV6NWpk8uKvFn8Q@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A8237388CAA11B@ORSMSX109.amr.corp.intel.com>	<CAJH6TXgvViraH4SEcYydCerGyM6kK61eoiaENCy6PSf_1ocSVA@mail.gmai!
 l.com>	<00ac01cea5ad$8c
	e92d20$a6bb8760$@soft-forge.com> <CAJH6TXgu4L8gnqQX1fKZ=ioZDxUMnj=s3h0qkYh1_35VWpMJ1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgu4L8gnqQX1fKZ=ioZDxUMnj=s3h0qkYh1_35VWpMJ1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Gandalf Corvotempesta' <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Vendor ID indicates that this is a Voltaire card which probably means it
is an older card. Some of the early Mellanox based cards did not support
anything bigger than 2048. 

  00-08-F1   (hex)		Voltaire
  0008F1     (base 16)		Voltaire
  				9 Hamenofim st.
				Herzelia  46725
				ISRAEL

Checking for FW updates cannot hurt but you may well be restricted to 2048

-----Original Message-----
From: Gandalf Corvotempesta [mailto:gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
Sent: Saturday, August 31, 2013 5:21 AM
To: Rupert Dance
Cc: Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Slow performance with librspreload.so

2013/8/30 Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>:
> One way to set or check mtu is with the ibportstate utility:
>
> Usage: ibportstate [options] <dest dr_path|lid|guid> <portnum> [<op>] 
> Supported ops: enable, disable, reset, speed, width, query, down, arm, 
> active, vls, mtu, lid, smlid, lmc

I've tried but max MTU is 2048 on one device:

$ sudo ibv_devinfo
hca_id: mthca0
transport: InfiniBand (0)
fw_ver: 4.7.600
node_guid: 0008:f104:0398:14cc
sys_image_guid: 0008:f104:0398:14cf
vendor_id: 0x08f1
vendor_part_id: 25208
hw_ver: 0xA0
board_id: VLT0040010001
phys_port_cnt: 2
port: 1
state: PORT_ACTIVE (4)
max_mtu: 2048 (4)
active_mtu: 2048 (4)
sm_lid: 1
port_lid: 2
port_lmc: 0x00
link_layer: InfiniBand

any workaround? Maybe a firmware update ?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
