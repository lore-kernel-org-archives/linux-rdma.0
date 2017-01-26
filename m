From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Thu, 26 Jan 2017 22:23:30 +0200
Message-ID: <20170126202330.GX6005@mtr-leonro.local>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aXNiKu4lnbRqA5kZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126181113.GA8679-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aXNiKu4lnbRqA5kZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2017 at 10:11:13AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 26, 2017 at 11:09:26AM -0700, Jason Gunthorpe wrote:
> > Or go back to providing strong compat to the providers as Ben
> > suggested..  In this case someone will have to vote for this with a
> > patch to put the missing symbol back...
>
> There should not be any compat - it's just going to drag down
> development and everyone is free to submit their provider to rdma-core,
> same as kernel drivers.

Agree, I have no desire to support out-of-tree providers.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aXNiKu4lnbRqA5kZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliKWsIACgkQ5GN7iDZy
WKcs+Q//TCHtCgDhwfrPiTXzPGHaZOTkgbvWJv0xfrBCTJRiD4gCNdID/yMsLLHx
fyFwBOaDccx+OB07uodIHtytBI3nTyZxjZB0AnxTbi508c2bxIPDDgD69x4fomkZ
jevRZtCChmF+nneA1XDGJAtPw4k/e1EQfLNSqpu4y5KEIbUDxjmol7A+FulRWkku
nQQVxEEaH/hcK+JdEBMiH0j2fo1GUunFZUUvyyT/sdY68udAD09rRUXE+ipN+TRG
DSuSCp6BKJznZEb8RFkuVTFMUwG0jX7byZSEq/NoK11fik0BrRD0G29frXTMhfe9
T0N09LH8z7Pc6klEiOr1c8fK6QXax0yVU+hx4AD/NDQK1WJGfEF6f18UJLpW7y0t
U2FZGRxx+Efd6/WLeAUbnWzbyWjbhKvNB/OwUcG8dGRORJDA2alz86nH0/Xulq53
nADfPrwb780QvLdY47JMc154tB5wcvSENharpzU/AmgFJ2/i1xqUvWF2e6SixG55
VIYTII1Ui6khiYdHD35WB1qqz+78TElDjNvTf59F/pkjVj878qyO7tKUjmzeKpwU
9it2UQuC/wTIouO3unxH28HiA2i4aIycJxlEE13crEUUfsI8FKreP9RbplD+Vpse
Mr5yh/CzgYu0iuC4Z5gumjDHAlXR10w2zRaI8D0rbeMZYp3ZORM=
=HJKQ
-----END PGP SIGNATURE-----

--aXNiKu4lnbRqA5kZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
