From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core V1 2/2] travis: Upload assets to github release
Date: Tue, 31 Jan 2017 10:57:41 +0200
Message-ID: <20170131085741.GP6005@mtr-leonro.local>
References: <20170130062316.16268-1-leon@kernel.org>
 <20170130062316.16268-3-leon@kernel.org>
 <20170130170956.GC29502@obsidianresearch.com>
 <20170130201953.GM6005@mtr-leonro.local>
 <20170130211658.GC27111@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bEAlbH1hodbw2omC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170130211658.GC27111-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bEAlbH1hodbw2omC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2017 at 02:16:58PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 30, 2017 at 10:19:53PM +0200, Leon Romanovsky wrote:
>
> > > > +if [[ $TRAVIS_TAG == v* ]] && [ "$TRAVIS_OS_NAME" = "linux" ]; then
> > > > +	# Let's create release for vX tags only.
> > > > +	git archive --prefix rdma-core/ --output rdma-core-$TRAVIS_TAG.tar.gz HEAD
> > >
> > > Should be
> > >
> > >
> > > I think..
> >
> > I have no opinion about that, because I'm not going to use this tar.gz file.
>
> Including the version in the directory is standard practice.

No problem, I pushed updated version.

>
> Jason

--bEAlbH1hodbw2omC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliQUYUACgkQ5GN7iDZy
WKcJoRAAxGgc733QUmReoHvtbvqKO7+MRGPIGVYTxafzgFbedgu9RokQk3JuJxYx
9DSC0Y6cScM1ikOQ9rstFao5R1Tr5C/MReDk3qrRAhj2gmJyGCiuy2e2325NSPfu
XB8VIGpQbSu6y4y7Lzhg9auOIDqTZXkYHUBIrG9K4OcF/1jVSAiMNZ9kcj1HFKpF
rSx1NZ4ypDXLRFz8B+d08qjjNNnrAm72a+AXdH2fr7pHO0GhE6XG0jFWSomRQS79
Pq2y0sJtfRMxjmoQwGQYbkrwLEy+kPSDwnQzlHaU7RfpNvT07sRRBwuz7sPq6feU
YrrlH5zTBGQsSH3LIsf2kCNnBLDiNyu/Yw5liGHBfggTSUsYdRgZowDhR7SfrBvu
H+d4QN7L8K+Cr1mOTr+rAFFe4DNhXNZIOgJARV80hN2t9HRgluVGovsa3LTCl6i/
W+dJMSToc+Alu+uGDdzKXpNLk49qN5WS6ZaQg8Jzg/wrUq7SLShLTLkUTBXSH2gR
d/GNI3qG70wpJsG8ZoaHDVtE4yZvTlQCqyYTED8WjRlnQ8YASIO/UG/Zk3j3Znom
sm42loG2zZgsMeikl8dafPsgLPVpKC+thdMrJVfIDrISYyoOLwoXLjimCzYF+ryD
jH1nr9kzBuJQEmE5Z3vnMZ6ZLQhHjK+GeniLgrhd4QnqJOPmQQs=
=2Y8k
-----END PGP SIGNATURE-----

--bEAlbH1hodbw2omC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
