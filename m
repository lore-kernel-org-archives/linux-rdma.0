From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core RESEND] libqedr: Add iWARP support for
 user-space lib
Date: Wed, 6 Sep 2017 06:56:04 +0300
Message-ID: <20170906035604.GE18084@mtr-leonro.local>
References: <1504622214-9730-1-git-send-email-Ram.Amrani@cavium.com>
 <20170905151412.GA18205@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170905151412.GA18205-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 05, 2017 at 09:14:12AM -0600, Jason Gunthorpe wrote:
> On Tue, Sep 05, 2017 at 05:36:54PM +0300, Ram Amrani wrote:
> > +		if (iwarp) {
> > +			writel(qp->rq.iwarp_db2_data.raw, qp->rq.iwarp_db2);
> > +			mmio_flush_writes();
> > +		}
>
> Can you update this driver to use the macros in util/mmio.h and
> discard this writel thing?

And fix failures reported by Travis CI.

Thanks

>
> Thanks,
> Jason

--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmvccwACgkQ5GN7iDZy
WKc1oA//YOrfN8LkjmHmaRITXn2ZMvxuNAmJYlsOcZhnYO2lSMA1DnVTsTtzCZf7
Fgk7NCUVFpIcQ111u9AhI9OY3CDMmWrq5SRWucGEzFlIrX+mvv1S5b0sm9Md28j9
e+zbisKdvFvsnE24sa9LR4i9A6IaZ0MpgKpaByoKKyyhQcC/0hIhHquY5zEQTnOY
Ile5k1I4DvVgClmkr1JzmnIMp9Hqt0BUzC8/sETO9Nb6OEKy9QJdncnKd084Oncc
+V0L9zYBeTZO4dwDLs4mYnUOldm655OHFT2WJ3jZXgMKoF5nA9PbRUUaUFyfsjjg
EKYAoZuZnNDuRrqfiU8vSEsDyd9JbtDFktrNBFNMwByHtPN8WeJIfl5WfC41j1XZ
OGg7FejCr01sCI/Ah3rPca6B51I+iHufoZf6rPlz/IirTQgDbZXNckGDsnLnaXSv
Z0/yiW+OsI7bwcQX+QwyE0/raaiKI59/VmIScuK0FetR0k5TDrPAUqXncahd3LTl
+bTmhXsQOY0xqdLgZl7OX9qqDxzAXXxHxbc8qGMfO38fufX8e8zE2rp/YJpd6Rh9
FWcnGWZ2b340pqFUOCQEVABHekNqI/jJs7B2lmlW261n1ks/tuhtxFaR5vGlrQf6
f7RskQk2C1YGKUoAiWQ6OwIwJ+9gPyECKvd8RT0jMNVYl+xuQ+4=
=Zx1C
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
