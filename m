From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Sat, 23 Feb 2019 10:49:30 +0200
Message-ID: <20190223084930.GJ23561@mtr-leonro.mtl.com>
References: <20190217170909.1178575-1-haakon.bugge@oracle.com>
 <20190222163637.GA9819@ziepe.ca>
 <afadc799-b547-5c20-64d2-75fa0f64cd9e@opengridcomputing.com>
 <C7922E85-CA43-479A-8021-DADD59FF5BE7@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Zrag5V6pnZGjLKiw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C7922E85-CA43-479A-8021-DADD59FF5BE7@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Steve Wise <swise@opengridcomputing.com>, Jason Gunthorpe <jgg@ziepe.ca>, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Zrag5V6pnZGjLKiw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2019 at 12:51:55PM -0500, Doug Ledford wrote:
>
>
> > On Feb 22, 2019, at 12:14 PM, Steve Wise <swise@opengridcomputing.com> =
wrote:
> >
> >
> > On 2/22/2019 10:36 AM, Jason Gunthorpe wrote:
> >> On Sun, Feb 17, 2019 at 06:09:09PM +0100, H=C3=A5kon Bugge wrote:
> >>> During certain workloads, the default CM response timeout is too
> >>> short, leading to excessive retries. Hence, make it configurable
> >>> through sysctl. While at it, also make number of CM retries
> >>> configurable.
> >>>
> >>> The defaults are not changed.
> >>>
> >>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
> >>> drivers/infiniband/core/cma.c | 51 ++++++++++++++++++++++++++++++-----
> >>> 1 file changed, 44 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> >>> index c43512752b8a..ce99e1cd1029 100644
> >>> +++ b/drivers/infiniband/core/cma.c
> >>> @@ -43,6 +43,7 @@
> >>> #include <linux/inetdevice.h>
> >>> #include <linux/slab.h>
> >>> #include <linux/module.h>
> >>> +#include <linux/sysctl.h>
> >>> #include <net/route.h>
> >>>
> >>> #include <net/net_namespace.h>
> >>> @@ -68,13 +69,46 @@ MODULE_AUTHOR("Sean Hefty");
> >>> MODULE_DESCRIPTION("Generic RDMA CM Agent");
> >>> MODULE_LICENSE("Dual BSD/GPL");
> >>>
> >>> -#define CMA_CM_RESPONSE_TIMEOUT 20
> >>> #define CMA_QUERY_CLASSPORT_INFO_TIMEOUT 3000
> >>> -#define CMA_MAX_CM_RETRIES 15
> >>> #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
> >>> #define CMA_IBOE_PACKET_LIFETIME 18
> >>> #define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
> >>>
> >>> +#define CMA_DFLT_CM_RESPONSE_TIMEOUT 20
> >>> +static int cma_cm_response_timeout =3D CMA_DFLT_CM_RESPONSE_TIMEOUT;
> >>> +static int cma_cm_response_timeout_min =3D 8;
> >>> +static int cma_cm_response_timeout_max =3D 31;
> >>> +#undef CMA_DFLT_CM_RESPONSE_TIMEOUT
> >>> +
> >>> +#define CMA_DFLT_MAX_CM_RETRIES 15
> >>> +static int cma_max_cm_retries =3D CMA_DFLT_MAX_CM_RETRIES;
> >>> +static int cma_max_cm_retries_min =3D 1;
> >>> +static int cma_max_cm_retries_max =3D 100;
> >>> +#undef CMA_DFLT_MAX_CM_RETRIES
> >>> +
> >>> +static struct ctl_table_header *cma_ctl_table_hdr;
> >>> +static struct ctl_table cma_ctl_table[] =3D {
> >>> +	{
> >>> +		.procname	=3D "cma_cm_response_timeout",
> >>> +		.data		=3D &cma_cm_response_timeout,
> >>> +		.maxlen		=3D sizeof(cma_cm_response_timeout),
> >>> +		.mode		=3D 0644,
> >>> +		.proc_handler	=3D proc_dointvec_minmax,
> >>> +		.extra1		=3D &cma_cm_response_timeout_min,
> >>> +		.extra2		=3D &cma_cm_response_timeout_max,
> >>> +	},
> >>> +	{
> >>> +		.procname	=3D "cma_max_cm_retries",
> >>> +		.data		=3D &cma_max_cm_retries,
> >>> +		.maxlen		=3D sizeof(cma_max_cm_retries),
> >>> +		.mode		=3D 0644,
> >>> +		.proc_handler	=3D proc_dointvec_minmax,
> >>> +		.extra1		=3D &cma_max_cm_retries_min,
> >>> +		.extra2		=3D &cma_max_cm_retries_max,
> >>> +	},
> >>> +	{ }
> >>> +};
> >> Is sysctl the right approach here? Should it be rdma tool instead?
> >>
> >> Jason
> >
> > There are other rdma sysctls currently:  net.rdma_ucm.max_backlog and
> > net.iw_cm.default_backlog.  The core network stack seems to use sysctl
> > and not ip tool to set basically globals.
> >
> > To use rdma tool, we'd have to have some concept of a "module" object, I
> > guess.  IE there's dev, link, and resource rdma tool objects currently.
> > But these cma timeout settings are really not per dev, link, nor a
> > resource.   Maybe we have just a "core" object:  rdma core set
> > cma_max_cm_retries min 8 max 30.
>
> I don=E2=80=99t know, I think you make a fairly good argument for leaving=
 it as a sysctl.  We have infrastructure in place for admins to set persist=
