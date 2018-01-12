From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Fri, 12 Jan 2018 20:39:58 +0200
Message-ID: <20180112183958.GP15760@mtr-leonro.local>
References: <20180112055842.23125-1-leon@kernel.org>
 <20180112170228.GD15974@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eGLW8NzjjVmDHwQh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112170228.GD15974-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eGLW8NzjjVmDHwQh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 12, 2018 at 10:02:28AM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
>
> So, my take on the for-rc8-ness, based on the commit messages alone:
>
> > Bodong Wang (1):
> >   IB/core: Fix ib_wc structure size to remain in 64 bytes boundary
>
> No, performance optimization only, and not a regression in this cycle
>

Sorry, but it is fix to performance regression, and not optimization.

> > Jack Morgenstein (1):
> >   IB/mlx4: Fix incorrectly releasing steerable UD QPs when have only ETH
> >     ports
>
> No, only supresses an annoying warning
>
> > Leon Romanovsky (1):
> >   RDMA/mlx5: Fix out-of-bound access while querying AH
>
> Yes, fixes a user triggerable out of bounds access

Right

>
> > Parav Pandit (1):
> >   RDMA/core: Fix avoid decoding iWarp port as RoCE
>
> Unknown, commit message is too short. Parav, please explain more why this
> this is worthy of 'CC: stable' ?

Parav has nothing to do with "CC: stable@", I'm the person who added it.

The rationale behind it that it so basic change so it worth to have in
stable. Also, it goes as all our countless fixes to those two series:
Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
Fixes: 7db20ecd1d97 ("IB/core: Change wc.slid from 16 to 32 bits")

Thanks

> Jason

--eGLW8NzjjVmDHwQh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpZAP0ACgkQ5GN7iDZy
WKfeBxAAyeC84FWAJ9NQPW8usaGDKkrs+0FgUe2SS5L6EGq0zbklRbmWJRTJg946
Flb4EgpZ+KpmA7Dc0lomoWfhDz94TnIsCBTSZ6zNK5cpBwUpruvOqay0lEHhr8/+
loVAH4FtnIjloIrQ6S+FupJhvs737octhfhT4P0B0NqHh/I80HIgd3RT4jn4QrVC
xHrKUKeIM+YE2zwLN3Rv90qcLjraBDmHTfDyACbup/vgTFkowM3QsXas6E5QAKwq
8shCKcXApSxaXqwd/eEvGwYf+ekXoahRn1W/dEE3rbNFOArPLZKOUNexm4FnPP1T
kD2R7Q2SX4Xn+99WihrRZQhLUbyvVz6yLcZ6nxBgELpqP7ufA4Xx1vVsQLUeBzMG
Qcg9pmR9hbRvNddeOwVU9p123IOygT0UJmJvhm7YOQgi7HrW9rUl+QTwsC8T8TNr
eIQIenEg9AZ3Wo8PhTyIPEgiIE4HGxSoD1cpxPCwNy29hrTdZS622irAmJhOD6SR
mIDbUNhFKEDNRaTLvtlcfl+aPvafE6jZPd6Ds0l58dADSASkEDXriIrWLiH7hj2k
M+mvsw4ITKE5nib9kLVfaZx23vwpwUufqVp7RMA6J7WWd1MJHx6paVu3L+1WF2OU
82+JKryl3lr6Jc9ofUYdARKIqMaNgCxcKRUQOoL7GQaIrpakiXE=
=XLfo
-----END PGP SIGNATURE-----

--eGLW8NzjjVmDHwQh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
