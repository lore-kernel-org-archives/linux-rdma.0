From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Sat, 2 Dec 2017 10:40:19 +0200
Message-ID: <20171202084019.GG8126@mtr-leonro.local>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
 <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
 <20171201055732.GC8126@mtr-leonro.local>
 <1512151985.9183.4.camel@profitbricks.com>
 <20171201182806.GL7754@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171201182806.GL7754-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 01, 2017 at 11:28:06AM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 01, 2017 at 07:13:05PM +0100, Benjamin Drung wrote:
> > GitHub does not allow to rebase & merge the pull request. Is there any
> > reason to not allow the rebase & merge workflow? My commits are atomic
> > and the git history is cleaner without the merge commits.
>
> We have been using the merge workflow. I'm not sure this was every
> really discussed which is best or not.
>
> The git history is simpler with rebase, but merge preserves the 'what
> did I test' and preserves the series boundaries, which are also useful things.

We are also putting cover letters into the merge commit for documentation
purposes.

>
> Jason

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloiZvIACgkQ5GN7iDZy
WKdcPQ/9HJuoh6k9VCb8O/+np1rubx46pdWTEN3GyDesOvKiShmXUm3aCDD8ypVv
1LTmquugKAIwuuMmF3I1o3COc4+ifk/sU4CvF4SA0EPd0CmAHr1X1aNZmZAHm9Za
4j+b2XjyeVfMHzQ/Z47uQS9BQA4DxQq5JAMRe4ThAPfvIn+7CR1fp8fIWA6P6ffg
LBB8v6DJmQkxLvYwzno9c92i7a9UlDogwLS5EZWwMxaQ4LPkFCAaCIuG855nv72+
s8tdeQXmidnogIpd/M/ZxKN0zLByFFZryzATGxrztjI31COe/TWVYFS4hjCdSOHc
FsW+zi9FwXGLXboOE6fFw+l5YNEEfJShbLhmmNEHlPa2jTRTkTYpoTPxpaKGw6gT
ZEqQ18wVMAG1HyV0vJPU+UwFbQ+nlAMhT6fHwRKyeRQxtliO29E0L0hEpD24/bpL
bElmj6uPPBuKvadRMPEUGnt9oIOTfFuuU7Q0g0FgtVbZdMspdyRg5sqXx+1nmnUE
7xIPHf3NOhtCWVtGIUpCd6Nl6pmt38vzvL9XrLm4LQaIpbeNaLgp/ppcHFJsDTU1
LXW+ttVe+cGBXsFtWXuZHulFesNbLUPqcBvoimSSfFwb1jLZkBnmfbFKbXL6dTZT
QFg1NDcRH8rFCuUIpTp2hznrDUteYcglhi/nYF/nlEFSp5uvq+I=
=lrTP
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
