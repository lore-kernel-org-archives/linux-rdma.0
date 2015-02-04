From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: CUDA not working with ib_write_bw
Date: Wed, 4 Feb 2015 09:16:06 -0600
Message-ID: <000001d0408d$7f985340$7ec8f9c0$@opengridcomputing.com>
References: <000f01d03f01$2eb315b0$8c194110$@opengridcomputing.com> <E51087C8852F7244A3C5126F7988F0D36A0DAF90@nkgeml511-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E51087C8852F7244A3C5126F7988F0D36A0DAF90-gH8YcUvTLkOF0yysJWCP+gK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Zhangfengwei' <fngw.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Stephen Bates' <Stephen.Bates-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I want to RDMA to/from gpu memory from a remote peer.  So the data arri=
ves at the RDMA device from the wire, and is DMA'd directly
to GPU memory of the peer adapter in the system.



> -----Original Message-----
> From: Zhangfengwei [mailto:fngw.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, February 04, 2015 12:42 AM
> To: Steve Wise; gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Stephen Bates
> Subject: =B4=F0=B8=B4: CUDA not working with ib_write_bw
>=20
> Hi Steve=A3=AC
>=20
> Do you want to transfer the data to the gpu buffer directly ? I guess=
 the DMA seems not to do this all by itself.
>=20
> -----=D3=CA=BC=FE=D4=AD=BC=FE-----
> =B7=A2=BC=FE=C8=CB: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rd=
ma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] =B4=FA=B1=ED Steve Wise
> =B7=A2=CB=CD=CA=B1=BC=E4: 2015=C4=EA2=D4=C22=C8=D5 23:59
> =CA=D5=BC=FE=C8=CB: gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
> =B3=AD=CB=CD: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Stephen Bates
> =D6=F7=CC=E2: CUDA not working with ib_write_bw
>=20
> Hey Gil,
>=20
> I'm trying to test iWARP RDMA <-> GPU memory and I compiled CUDA into=
 the top-o-tree perftest repo.  My Nvidia setup is working
> because I have verified it with another gpu rdma package (donard from=
 pmc).  But when using ib_write_bw the server gets an error
> registering the gpu memory with the device.  Below is the output from=
 ib_write_bw.  I instrumented the kernel registration path
and I find
> that get_user_pages() is returning -14 (-EFAULT) when called by ib_um=
em_get().
>=20
> Q:  Is this supposed to work with the upstream RDMA drivers?   I'm us=
ing a 3.16.3 kernel.org kernel.
>=20
> Thanks,
>=20
> Steve
> ---
>=20
> [root@stevo1 perftest]# ./ib_write_bw -R --use_cuda
>=20
> ************************************
> * Waiting for client to connect... *
> ************************************
> ---------------------------------------------------------------------=
------------------
>                     RDMA_Write BW Test
>  Dual-port       : OFF          Device         : cxgb4_1
>  Number of qps   : 1            Transport type : IW
>  Connection type : RC           Using SRQ      : OFF
>  CQ Moderation   : 100
>  Mtu             : 1024[B]
>  Link type       : Ethernet
>  Gid index       : 0
>  Max inline data : 0[B]
>  rdma_cm QPs     : ON
>  Data ex. method : rdma_cm
> ---------------------------------------------------------------------=
------------------
>  Waiting for client rdma_cm QP to connect  Please run the same comman=
d with the IB/RoCE interface IP
> ---------------------------------------------------------------------=
------------------
> initializing CUDA
> There is 1 device supporting CUDA
> [pid =3D 14124, dev =3D 0] device name =3D [Tesla K20Xm] creating CUD=
A Ctx making it the current CUDA Ctx
> cuMemAlloc() of a 131072 bytes GPU buffer allocated GPU buffer addres=
s at 0000001304260000 pointer=3D0x1304260000 Couldn't allocate
> MR  Unable to create the resources needed by comm struct Unable to pe=
rform rdma_client function
> [root@stevo1 perftest]#
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
