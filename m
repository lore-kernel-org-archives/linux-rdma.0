From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 0/6] RDMA core and mlx5 fixes and
 refactoring for 4.15
Date: Wed, 18 Oct 2017 18:40:06 +0300
Message-ID: <20171018154006.GS2106@mtr-leonro.local>
References: <20171016054517.30643-1-leon@kernel.org>
 <1508340309.46071.76.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vrIGRKnBmQs2THAk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508340309.46071.76.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vrIGRKnBmQs2THAk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 18, 2017 at 11:25:09AM -0400, Doug Ledford wrote:
> On Mon, 2017-10-16 at 08:45 +0300, Leon Romanovsky wrote:
> > The patches are available in the git repository at:
> >   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> > tags/rdma-next-2017-10-16
>
> This branch is unpullable for me.  Trying to pull this on top of the
> shared pull request brings in a ton of other stuff.  My diffstat ends
> up looking like this:

<....>

>
> So, with a shared pull request, your submissions either need to be
> against that shared pull request, or against my for-next, and you need
> to let me know which one it is.

I didn't know that you are using this as a pull request, we tried it in
last cycle and it didn't truly work, so I stopped it and changed the title
(instead of pull requests, it is patches now), removed invitation to pull from
the cover letter and prepared the series (with tags) as standalone patches
and not as pull request.

>
> I can grab these out of patchworks, but even that way I still need you
> to be clear about what tree/branch these are intended to be applied to.

It should apply cleanly as patches grabbed from the patchworks and if
for any reasons it doesn't work for you, please drop it and I'll resubmit.

Pull requests model works for truly serial submission and it is not the
case now.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--vrIGRKnBmQs2THAk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnnddYACgkQ5GN7iDZy
WKdyMBAAlKH7HRRCSt3ccueraNqk2YuwhA03UuNdr4flB3mKGQUk/V2yRkZb/yHM
NrWTDPn7QoOSra8Id2K7WGsx/azFdSRyz4EMguujDMhXNAl+yFXAe2XlqZ1dC98S
jKIkE/CDHprwonZl8RZYNs5n1asQ3iDVx1wXq4QEbPJAjDyxRj/+utEEbvK4JirZ
1a4WhiXn03EQ9K6mBvYdSw0Bsw1Ai6Mzgi0Euh0XPirxcvF1H6jFLZb0xc3DwSt+
+9LGt4kYo1TdI9OGtTQF/yQXHrtC6YbmWjydFsqlw+Vm0BRYfRx+vh3aHn0BoL0v
tBsCUm6T/rKKCdgkRpd5rnS8+XnWXLw6CwEKnZ2A0XIq+sk/wT+Q+9sFSyeS1zUj
ienuDP2Wbm1G2XGNs/9gxy9vwi+hD/O0Gi50peUfH+6XZ2a4OXQCHF1TZCRE954y
u8pgXMEoqW1qiuYBEWWmxNX6Tn9v9MZL0F6nw/ip2+FIlvqAYXh0BZ9gwykTSUBH
UiM8qPSBOSBT/dkCQCpbH71Lg/lTZrXD/XmeJx1u1UuQifrFIudlu8cvuupRs3p9
a9+E0gprG5IbiVIXauPZWBDPmCynSsQNLHi4haafbEsLhFrKQFokLVo2d8TGHE4z
s24izu1OyvPtGwxwzYFz9S80b3fhWZJ37Wa9aS+ZrKdchKoDSVQ=
=GBfM
-----END PGP SIGNATURE-----

--vrIGRKnBmQs2THAk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
