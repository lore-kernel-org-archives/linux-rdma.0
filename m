From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Sat, 11 Nov 2017 09:57:04 +0200
Message-ID: <20171111075704.GS18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="29v4wwwYFo25Y52C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54347E5A035A054EAE9D05927FB467F9B61778A9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--29v4wwwYFo25Y52C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 06:36:28PM +0000, Davis, Arlin R wrote:
> > I agree there is a big need for that. Currently reviewing all the patches I haven't
> > read (only 1000 mails to go...) to see if they need to be backported on top on
> > rdma-core 15 for the next SLES.
> > I'd gladly help maintaining this as I'm spending time on it anyway.
> > I'll leave wiser people debate and ready a doc on how this should be done
> > though :)
> >
> > Nicolas
>
> Thanks Nicolas.
>
> Ok, I am not sure what details the rdma-core maintainers are looking for in a document. Let me start the discussion with the following:
>
> Stable Branch Release
>
> Current Maintainer: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
>
> Upstream rdma-core is considered stable after each mainline release. Branched stable releases, off a mainline release, are on as-needed basis and limited to bug fixes. All bug fixes are to be backported from mainline and applied by stable branch maintainer. Branched stable releases will append an additional release number (e.g. 15.1) and will ensure that Travis CI reports a successful build.  Mention the frequency of stable releases or keep it "as is" cadence?
>
> See versioning.md for setting package version on a stable branch.


Nicolas,

I created new branch "stable-v15" in rdma-core repo [1]. Versioning and
releasing should be done by tags, see release document [2]. You should
check in advance that release script [3] creates proper files, and
double check our CI scripts to ensure they don't filter out that stable
branch.

Thanks

[1] https://github.com/linux-rdma/rdma-core/tree/stable-v15
[2] https://github.com/linux-rdma/rdma-core/blob/master/Documentation/release.md
[3] https://github.com/linux-rdma/rdma-core/blob/master/buildlib/github-release

>
> Arlin
>
>
>

--29v4wwwYFo25Y52C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloGrVAACgkQ5GN7iDZy
WKdz+RAArd07irx45ghGshcvbW01HC/dw/7K2nT3psHGxB6LhqC2F0+YPxpjLgU0
LO+uCkIF2xTWL7lvEnWSGTqxBT5haV7MCIwBhe3HtyV8VgxkcITM4z1cfVeYG7N9
gC1I1QTg29H4765cPbQU0Iam8a/amKGJFx13DCWNjfbFL2cu5gbdG0o05uFzddGi
879tLnAnEDx0m0LXz9P2wGUDE7AKgJOSBnVLjBxKBfsFuIm3+c00hJPJO+MLRf1F
Zx+occvy7QKJ5QodHMf23VoPRnTgl3MNsjzzrVf/cd8Jd+aST6H8lw8mrCy+3QMZ
BCoU3uB9DNuPQF3jETHQ1sERieM2j4+UXfzJ0Bz2FLLL9USn6/J9FoujFgHhw/pA
Dl19du9THu/1Br/YAbozdYe6IYBByMr4oP7COo73hhpI4wfFTc6fV6ZSmFjC/Bd7
JMZ67MY/yQglNKCVuHd9J+1iHB0qT+fmSTAOEl8r9MBsbiyHVtN7TcyY5uf+yrEt
FqREBn4NT82josNwObGj1sSE6RvhsvGjcPp7CtWJ0t3A14Y4ZGFjtv5S3gPP7YyD
5YCnQlF1doP+ZX6X/iSJhOxqPRA5yIEUPW4fOFlwEqw8E6vcn1LNYUE7jaACqL+W
q53hh66SASuH7yXmjTmwYpxln02nMPXmwqmvWke2byRl0Nez7GI=
=Rn9y
-----END PGP SIGNATURE-----

--29v4wwwYFo25Y52C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
