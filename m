From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Mon, 25 Sep 2017 06:59:10 +0300
Message-ID: <20170925035910.GL25094@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FnOKg9Ah4tDwTfQS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506179005.120853.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:

<...>

>
> I want any shared pull requests to be based on nothing newer than an
> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
> request is on something later it will pollute my main for-next branch
> to merge it.  I plan to merge my own -rc pull requests after rc2 into
> my for-next branch, so you won't be missing code that goes into later
> rcs if you base your work on my for-next branch, so that's a second
> alternative starting point for your shared pull requests should you
> need it.

=46rom our experience, it is not feasible to demand shared pull
requests on "newer than an rc2 kernel". The magic of shared pull request
is in the fact that it is based on the same origin for both trees.

In our case the same origin is Linus's tree and his official -rcX, which
for sure will be in both trees.

Once shared pull request is based on that tree, it will apply cleanly
on both netdev and RDMA without pollution of the trees.

And again, shared pull request shouldn't be based on any patches
accepted to netdev and/or RDMA which are not in Linus's tree.

Thanks

--FnOKg9Ah4tDwTfQS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnIfw4ACgkQ5GN7iDZy
WKdCwQ/9FWbr+Yg3mjBCOd3NlW95nd3IKLU/bNVcErq0vyttavfUpjo5KCGjq2tn
pxVAUVw4BD7Jm6zAXRNXwitUSHtX4mrepo3/JhToXZrJedxCGXYq2XTSMB7Xj/EB
hXISwiq4NjMiGXyg0HvhPv547xVTWauHZN6SqicwDcPmAimGUxpQ+9F6TYFTp3gq
2xQb7gQgqzBuWAS+4XI6Up4oWqQFVOecG3KRA/ASL2ji1Vf03HAM7rIKq+I+stuZ
96bjQX/X83cs2USppTxNPjnW/KEq+jsrnd4PrSIGrPlNeF9L3wwZeMgNKgCVjT/F
cqrU4WzrhdlRCv9kl0ifUGhjvmvc+mDcRcd83/R3FVMIg3Zz/W59+XcRlEL0Ln7T
hbdRcJ22fJ9u5BiaHPPIc1y3cM+k2UxPkj8egUAFvXP7H6BpC1K/Cz3t8sGfjiyV
KpWzWN+5NCknBfy5oiCZjXuVhW+x11iVLCpfBwRLUl1zECYSenLJk7bHzdpM8goT
HWmEcI6Dc+uJ+vsYzpcI7yIMhja4wB+o6FKlMPHt7xqRdeZfLlpbGQLfZWYWPKLX
hvxde6vnXrcULy4kyGE7flzLZUOjSIsCa+tKVWhuXa0ckCguPodjeSwR5Dv9wfMv
v2/23QlQxFuBj+jDCFFG1ijCG5Kx6TT9FHsNbhb+1fqo2G1YJc8=
=WOXB
-----END PGP SIGNATURE-----

--FnOKg9Ah4tDwTfQS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
