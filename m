From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: small patches to librdmacm
Date: Wed, 23 Aug 2017 19:59:49 +0300
Message-ID: <20170823165949.GW1724@mtr-leonro.local>
References: <C50D9A8A-457A-4DA6-B727-43B77117ED15@lanl.gov>
 <20170823042927.GH1724@mtr-leonro.local>
 <20170823153728.GB22775@obsidianresearch.com>
 <20170823163217.GU1724@mtr-leonro.local>
 <20170823164533.GA23928@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9/lmB/GmAksD4Nrg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823164533.GA23928-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9/lmB/GmAksD4Nrg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 23, 2017 at 10:45:33AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 23, 2017 at 07:32:17PM +0300, Leon Romanovsky wrote:
>
> > The commit sha1 should be 12 digits and not 7 digits.
>
> The github gui truncates to 7 digits when it detects a hash, the
> commit message has 12.

Thanks, applied.

BTW, do you know how to configure the gui?

>
> commit 39a612257aacd77ed5bdd506968cf4e54bbe63b3
> Author: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
> Date:   Tue Aug 22 15:59:42 2017 -0600
>
>     rsockets: Fix segfaults when rs is not found in the index
>
>     Check for null each time the rs is accessed and return an error code.
>
>     Fixes: 0b6aff48ce31 ("librdmacm: Define streaming over RDMA interface (rsockets)")
>     Fixes: bb9fcba81acd ("rsocket: Add APIs for direct data placement")
>     Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
>     Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> commit 5ac0576d51ddfb9207e5632c71d27d14b3368143
> Author: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
> Date:   Tue Aug 22 15:59:18 2017 -0600
>
>     rsockets: Fix a race-condition in rs_free()
>
>     If rs_free() releases the fd before calling rs_remove(), a second thread in
>     rsocket() may acquire the same fd and store its own rs in the corresponding
>     index-element.  When the first thread then gets around to calling
>     rs_remove() it ends up removing the rs of the second thread, and storing a
>     NULL there.
>
>     Several functions still do not check for NULL after retrieving an rs from
>     the index for an open rsocket.  Thus, the second thread would get a
>     segfault in any of the following functions: rrecv, rrecvfrom, rsend,
>     rsendto, rsendv, riomap, riounmap, riowrite.
>
>     Fixes: cf7aae3d0cc4 ("rsocket: Index map item is cleaned before it is used in iomapping cleanup")
>     Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
>     Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--9/lmB/GmAksD4Nrg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdtIUACgkQ5GN7iDZy
WKdojg/+PhwumMcoHmKJILU/sh+mDV+ZCtVtB72pw6wNI7gtgnaDk2FXp7RYVAUD
gB33OsW1f3zdiYY8DHKRZuzUALJlIyju4xZu5vQJO1xJy473hsVGoW+h3tzYRhoO
WkFEA5oZFwgXTZ/RQZw6DpFTStrY7oCkvCOR8wdHeNhAQaJKi2n25b9Cyho3q1Dj
cK1EfUbF41rakUmR6VRDFY2L0LbjvPOUuteThQ+sSyM5VRJlWoTeI++0L+EfpsbE
UUm85OqurA607fvdq+ba3kplk0+OvXjkKBe7G5+zfPWO7FnHcgobYOVLT5j8WlpF
vbIkEms9ncEbBqA0GmKQYPK1S+ho4naVFj+EBiRi/6xHWXOopL+gWeFtpGIpahJ+
A/UVV64i3Wq9hV4cDs4vTXNcmoY6s7GGHeFgdjcfgUoiOnAlPcO64NseCLqfGAsW
1hehNqA2halCsyITMUFjxsd2xDZj1M9CBcaF1Mi9P/s5qkd10N7ChWCwxavSjJBu
Vdo82t0iSaLA4QXzBNnZ8Zz51o/ansOZFHdOJOqQaU++vUXUCf1YQcH44Fnz+7II
JXLMXJvJ83VT9R2zxUjYCouFI13LSSXwykqmN6CLIcTK32P10v814YpqNObcTz4g
ou5hw8ZPr8xtVy2SlpnU5EwVkNuW2n5+b8SpH603PWEuWarF21U=
=u/fD
-----END PGP SIGNATURE-----

--9/lmB/GmAksD4Nrg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
