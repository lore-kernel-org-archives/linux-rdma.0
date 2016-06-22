From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/mlx4: Prevent cross page boundary allocation
Date: Wed, 22 Jun 2016 19:00:58 +0300
Message-ID: <20160622160058.GJ9762@leon.nu>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
 <1466605652-24798-12-git-send-email-leonro@mellanox.com>
 <20160622150141.GA25806@phlsvsds.ph.intel.com>
Reply-To: <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBT+cnFS/G3NVgv4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160622150141.GA25806-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--SBT+cnFS/G3NVgv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 11:01:42AM -0400, Dennis Dalessandro wrote:
> On Wed, Jun 22, 2016 at 05:27:32PM +0300, Leon Romanovsky wrote:
> >From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> >Prevent cross page boundary allocation by allocating
> >new page, this is required to be aligned with ConnectX-3 HW
> >requirements.
> >
> >Not doing that might cause to "RDMA read local protection" error.
> >
> >Fixes: 1b2cd0fc673c ('IB/mlx4: Support the new memory registration API')
> >Suggested-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> >Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> >Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Hi Leon, why sign-off twice with different addresses?

First SOB is added because I changed this patch and did it as a Mellanox
employee. Second SOB is added as a sign of my external git tree, and
comes instead of my ROB tag for other patches.

This allows to visualize my external/internal work.

>=20
> -Denny

--SBT+cnFS/G3NVgv4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXarY6AAoJEORje4g2clinCCUP/RFdim/RhIGfE9E42ygLKFLC
Vf5yxfQFt5TDIawQZpoXDMJ2KPhj0dClqH1snXIhMZEz7ler42ib1gYTO4k4qXwU
r6SRWvPrxXdk2jSPeefS5cCNJQe6pfw5Hr9mV9dih4n73Q6xWl45xXccusY+aPe6
7NRbNdHgKEtY0MxbWz7GWJGVuCKkTrBSNEDAkKP3mZsI7XG+LCS8pMWs0J3Ny4IW
YeJI11bRZzt0/Nq/JGkVUAF1KwSVSK9LiUv5w4UkmO3sTfAPfACaxiymUJ1vbTBT
OWuILccHqKqCyr8aHg9KMrP7UK/EnQwbOrv/u4Z2TUmMUnOfL1znbL7likbOq0fj
n3mC/4emNg+gEd5MTzyoxnf8SgdWCIY+h293FpeeE+bXc8yYOS9kyDQGLk3ZMXEv
hGREhAWtbybB4uRzkJGk7gbMSywWi8vxVDgZGNQ/IlWX/H/G0V/3DlEyqluEhFXZ
XKgZz3P+NDUJm86TmuBmON2vduR158uehBGHh3VyUHuW7Hl1QQx/nqANGyQkuSIU
GM1gH+JyP9WOKHjyZDPfd9HjFY8+8GlGF2/TpN0SRhkZIRUrd1SCQz9lTvZDoa8p
VW3eqtADr93Sc/GXnTOyos2dGKdlIKSn2gr8hmObQWZLFeSHsbIJp3kgPUE5bvmN
nwIPTT5wO0MC5xd+fOYA
=5eql
-----END PGP SIGNATURE-----

--SBT+cnFS/G3NVgv4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
