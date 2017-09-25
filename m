From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Mon, 25 Sep 2017 18:57:49 +0300
Message-ID: <20170925155749.GO25094@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0lsrIB+s628ok5gC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5abacb7d-3e86-4e12-ce95-a8fe472a6a09-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0lsrIB+s628ok5gC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 10:53:01AM -0400, Doug Ledford wrote:
> On 9/24/2017 11:59 PM, Leon Romanovsky wrote:
> > On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
> >
> > <...>
> >
> >>
> >> I want any shared pull requests to be based on nothing newer than an
> >> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
> >> request is on something later it will pollute my main for-next branch
> >> to merge it.  I plan to merge my own -rc pull requests after rc2 into
> >> my for-next branch, so you won't be missing code that goes into later
> >> rcs if you base your work on my for-next branch, so that's a second
> >> alternative starting point for your shared pull requests should you
> >> need it.
> >
> > From our experience, it is not feasible to demand shared pull
> > requests on "newer than an rc2 kernel".
>
> I said "nothing newer than an rc2 kernel".  Did you mean to leave out
> the nothing?

Most probably I translated it incorrectly. I wanted to say that all
shared pull requests will be -rc2, -rc3, e.t.c. and probably will never
be -rc1. Did you mean the same?

>
> > The magic of shared pull request
> > is in the fact that it is based on the same origin for both trees.
>
> Correct.  So, for instance, I'm opening up my for-next area today and it
> will be based on a clean v4.14-rc2.  What I'm then asking for is that
> subsequent driver shared pull requests be based on a v4.14-rc2 tree.
> Your last shared pull request was mostly OK, but it was based on a
> v4.13-rc4 kernel and so it would have simultaneously brought in your
> patches and also all the changes between 4.13-rc2 and 4.13-rc4.

Why is it "undesired behavior"? Anyhow git request-pull to Linus will
filter all patches which already exist in Linus's tree and you will get
merge of -rc fixes for free in your for-next.

>
> > In our case the same origin is Linus's tree and his official -rcX, which
> > for sure will be in both trees.
>
> Right, that what I want.
>
> > Once shared pull request is based on that tree, it will apply cleanly
> > on both netdev and RDMA without pollution of the trees.
> >
> > And again, shared pull request shouldn't be based on any patches
> > accepted to netdev and/or RDMA which are not in Linus's tree.
>
> Exactly.
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--0lsrIB+s628ok5gC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJJ30ACgkQ5GN7iDZy
WKeusQ/9Fyky2aG72+VQdaNUhzN5ipgJSeKTNCyoleqRtluAjgruOrAljSj05ctq
dlO16HT5O5oY6A1YvXA8UblULGA8mAprIJ8foeQvlyDbG5Rv7DPY56dPpVE28ngS
S2kQoIW6ZcR+MF6YGm/Y/9NNBwBQUrJRAxaR1SLu7zc01+e6lglT6jobwJpvtEec
2uK7/6wjhi16L39OtFHvTGmXwMVcVDwZYiI9q5vi13z1+jcKe98KQhtFUZ6gf3sm
m28kC5WzhoWDOeSgfOwJBy9kxcYwUZpy2FdNjlhATUwW9ERhRWifQz6C9AwQgZCQ
K9hAUUEePASFGJVwXwN7pF96qPycxUEwz97CYvt9nthjFvFKBEThBtVAkWz0rVfg
LaYFEcW6buMIMSIj+QykoD6+JcjBMIHxnZ8VG7muqQX7ajvwnavsiZb+mLwvzRwq
y1i1sNqiEd5wOgqNxtwMvDqhxazT6pdaEStopaW1YsHUJZoRWjB5PbzcrmHs6U/D
ZMkna1DtbaIUIBL0FTwutYNT/pjbfDKZBgm8YIISw8SKYCFz1ax0i6Gfi6LhvA8q
2SYcT+HEEorbcq9EIwiSqjULAvotWjF3Y7dYE6/84lzwa7ug/zpf1xY4BlTFIYfZ
xwKlqutIyp3NDEcgtBZyLpOShA2iLmfW8zDSI0odwAL1eU6ua1A=
=t0q/
-----END PGP SIGNATURE-----

--0lsrIB+s628ok5gC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
