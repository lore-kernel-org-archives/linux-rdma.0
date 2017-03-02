From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 20/20] IB/core: If the MGID/MLID pair is not on the list
 return an error
Date: Thu, 2 Mar 2017 16:00:28 +0200
Message-ID: <20170302140028.GE9525@mtr-leonro.local>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
 <20170301182426.29989.77369.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301182426.29989.77369.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 01, 2017 at 10:24:32AM -0800, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> A list of MGID/MLID pairs is built when doing a multicast attach.  When
> the multicast detach is called, the list is searched, and regardless of
> the search outcome, the driver detach is called.
>
> If an MGID/MLID pair is not on the list, driver detach should not be
> called, and an error should be returned.  Failure to do so can leave
> the Multicast list out of sync with what the driver has.

It took me a while to understand your last sentence.
Can we add Fixes line and submit it to stable too?

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli4JXwACgkQ5GN7iDZy
WKeRqA/+JQPVGc2b+33WXn5klzzN79YANQaZ6NaUFf1bF49BO4EhNhE3JkvqMjVd
WzO6zhuH3Uk2JpCtjEYzWLfijWbnJFTENQQgdzxbqyHMc5BHX17qjsIcBT7xlEo9
/EhZqmrrG0N4CacteWyc7xx6YS/VdyJjx1C7WLmqamh1evbjd21jwDcBl26S75bC
5hF/9Lb9wS1V2GHZpgXHCeRwoDI8MVwSXwvgjW8rXjGbnZjbUSklohFj86wYIvD0
8cUVrTtUNfkzC5fee/O9AAWZEAJz8WWGIJ2CnOs6xAo9eVKisuFfBJql/kg0uv2q
9zg8dGYvhO5m8DHPRIxljwrbmF1LfPbARD8eMdTIheyGeJe/9QV1cLNga45hP89X
+Mj6p57qaAerhPIqnQjXeAj5ZSQTsTPXzS48avXtEFwyYo7gPAQDKNODN3A3zVHp
Ysws4ZuJFB1vz/t4zXtL73y2yptI2H4m/Zo5Yq8TT23WS9eTy+xpC2JozlgNvaqV
VQ6HHV5q44eYXCR6w/+kTrh+Tc6AHpB2sZBJ++dqqrl/91vIJtiaMVFokfQWB3kU
bYVV+wYnltaVNgfBULuWdzpqYOdruYGwGCK5kRbkWG1F+57RBDcVAHwvuPePIrgD
ZoRbjwHoJUsxCogrzOeWPuXuqlIbth5dksfkR/c6efCzIxiddyA=
=PJJc
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
