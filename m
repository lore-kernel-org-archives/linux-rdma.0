From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/47] IB/cm: Suppress gcc 7 fall-through complaints
Date: Tue, 10 Oct 2017 22:31:27 +0300
Message-ID: <20171010193127.GK2106@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-3-bart.vanassche@wdc.com>
 <849d304a-fa89-0d6a-6edb-cf34780e41a8@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PEfPc/DjvCj+JzNg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <849d304a-fa89-0d6a-6edb-cf34780e41a8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PEfPc/DjvCj+JzNg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 03:27:11PM -0400, Dennis Dalessandro wrote:
> On 10/6/2017 5:32 PM, Bart Van Assche wrote:
> > Avoid that gcc 7 reports the following warning when building with W=1:
> >
> > warning: this statement may fall through [-Wimplicit-fallthrough=]
> >
> > Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >   drivers/infiniband/core/cm.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> > index d80911d4abb7..5927ee4e57ca 100644
> > --- a/drivers/infiniband/core/cm.c
> > +++ b/drivers/infiniband/core/cm.c
> > @@ -2808,6 +2808,7 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
> >   			msg_response = CM_MSG_RESPONSE_OTHER;
> >   			break;
> >   		}
> > +		/* fall through */
> >   	default:
> >   		ret = -EINVAL;
> >   		goto error1;
> >
>
> So adding the comment is enough to make gcc shut up? Or are you just
> annotating the code so it's obvious it was intentional?

GCC is looking for the specific comment.
---
-Wimplicit-fallthrough warns when a switch case falls through.
This warning has five different levels. The compiler is able to parse a wide range of fallthrough comments,
depending on the level. It also handles control-flow statements, such as ifs.
It's possible to suppress the warning by either adding a fallthrough comment,
or by using a null statement: __attribute__ ((fallthrough)); (C, C++),
or [[fallthrough]]; (C++17), or [[gnu::fallthrough]]; (C++11/C++14).
---
https://gcc.gnu.org/gcc-7/changes.html

Thanks

>
> -Dennis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--PEfPc/DjvCj+JzNg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlndIA8ACgkQ5GN7iDZy
WKfTlg//UqQPd+x3EPDyZNFSX4Gs3EAXg62b8ZxTBBAXGzFgCIwiHHN4gLstpxqX
O9exbuQ1wflvFognmwyW8O/52sp4QCP8POiJrugfjQP4L3cw9HoeqcMMF5AMIXc+
5TZEBPhQYaCMm8wwQENRIsoobrajbPerL2GlIqxqeMOcVkxe6TWLUCkcSKS2CRwt
SmIXfxDmhnQsEza6gZxId0TR6RK3NqrGtZmOlpj18tOjGBPiMjxIOL2vyKwiIqGt
DKrgbOvotDcVuf8eT5ZRqeYAiBnC7a+jAh+nmbPocVLVcoFOOnfKeKyMEekIfyD8
/qHwKPetDFUmtFjWNfKItLSfUEmcwnUh0vhmjGJifFUKnUjA1ZI4y+ufwrjh3YnM
iuYcCGhJ4BCpudfZCn+ybU6yJl92/ZGa30c/1/3FDYmmGFBVZO6PYyVK2s36u0rJ
TW5diS8xZXPtceN+cRk1TVCGJqvTonwgITlIO8C0qCFcZvfqMFnf7b/k733V/gz0
W3L389FzHl5n0pJXcMWLMsA3q6jlTQWQbXSOZc724k3whUlj0kwvRUiQGyQ7SiXv
t6fFumkMdzQua+S4wJWp+ZG3M6bnnWHM/vpKa6PErDz0yZlZd2JaT/pZPGuUGOsR
Ag2M79JeDjDXa4zIbvJHLNxRmLMQoXeYVM/r6/UGIueJnjCGcY4=
=2YLo
-----END PGP SIGNATURE-----

--PEfPc/DjvCj+JzNg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
