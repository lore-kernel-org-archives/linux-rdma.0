From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx5: fix mlx5_get_vector_affinity to start from
 completion vector 0
Date: Mon, 05 Feb 2018 10:57:20 -0500
Message-ID: <1517846240.3936.69.camel@redhat.com>
References: <20180205142452.7630-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jfpHFOgxTqk3wv5jo/Ty"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205142452.7630-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jfpHFOgxTqk3wv5jo/Ty
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-02-05 at 16:24 +0200, Sagi Grimberg wrote:
> The consumers of this routine expects the affinity map of of vector
> index relative to the first completion vector. The upper layers are
> not aware of internal/private completion vectors that mlx5 allocates
> for its own usage.
>=20
> Hence, return the affinity map of vector index relative to the first
> completion vector.
>=20
> Fixes: 05e0cc84e00c ("net/mlx5: Fix get vector affinity helper function")
> Reported-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Tested-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.15
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-jfpHFOgxTqk3wv5jo/Ty
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp4fuAACgkQuCajMw5X
L91kIxAAxPxgKsyPY67muu/EVU0T76q92eBUFHW5B6efKVpJ3s0kNTrhO+mrSrhw
+bDSpAoW1TCEV48MvXz5/C2s6gAVepfXFKOe1wB5FqiizwJjJhHaDW3pNO/yIFSc
KD9MQDWm5idLwUGmNwFwJ6vs1r9B5R6anI4ksqzOOkvjJVcx8nBstu3e45gr4lcZ
yG75QhK2A4lgm/b0a83KSatVV1vYvE0aR0saeQ1xTKSTlMY9Hmzq86iUe6E9y1+M
OVvJaheVKbPQvyJ2nsqJcv3aqALTOB8vQHdlrOTggxmE87TjP6zsYuvweKA/ZpI9
dkIsk83n6vI+WwLQUV3B9VFDdB/90MH8WglAIFc4SxbyLZyO/Kwn/tfR/DLJ7ivt
Wtt62V0SwNynxlyk4v3o6lu8bigz8PJ1EVj2n/i3D4slQ/2IWnkmtvd4rZK0ylo7
dHc0hzs8iSg3c0Z/KSpIRi4JDaboZD3Z8AfKS7OZ3rqxfL1ZxHXIhddkhuByJso/
f9hpIp/ractX2l9vsnC/Hwj2IP3boQ/k1Gaj4L6N1HFoaTY11+n4x4I40o4DlmsH
rMuGJoFG5wrLuk8/HxpcTDpk+4eqqJowu4qYZokY46Pg9oWy1aAdryoEzjK25sFA
y4SBYiC2Nwe5XLPW00MzTeMwY/UaKeBHvScVRqpQYDHmHC6MLJI=
=mMIZ
-----END PGP SIGNATURE-----

--=-jfpHFOgxTqk3wv5jo/Ty--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