ent sysctl settings.  The per device/link settings need something different=
 because link names and such can change.  Since these are globals, I=E2=80=
=99d leave them where they are.
>

I have patches from Parav which extend rdmatool to set global to whole
stack parameters, something like "rdma system ...", so the option to
set through rdmatool global parameters for modules e.g. "rdma system cma se=
t ..."
exists. But I'm not sure if it is right thing to do.

> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>
>
>
>
>
>
>



--Zrag5V6pnZGjLKiw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJccQkaAAoJEORje4g2clinKGMP/1WTMBxq8GTQD2lnIFTMyrzC
YeXQ9H7MAvM+4aQ45KU2F85hf5dJEBoayu2+aacCphwme3YApLEh4UmKKtiPjJ0q
6N5/NO7Ru6Li3nI5kXzQka5AMnAPIoX9YaSDF8jOKQHWYSb2c2sse0Jld+Dt4iYl
Qi1aK7ZSJT3pF5En2nAAwPXbmRk80bFFpocCTkLqhJEJ3Zt73K9l3+LP0B3LS16r
C784cabgxkvbPkkc67YDLzixnuuTwsDu819drTi4edp87J5tHyj/BCtZclNu+ZiT
15y65Ma+wW0SLt9BBl+K5KwqX3JfqoM7oX47eGrWpe1C+9kdaDSdCFe0SeN/wxSg
/FL8ucw551hwYwKx5yPF38Jfkt7kJv/NlhBbOmqucTDCIGd6us0F5e4ixJhh5hA7
wBV6tQESgtugWAdiHz6Pu1yAWXiOQuoekhmGxNf33Yt5Fe4QRs8i+uj+iIrLhQ8B
mj9kpIFmR17w9OYhVU118wFuDiERM6LuVkyPN1jaVWwIXfvoSt44e/4gqkLW+Htk
ioqjLbuzuu5zzzcUP4X2gsm//vJreglT6EjhMgDiTtWkOdSDn3hQj3Pm7aMhUYXm
fnrdhkSCgGFdbStKL1EYwjC4rJE97cjM3YUqzEtAmwWmBz3d+vD3sF7hoUVYgk0B
eKC4tCVyUQ0Ao4Cquefr
=Rw17
-----END PGP SIGNATURE-----

--Zrag5V6pnZGjLKiw--
