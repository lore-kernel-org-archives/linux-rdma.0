From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 02/11] IB/hfi1: Check return value of strchr
 before using it
Date: Wed, 3 Jan 2018 17:27:21 +0200
Message-ID: <20180103152721.GT10145@mtr-leonro.local>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035621.2126.23093.stgit@scvm10.sc.intel.com>
 <20171220082555.GN2942@mtr-leonro.local>
 <f5849e2b-c8cd-b93b-f32f-f423bff9ae31@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="de1H0RjRxOSdb4we"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f5849e2b-c8cd-b93b-f32f-f423bff9ae31-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--de1H0RjRxOSdb4we
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 10:05:56AM -0500, Dennis Dalessandro wrote:
> On 12/20/2017 3:25 AM, Leon Romanovsky wrote:
> > On Mon, Dec 18, 2017 at 07:56:23PM -0800, Dennis Dalessandro wrote:
> > > The call to strchr in our counter initialization does not check the return
> > > value before attempting to use the pointer. In theory this should not
> > > happen given the way the code is structured but do the smart thing and
> > > check the value anyway to harden the code.
> >
> > The smartest way is to get rid of the whole "\n"<->"\0" logic and
> > copy/paste mlx5 implementation which does the same thing but statically
> > and much safer than here.
> >
> > Thanks
> >
>
> Not sure I'd agree. Is there something unsafe about the code here? The hole
> is plugged. Changing the entire implementation for a copy/paste job doesn't
> seem like a good thing to me.

The names are static and can't be changed. IMHO, the whole
implementation is overkill.

Thanks

>
> -Denny

--de1H0RjRxOSdb4we
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpM9lkACgkQ5GN7iDZy
WKcFMg//SiZK6MlG2wIegt9SjHfuEYmaW2AGZJ+FZIQiCwNpQ4sIIeaLSc65b9IB
UN4mUBVvMNjsrjCcS9/gGHjyYTgbjMCDrFeRvFevLKSGSm+IT9JoftfGUZ8oXXDo
+IYpte90ahwgQQVELVCpl6QsqWMOpP0k4VjoXz/0iIhvrCnfqBVO2wAfaU9GJ4dj
nItEP0fMYBDdIcfFmBvFoFQdryme3EZzr/NwFxfsjfB8joebdEqnBBKX9XRUY7D5
rQ+ZNs3DFvZvPaSzd6OO0qRQOn20Ams7XT2RKEMIic+K+Xf2ajHcDS2RiF7TaALk
42EQMO+vkMUWyIib+d4A+LNvP496WVisTzD0CB+J0rQW21icxwpXDLUer0NxZS84
X+09nHj2S5vIrrp86KaSsg/GfKL3ZAlAFYLZdUL0oBJR9i5BKeDfj1ZamerKzVLw
lriFOOHiEqEdcQbQ1819Hrd1UGi1Ms2g10sJTRvx3vse2mjgj7Gihvg2+Xrq/9NJ
PMvX3kCVMTZC7Y5YpnPU6lOPGkvhRn1vLasdS//XxEZTdd3GYPXBnZaaQA6EgKSa
SCVqXcg2p77JVM7wS3QMmYR7Cj05/i4soIiSLDDdChcxc940DIoIYlU/ZpiFlTl1
7mOBgURR3w9zEh4Qi1eDeznmbygAA9GvFqCa4LkUSbn64toRXCs=
=ytPp
-----END PGP SIGNATURE-----

--de1H0RjRxOSdb4we--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
