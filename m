From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v2] [OFED] libibverbs: Support both OFED verbs and ibverbs
Date: Thu, 14 Jul 2011 16:13:08 +0300
Message-ID: <201107141613.08992.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A8237302DD1C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302DD1C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I am pleased that you are putting in the effort to enable the existing =
OFED user base to continue using its
code without changes to the XRC calls.

Regarding XRC and MPI, see below.

On Wednesday 13 July 2011 20:21, Hefty, Sean wrote:
> I was able to build and run mvapich2 successfully against libibverbs =
with
> this patch applied on top of the current XRC patches. =A0(The XRC pat=
ches are
> still undergoing work.) =A0I built mvapich2 using the following confi=
gure options:
>=20
> --with-rdma=3Dgen2 CFLAGS=3D-DOFED_VERBS
> and
> --with-rdma=3Dgen2 CFLAGS=3D'-DOFED_VERBS -D_ENABLE_XRC_
>=20
> It didn't appear that mvapichs ever used XRC
>=20
You are correct, mvapich does not use XRC.
openMPI uses XRC, so hopefully you can use openMPI to test out your XRC=
 stuff.

You can contact Jeff Squyres for details/help.

In the meantime, I include the following from the ewg list:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
On 11/08/2010 08:06 PM, Jeff Squyres wrote:
> Steve pinged me on IM this morning and told me that you want OMPI v1.=
4.3 for the next OFED release.  I just logged into www.openfabrics.org
> and apparently the server has changed -- my entire $HOME is empty.=20
>
> Where do you want me to put the new OMPI SRPM?  Alternatively, anyone=
 can grab the SRPM from the URL below
> -- there's nothing special about the SRPM for OpenFabrics that's not =
already in our community SRPM:=20
>
>      http://www.open-mpi.org/software/ompi/v1.4/
>

Hi Jeff,
The place for the Open MPI on the new server is under:
/var/www/openfabrics.org/downloads/openmpi/   (http://www.openfabrics.o=
rg/downloads/openmpi/)

I updated Open MPI version there to v1.4.3.

Regards,
Vladimir
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
