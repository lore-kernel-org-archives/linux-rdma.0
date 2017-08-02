From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 06:44:38 +0300
Message-ID: <20170802034438.GV13672@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <20170801195840.GC31205@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYQNNDjzvANyiJW1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801195840.GC31205-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mYQNNDjzvANyiJW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 01:58:40PM -0600, Jason Gunthorpe wrote:
>
> I'm not sure why there is so much noise about this - yes, iwpmd is
> really weird, but it is a UAPI, we can't change it and we can't demand
> they change.

If you claim that it is UAPI change, we MUST revert this patch, because
reverted patch CHANGED UAPI.

Thanks

--mYQNNDjzvANyiJW1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmBSqYACgkQ5GN7iDZy
WKeQ2RAAyCvAqiO4ageQRZSPnNqRJmw2y3dro4PgH/le5zujYqmtWz50izBH6qmW
5zyKIB840kjs2o2eqfYrRmGlSOklTioyJcMXxy+9RJ6U9zEFvaJOLQsb29bvkyUA
RLMCBXrf70NShFmu6YAdRankoQz3VMRVtcvL+unxYnw4F8CbXfg75NQOklVO/6ve
IO/FGFuSsLRlM3wkAk2UBUWQbdMhIOi/iWbnjdjJyVanIyPRwglih8UBMWPcYIT/
kOOGBzquxvx3ueg4tn7sgprlhNaKHoelHUmYSWHGNb5hrpKyaKSEsEgWblaQNBqB
3JtJmibrXZS1jxt7xcUyOccIKy62e3tV0IRe9GX53lT4agXJbKDftmzLHRHZaMDj
T5jT8lLkuompe+GvmqyEPkRemIGcMOiomsuws/lSVbdnvA6059E2fYShRwa44CeH
j3OCyRl0y1nQ+/Ofp05ByVblQVo5lqvUqhbn4g3DvoifhRTofPKFiS3VcCknMveH
yklK6FZUrsKSxZ/ntSHInDSO/T66o7x5IPuhSBYy4YcPuFw2vLEj1NxF1972RDFd
jOXLt2chhInz8Lvjs8jQG/K5ZhUAXO3rc3VSjI9zCq83wyPrvh+AdpXWdd2wNkvG
Hvg+c/d6DyA93KOgf51wykpEPCesnE6/JmSCDF3hsGZBqHvvtuc=
=B1fX
-----END PGP SIGNATURE-----

--mYQNNDjzvANyiJW1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
