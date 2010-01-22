From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problems using krping
Date: Fri, 22 Jan 2010 09:16:10 -0600
Message-ID: <4B59C13A.2090106@opengridcomputing.com>
References: <201001211807011710722@inspur.com> <201001221533186875550@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001221533186875550-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


lihaidong wrote:
> Mr.Wise:
>  Sorry to Bother you Another problem.
>  fastreg(Must with local_dma_key to avoid using ib_reg_phys_mr in my=20
> case) with read_inv succeed, yet with server_inv failed.
> =20
> What does=20
> 'krping: cq completion failed with wr_id 0 status 6 opcode -1 vender_=
err 78' =20
> in client dmesg info mean?


Maybe the mlx4 experts can comment on status 6 vender_err 78?


> Why data transferring happened before server waked up from waiting fo=
r=20
> CONNECTED?


This can happen.  There is a race between getting the CONNECTED event=20
and the first incoming data completion (like a recv completion).=20


> Client demsg:
> krping: proc write |client,addr=3D10.10.10.15,port=3D8888,count=3D1,v=
erbose,local_dma_lkey,mem_mode=3Dfastreg,server_inv|
> client
> ipaddr (10.10.10.15)
> port 8888
> count 1
> verbose
> using local dma lkey
> created cm_id ffff88013cd11000
> cma_event type 0 cma_id ffff88013cd11000 (parent)
> cma_event type 2 cma_id ffff88013cd11000 (parent)
> Fastreg supported - device_cap_flags 0x7c9c76
> rdma_resolve_addr - rdma_resolve_route successful
> created pd ffff88012a9fff80
> created cq ffff8801305d5400
> created qp ffff8801305d5800
> krping: krping_setup_buffers called on cb ffff88013cd11800
> krping: fastreg rkey 0x88001a00 page_list ffff88012b3cee80 page_list_=
len 1
> krping: allocated & registered buffers...
> cma_event type 9 cma_id ffff88013cd11000 (parent)
> ESTABLISHED
> rdma_connect successful
> krping: page_list[0] 0x12a40c000
> krping: post_inv =3D 0, fastreg new rkey 0x88001a01 shift 12 len 64 i=
ova_start 12a40c180 page_list_len 1
> RDMA addr 12a40c180 rkey 88001a01 len 64
> krping: cq completion failed with wr_id 0 status 6 opcode -1 vender_e=
rr 78
> krping: cq completion in ERROR state
> krping: krping_format_send failed
> krping_free_buffers called on cb ffff88013cd11800
> destroy cm_id ffff88013cd11000
> =20
> Server dmesg:
> krping: proc write |server,addr=3D10.10.10.15,port=3D8888,count=3D1,v=
erbose,local_dma_lkey,mem_mode=3Dfastreg,server_inv|
> server
> ipaddr (10.10.10.15)
> port 8888
> count 1
> verbose
> using local dma lkey
> created cm_id ffff88007e3c5c00
> rdma_bind_addr successful
> rdma_listen
> cma_event type 4 cma_id ffff88003e0dac00 (child)
> child cma ffff88003e0dac00
> Fastreg supported - device_cap_flags 0x7c9c76
> created pd ffff880035d17d20
> created cq ffff88001e0f9e00
> created qp ffff88001e0f9c00
> krping: krping_setup_buffers called on cb ffff88007e2b0000
> krping: fastreg rkey 0x68001d00 page_list ffff8800027ab580 page_list_=
len 1
> krping: allocated & registered buffers...
> accepting client connection request
> cma_event type 9 cma_id ffff88003e0dac00 (child)
> ESTABLISHED
> cma_event type 10 cma_id ffff88003e0dac00 (child)
> krping: DISCONNECT EVENT...
> krping: wait for CONNECTED state 10
> krping: connect error -1
> krping_free_buffers called on cb ffff88007e2b0000
> destroy cm_id ffff88007e3c5c00
> 2010-01-22
> ---------------------------------------------------------------------=
---
> lihaidong
> ---------------------------------------------------------------------=
---
> *=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A* Steve Wise
> *=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A* 2010-01-21  06:43:30
> *=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A* lihaidong
> *=E6=8A=84=E9=80=81=EF=BC=9A* linux-rdma
> *=E4=B8=BB=E9=A2=98=EF=BC=9A* Re: Problems using krping
> It appears the MLX4 driver does not support kernel mode memory region=
s. =20
> You'll have to use dma mrs or fast_reg mrs with that device.
> Steve.
> lihaidong wrote:
> > Mr.Wise:
> > =20
> > When using mr mode as the memory registration method, krping failed=
 to=20
> > get memory region using ib_reg_phys_mr().Could you help me, please?
> > =20
> > dmesg:
> > krping_init
> > krping: proc write |client,addr=3D10.10.10.15,mem_mode=3Dmr,port=3D=
9999,count=3D1,verbose|
> > client
> > ipaddr (10.10.10.15)
> > port 9999
> > count 1
> > verbose
> > created cm_id ffff88013c74c800
> > cma_event type 0 cma_id ffff88013c74c800 (parent)
> > cma_event type 2 cma_id ffff88013c74c800 (parent)
> > rdma_resolve_addr - rdma_resolve_route successful
> > created pd ffff880133845280
> > created cq ffff88013c1ff400
> > created qp ffff88013c1ffe00
> > krping: krping_setup_buffers called on cb ffff88013c59f800
> > krping: recv buf dma_addr 13c59f968 size 16
> > krping: recv_buf reg_mr failed
> > krping: krping_setup_buffers failed: -38
> > destroy cm_id ffff88013c74c800
> > krping: proc write |client,addr=3D10.10.10.15,mem_mode=3Dmr,port=3D=
9999,count=3D1,verbose|
> > client
> > ipaddr (10.10.10.15)
> > port 9999
> > count 1
> > verbose
> > created cm_id ffff88013c59f800
> > cma_event type 0 cma_id ffff88013c59f800 (parent)
> > cma_event type 2 cma_id ffff88013c59f800 (parent)
> > rdma_resolve_addr - rdma_resolve_route successful
> > created pd ffff88012f5964a0
> > created cq ffff88012faee400
> > created qp ffff88012faeec00
> > krping: krping_setup_buffers called on cb ffff88013c71d400
> > krping: recv buf dma_addr 13c71d568 size 16
> > krping: recv_buf reg_mr failed
> > krping: krping_setup_buffers failed: -38
> > destroy cm_id ffff88013c59f800
> > =20
> > =20
> > echo "client,addr=3D10.10.10.15,mem_mode=3Dmr,port=3D9999,count=3D1=
" > /proc/krping=20
> >
> > echo "server,addr=3D10.10.10.15,mem_mode=3Dmr,port=3D9999" > /proc/=
krping
> > =20
> > Using OFED-1.5 ofa_kernel-1.5
> > HardWare:Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s=
 - IB QDR / 10GigE]=20
> >
> > put krping source files into drivers/infiniband/hw/mlx4
> > =20
> > 2010-01-21
> > -------------------------------------------------------------------=
-----
> > lihaidong
> __________ Information from ESET NOD32 Antivirus, version of virus si=
gnature database 4788 (20100120) __________
> The message was checked by ESET NOD32 Antivirus.
> http://www.eset.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
