From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/core, rdmavt, hfi1: Send OPA cap_mask3
 in trap
Date: Wed, 31 May 2017 07:32:35 +0300
Message-ID: <20170531043235.GH5406@mtr-leonro.local>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
 <20170526123536.8158.237.stgit@scvm10.sc.intel.com>
 <20170529161407.GB17751@mtr-leonro.local>
 <2fc7a7d6-9ba3-2365-45e3-946f56827dd9@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0Ed1hDcWxc3B7cn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2fc7a7d6-9ba3-2365-45e3-946f56827dd9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Henry, Michael N" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--y0Ed1hDcWxc3B7cn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 11:32:22AM -0700, Henry, Michael N wrote:
> On 5/29/2017 9:14 AM, Leon Romanovsky wrote:
> > On Fri, May 26, 2017 at 05:35:37AM -0700, Dennis Dalessandro wrote:
> > > From: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > Provide the ability for IB clients to modify the OPA specific
> > > capability mask and include this mask in the subsequent trap data.
> > >
> > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > index 785e927..6c4f6da 100644
> > > --- a/include/rdma/ib_verbs.h
> > > +++ b/include/rdma/ib_verbs.h
> > > @@ -576,7 +576,8 @@ struct ib_device_modify {
> > >   enum ib_port_modify_flags {
> > >   	IB_PORT_SHUTDOWN		= 1,
> > >   	IB_PORT_INIT_TYPE		= (1<<2),
> > > -	IB_PORT_RESET_QKEY_CNTR		= (1<<3)
> > > +	IB_PORT_RESET_QKEY_CNTR		= (1<<3),
> > > +	IB_PORT_OPA_MASK_CHG		= (1<<4)
> > How will this flag be set?
> >
> This flag can be set as the port_modify_mask when calling ib_modify_port(..)

My question is more general. I'm as a representative of these "IB
clients" would like to know when and why should I use this flag.

Thanks

>
> -Mike
>

--y0Ed1hDcWxc3B7cn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkuR2MACgkQ5GN7iDZy
WKfy/BAAkcmj5xxjKpKCRYCx2Brsf6SD36P4aMpe2xnOGKqLlP9xDbEkgwv63ru2
wgrJBkit4BjKwF9voYetwYidCZZDF6dAOFVFca+SLzX0f5Yu96AnBKOEO9UrK5f4
Dpfo8jTef5tc4kCES5tlNEdmAAS2XJndrCvRfrRr4qSUy+DUDAsc/D4g/yrHnaIp
Z2OCApqUPcO7UbPUT9TvYJJK0jyolurs6llZkgln2ShedfnvK50ZesB3rU2w/0S+
3ceiH+NfpDz373v1g1AEZHN9AnPuX5sy1550poAhkrFO/fc8A3RwT0mk4SHw/q6S
Qde8Hb9wmqfgmLbwjMvZUpaUm4tg3/ccMP6W0nOiMHHNnVuUEeE3Z0XYdf65Uq6F
rc3ZZQbZcDPZS/lWoyTi+0oP+g2EqZtzDAZV5bC+fLxGY9H7BzapykhfGeDPer0z
NnNM8H1N2iTSBKO03lZvuWXy+mjEWHX8YHNPQQFpWnLi8t/H4VMP2NIMq6RmALeH
gdWphH9IdQSgKWgMhNG8xS4jy7k5Z1g+nZD2uBZ3EW1E6Chf93gh2HhGnpBPQ2Bk
FdK66qz+73QBRKUhfDGP2Ui6kEokKWBl1S4og6mQd8vjb8EnpLphmvRpOnpFkUWs
TI9hZw9XeU58flmgQPS5BYxSYfVGm3pyuj+yFbREzm6aIbeSCQg=
=+4si
-----END PGP SIGNATURE-----

--y0Ed1hDcWxc3B7cn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
