From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Wed, 23 Aug 2017 19:45:55 +0300
Message-ID: <20170823164555.GV1724@mtr-leonro.local>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
 <20170823160816.GA11188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKkaNMvYmhQvRCRK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823160816.GA11188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tKkaNMvYmhQvRCRK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 23, 2017 at 10:08:16AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 23, 2017 at 03:13:38PM +0300, Yishai Hadas wrote:
> > On 8/22/2017 7:30 PM, Jason Gunthorpe wrote:
> > >On Tue, Aug 22, 2017 at 11:36:42AM +0300, Yishai Hadas wrote:
> > >>On 8/21/2017 6:22 PM, Jason Gunthorpe wrote:
> > >>>Is there existing code out there that uses cq_out->uar and works
> > >>>properly today? Yes or No?
> > >>
> > >>No, only this fix enables that to work properly.
> >
> > >Particularly since a patch to do this with proper compatibility
> > >exists, and there is no reason at all to take a shortcut.
> > >
> >
> > We are not looking for a shortcut but for a solution that will match
> > majority users if not all.
>
> Here is the patch that takes care of everything properly. It is PR
> 188.
>
> Please be more careful with the ABI requirements in the future.
>
> From 32ef444e45006112ff759106dcdee2b99999501a Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Wed, 23 Aug 2017 10:05:24 -0600
> Subject: [PATCH] mlx5: Fix ABI break from revising the UAR pointer
>
> Provide two implementations of mlx5dv_init_obj, one that has the
> historical behaviour that has existed until now of returning the
> void **uar and a new version that returns the 'void *' version
> renamed to arb_db.

arb_db -> arm_db

>
> Apps that use this feature must refer to it as arb_db, they will not
> compile on pre-rdma-core 15 releases, and they will not dynamically
> link to old versions either. This provides a sane level of safety for
> the end users of this library.
>
> Fixes: c6e3439aaa93 ("mlx5: Return pointer to CQ doorbell")

Strange, in github it has 7 digits (the same was with rsocket fixes)
Fixes: c6e3439 ("mlx5: Return pointer to CQ doorbell")

> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

The overall looks good, but I need to run checks with before applying it.

Thanks for doing it.

--tKkaNMvYmhQvRCRK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdsUMACgkQ5GN7iDZy
WKckARAAuBfGC64NOFg9TUJOO75C/EXUh8SMGijIaNq9mIFfI1lKXkdZCjZAA6PT
pK0oesHSPZuDkvW9dFr/nRzSS/mw6h+aj29OJtE95ZVKNEXmW3+Gfsf4p5KRlRrs
xpXO4J+5LvoqlsveGbEwyLZ8TgYDhdu+soCwq+AW910UumNg1g1kXUUEb30rO8Nd
6XoLpdQIxIvWRkfsMzgMCWF5szXaaOk+hhy3bSPwB4mc3eCgnkkrsbmNwVgv4CRT
sQMcl8HmSDC1OJOLKWhCNqrvr0AyL4agiCF8O6XDhS4WqLl3uzrBKQtjVLQ7+YFE
8Bbuun8CZgLvPsi9IRZdKpcmwf04YGm7diI3Uce/DaGlpPGfWhl24loQjA8DXmOq
b8i9BiNuIJ0fvPiU5xbjTC0fRIP33PWJtpmrzOvcEFdSu/PGfJEwoaD/ZH/TvejN
AJpxClVVsvewXTqIaRDZLp6yWFhEsWTYiHZjtpHNh4cgdEHDt/N42CFen+gPDz9Z
g23QMgB53LsDvs7zfXFuA9IsDxb5qU2v6MmmGISqqOLqzo4ayNWnR4TL7wi6sFiB
qBDJo8arMfUfdoxJomgxSFjfLQm/ZnXxENJbDt41VB9FL6+j3D9WJrrgyczqdm66
6hZPFm3B+h+bAoxmtIv60lcUjL9/pLAJ5MVHtSfad4i0FXn4veI=
=Mcl5
-----END PGP SIGNATURE-----

--tKkaNMvYmhQvRCRK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
