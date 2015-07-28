From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix missing device local_dma_lkey
Date: Tue, 28 Jul 2015 11:09:56 -0400
Message-ID: <55B79B44.20109@redhat.com>
References: <1437411276-22731-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rDRun7QTL6eOg2jTwnEqDhB4uQiFodhbf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437411276-22731-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rDRun7QTL6eOg2jTwnEqDhB4uQiFodhbf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/20/2015 12:54 PM, Sagi Grimberg wrote:
> The mlx5 driver exposes device capability IB_DEVICE_LOCAL_DMA_LKEY
> but does not set the the device local_dma_lkey. This breaks
> rpcrdma drivers.
>=20
> Query and set this lkey when creating the device resources.
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, I've picked this up for 4.3.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rDRun7QTL6eOg2jTwnEqDhB4uQiFodhbf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt5tEAAoJELgmozMOVy/d1L4QAJuji2menJDgs333Wxa1Kprs
ZLTmYLKDqkhM5Kw3C187dzNgbQYW5bi7VBmwqNMHXut7LtzVEGwblsfbNe4MFudL
A6a4o3VRz3zT1rbjtS4nVn/ZUvoRcDbOV4H2Sm4Rdb/QIP/Wm1YQD1BZaiZGovRe
0EeXSsUkKSJWvx7TjIcyVlwiCrHmtzjoz9FRTquQ1Gc52jXqQLa7vmlJ4LMkdhnw
H+FcHgzwH1Q1R6gPmSq8lSr360QzuQ2JENOKgzI9VQBB98PggSa2IkT1Mpf57IxN
1sR6/d38Vq+WnXod1K6NfIFlKSGGnTUVC4yeG5ezVgvRTd/nYVCzXyPP773K4Ooo
fOYzwekbkBdrXiO23vYtUmdjFwF246gGieLIroF4m+0mgaSq/OQNlQDt1U9vYsVV
GmZdlMOB/xr7QhHGW6xVdNMfLj020jTdQiWS4VdeukxeINPsPZXygIVWn4ZCPDe7
sTVevvr5/8QK29uoH7FgOSjZVKyO5h5Koa03C++kr8J2TkSqTNRd9udIbIDe8iZI
9RgWR1FxNr0Pl4KSDuYzPqhZL9X6d7HKAIRSCGUu9c9Ut8HfaCdzawcS3M6O63O9
W4luxFlncF/3Ec1g8EaTRTgILWOOaJHc4NzRXY6WPaBg4HQIA/+N6bKBmMyD/UV8
ME5DclO/dbFe1gK+JTTQ
=XTzq
-----END PGP SIGNATURE-----

--rDRun7QTL6eOg2jTwnEqDhB4uQiFodhbf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
