From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Tue, 26 Sep 2017 08:28:05 +0300
Message-ID: <20170926052805.GC1230@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170924195627.GB18007@obsidianresearch.com>
 <20170925042355.GM25094@mtr-leonro.local>
 <20170926033343.GA10193@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926033343.GA10193-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 09:33:43PM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 25, 2017 at 07:23:55AM +0300, Leon Romanovsky wrote:
>
> > I reread it a couple of times and still didn't find an answer for
> > myself. Why do we need it?
>
> The point is to make it easier for everyone to understand what is
> going on by clearly documenting via git the actual dependencies that
> are required, and to enable early QA on something that will actually
> become merged without being rebased.
>
> Handling cross tree dependencies is hard, and if Doug is saying it is
> caused so much trouble he wants to basically stop doing it, then
> exploring another way to handle it does make sense.
>
> I think it would work better to send a complete workable PR than to
> try and wrangle all the manual coordination on what should be merged
> on top of what tree and so on.

Right, it will work better on Linus's level, but it won't work on Doug
vs. Dave level. The complete PR means that your code should apply
cleanly on netdev and RDMA at the same time.

At some point of time, usually after -rc4 for bleeding edge devices,
the netdev and RDAM trees are so different in that area (for example mlx5_core)
that the chances to have clean PR are not high.

Thanks

>
> Jason

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJ5WUACgkQ5GN7iDZy
WKd9URAAlCKY6CxvqiMl0VttQZ5iCyJ5GSGcMNiYZuwFQrtEB8DwElMN71M3XtKl
45HQ4SY7x6wZzuAWMAUFYHDC28bGbXfFxkBTFNnZP7quHJcCiy7ljbidw7iHdTOd
Xsyv9jWT9YxA0DYyWnMAnNyIoLHSRA1u9nrEk156e62/mGZMUzb5uwjzOTBhm7D8
Ck5uPN4agITHq+75mFmeEyDC9++zsxIGSWnZartNcUJIapJxi3C2S40/g1hgNOVS
1iLWdbhPgVWn3iV9fba1m8/uIxp4VBwXLeAsf3n8nmWgr+qoTZjaveFvtGY3/pJF
Tj0kjxdLDdUnbxHiaxkEzd7TpjG8rMlvaBmqrXCUv5aleEZoEIO7Yy7GHQ7CvW3R
mhfYT1koozITNUx1GE+tGhxhd6o0Ak2/4YTgi4/XLjOwOTzuHJ/jgfU0SVSozKFV
WrGmKbCNHUYFWyjDhiw0IqS2BhpJUhG1cRUXC0Eu+D4dVBD4lP5mBe666ED2cdXR
PhtcDi9tZsx4VfDTwYdd2H+xVUKDQQzZSks4AEOt3QyKj1N1DxbqJa3zINEYgcgc
4Gp1xm3MbOZiDTaGFRAB7Y+6mihMzKJ4Grc2/bkGU61e8GS+jQRlP9A6q8Pk3oFh
+kaPyjJ5n61fbjOWwyAOFG2qppiupg1yI0xhGIPTbcryitpyDGA=
=qRfJ
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
