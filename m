From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: MLX4 Interrupt Load-Balancing
Date: Fri, 11 Feb 2011 14:41:15 +0200
Message-ID: <20110211124115.GA4119@mtldesk30>
References: <AANLkTi=Cguhde9-XXFMdrJ966SfGRKeb5K7KBH_ROZtC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=Cguhde9-XXFMdrJ966SfGRKeb5K7KBH_ROZtC-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Carlier <chronidev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 09, 2011 at 07:36:10PM +0100, Nicolas Carlier wrote:
> Hi,
>=20
> I use a dual-proc X5670 box without hyperthreading, so I have 12
> cores. I use a connectx2 card, with ofed-1.5.2, essentially to make
> multicast on IpOIb. I'm on a kernel 2.6.18-164.el5.
>=20
> First question:
>=20
> Why I have this type message during the boot ?
>=20
> "mlx4_core 0000:03:00.0: Requested 25 vectors, but only 14 MSI-X
> vectors available, trying again"
That's because mlx4 will try to allocate two vectors per CPU core and
another one for asynchronous events. The kernel is "willing" to give
fewer vectors. So mlx4_core will try to allocate as much as kernel
gives. IPoIB does not make use of the multitude of vectors; they are
used by mlx4_en which is the ConnectX ethernet driver.

>=20
> I thought that the drivers doesn't try to get more vectors than cpu
> cores. In spite of this message the driver is loaded with MSI-X
> capabilities.
>=20
>=20
> So my second question:
>=20
> Why when I look at the "/proc/interrupts", I don't have the impressio=
n
> that the load balancing is effective. I have the habit to use steerin=
g
> on ethernet adapters, but the behaviour doesn't corresponding.=A0 I
> receive all the interrupts on the first "queue" as show the result of
> "cat /proc/interrupts=A0 | grep mlx".
>=20
> =A051:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-9
> =A059:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-10
> =A067:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-11
> =A075:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-12
> =A083:=A0=A0=A0=A0 223042=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0 1091=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 mlx4_core(async)
> 170:=A0=A0=A0=A0=A0=A0=A0=A0 72=A0=A0 39800564=A0=A0 17641698=A0=A0=A0=
=A0=A0 80102=A0=A0=A0=A0 769072=A0 103351470
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0 17232132
>  PCI-MSI-X=A0 eth-mlx4-0
> 178:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-1
> 186:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-2
> 194:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-3
> 202:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-4
> 210:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-5
> 218:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-6
> 226:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-7
> 234:=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
> =A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
>  PCI-MSI-X=A0 eth-mlx4-8
>=20
>=20
>=20
> Thanks for the answer,
>=20
> Best regards.
> N=8B=A7=B2=E6=ECr=B8=9By=FA=E8=9A=D8b=B2X=AC=B6=C7=A7v=D8^=96)=DE=BA{=
=2En=C7+=89=B7=A5=8A{=B1=AD=D9=9A=8A{ay=BA=1D=CA=87=DA=99=EB,j=07=AD=A2=
f=A3=A2=B7h=9A=8B=E0z=B9=1E=AEw=A5=A2=B8=0C=A2=B7=A6j:+v=89=A8=8Aw=E8j=D8=
m=B6=9F=FF=BE=07=AB=91=EA=E7zZ+=83=F9=9A=8E=8A=DD=A2j"=9D=FA!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
