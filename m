From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Tue, 21 Nov 2017 07:04:56 +0200
Message-ID: <20171121050456.GM18825@mtr-leonro.local>
References: <20171116204400.GA28216@mellanox.com>
 <20171120161016.GL18825@mtr-leonro.local>
 <20171120180631.GE626@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s6piCcVGN+AZ9P50"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171120180631.GE626-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--s6piCcVGN+AZ9P50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 20, 2017 at 11:06:31AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 20, 2017 at 06:10:16PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 16, 2017 at 01:44:00PM -0700, Jason Gunthorpe wrote:
> > > As was discussed in September and October, add Jason along with
> > > Doug to have a team maintainership model for the RDMA subystem.
> > >
> > > Mellanox Technologies will be funding Jason's independent work on
> > > the maintainership.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >  .mailmap    | 2 ++
> > >  MAINTAINERS | 1 +
> > >  2 files changed, 3 insertions(+)
> > >
> >
> > Doug and Jason,
> >
> > Can you forward the current fixes to Linus?
> >
> > I have more fixes from Parav and fix to iWARP from Daniel, but I prefer
> > to have proper RDMA branches before I'm posting them.
>
> I belive Doug has already sent the pull request for this merge window,
> and the new shared tree location is fully up to date, and there are
> no accepted but unset patches at this time?

I still see for-rc points to old (4.14) code.
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=k.o/for-rc

There is a need to advance -rc to be equal to -next during merge window,
so we will be able to actually base our -rc/-next patches.

>
> Do you see otherwise?
>
> We are now doing patches for rc.
>
> The iWarp security fix from Daniel is definitely rc material.

There is no need to wait for -rc1 to send bug fixes and Linus accepts and
welcomes bug fixes during merge window, see the pull requests from Dave
and others.

>
> Can you split that 33 patch series into things you think are rc
> material?

I'll take a look, but most probably I'll skip the split exercise.

This patch set was tested as one series and separation will require
two addition passes for the verification: one for-rc and another for
for-next.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--s6piCcVGN+AZ9P50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloTs/gACgkQ5GN7iDZy
WKcbbQ//cGUxU4g8hsI7vPR26Dx1Vqm0GCmQR/06NkiBI9TYFPlOZxUWw/VBqHM0
wOps3xbdjV7RpOx3GQGBxzG0uumsigwgR6asGpqcQDFNPo+Zxz/d8Lra45T9DPTK
cL2TmyDuOlwT7uT676KgYWYgaNy2uHTdCdXM4fUllqEiw3E8rG3mgJCHDgBz122t
Z+P9RpbdgXIAWPHyiETUgpK9eTmC9mcfPVnpte6Xa56O++OKr7batS7WK7hz2bfs
00D8I8snbv6OAX4wFPtelWouvMuDe7ursYg8rEkx1jziMQq/xJs52g0cB5OQ7kw0
S4jhaZppWCuhn9WUdzVw+EHrxVx8aYfc0OrS8ZRZtg6RfUBVP2HHp7WkZJ17R2Rn
o44UUBHd8krAHPSuafg1of2YgcF4JtiFdi9FyKDxmtTQ6um6EfScGoBesvC0EMwP
vSU4I5USGoJN2kFSO1Wf7e0llz8qrckCWtwNuWGGDGyNHaQtROz1AJKH1O8ywHfs
oT5fXCqs1KDBq15LuCqErh9wqepHY/I8J0dZaSvip9TS0w7lFiIqhvW8NhvFJ6/B
VoicbNZZVU+30IMge24YZxlsqFQERCBnku6WSKrOsbAx4OVi1foO3rR2QQ5iHIaV
9pjzf1URBsKrqhg30IHaJrcUmz/6kHUZc+FmJhoQKIXIClsV4e4=
=2nh1
-----END PGP SIGNATURE-----

--s6piCcVGN+AZ9P50--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
