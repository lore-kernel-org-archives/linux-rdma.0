From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 5/6] IB/core: Take into account optional
 UDR, XRC headers and mandatory ICRC for RoCE MTU
Date: Tue, 17 Oct 2017 14:12:28 +0300
Message-ID: <20171017111228.GO2106@mtr-leonro.local>
References: <20171016054517.30643-1-leon@kernel.org>
 <20171016054517.30643-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a0kvDU9Y5772Ejco"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171016054517.30643-6-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--a0kvDU9Y5772Ejco
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 16, 2017 at 08:45:16AM +0300, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> This fix considers optional UDP, XRC header sizes and mandatory ICRC 4 bytes in
> calculation of path MTU, by considering additional 8 bytes, path MTU calculation
> is more accurate.
>
> Link: https://www.spinics.net/lists/linux-rdma/msg54558.html
> Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/rdma/ib_addr.h |  7 ++++---
>  include/rdma/ib_pack.h | 19 +++++++++++--------
>  2 files changed, 15 insertions(+), 11 deletions(-)
>

Doug,

The title should be "... optional UDP .." and not as I wrote.

Resubmit one patch/whole series/do nothing?

Thanks.

--a0kvDU9Y5772Ejco
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnl5ZwACgkQ5GN7iDZy
WKfXJg/+KyXmC9QSPISBQ8iVjZkoUISdruqK/JS7WkaZfULw3Vr0mUbu5htWR+VS
zykYv9wExsGb5KIa9nMA3UvHe9/jN61D+1qNhX9QIDsVGMKpdOhgRyOC+OTMx2OU
H1MI8hNh1FWQ7yVegbH83xvsduiQENeXVkgsGgb1yB8X4VcIIwPFO0sbA8wtnWzC
Iz1Ql3p3UDX7GrynLiIrV2ng1MG0A+qRLUqZiyaHl/Okuf7XIhEnd7golzvHn9SG
6aj/JU8LpU5Phturs45ki92ixRifIlT6HgDVZa2oNtuOMJnhbMSibtq+ABBSA2kp
xkEVgxAJIVRg1UTb1kqdv0mmD+8hgbwZSM/CG29+TEeqDvXuvn/7c9iEGpqg94Rz
z9o5+Gjt4FcZKQjhEuGKft+SfzVuG3FrfBiXGszPdwl8df4vrnXE57RYY1dtT4uL
tcBgLNs/uS0p6FupMC2KojyJEot7g1kZ3tyA08rWBr+HFBlgAuC4S/k80kES8XxT
7Z5BYgZAxuLrF1uPA1H2L7hDd53mIfvYkap3NdbG3WBIr6HIoMg6wuNAfNXEo5FL
f7A/QFqmXqGOXXzm87UF+VsMqOMevMT8fKivozeaKqy3JDrrikD6wTU6dVGGcnVf
YJzzyNGRC5+A1czxyELo/vpXfUH5iJVkWuujAcLlEEU/eLcdjSE=
=xpkb
-----END PGP SIGNATURE-----

--a0kvDU9Y5772Ejco--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
