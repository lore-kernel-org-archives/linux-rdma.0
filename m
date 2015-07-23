From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can
 exceed 32b
Date: Thu, 23 Jul 2015 17:32:45 -0400
Message-ID: <55B15D7D.3090601@redhat.com>
References: <20150722191417.9306.17387.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0Tf0lEDOAKBf8ICTppSW3rxQPdCPaaGxJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722191417.9306.17387.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0Tf0lEDOAKBf8ICTppSW3rxQPdCPaaGxJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/22/2015 03:14 PM, Steve Wise wrote:
> T3 HW only supports MRs of length < 4GB.  If the system can have more
> than that we need to fail dma mr allocation so we con't create a MR tha=
t
> cannot span the entire possible memory space.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>=20
>  drivers/infiniband/hw/cxgb3/iwch_provider.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infi=
niband/hw/cxgb3/iwch_provider.c
> index b1b7323..bbbe018 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -736,6 +736,10 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd =
*pd, int acc)
>  	/*
>  	 * T3 only supports 32 bits of size.
>  	 */
> +	if (sizeof(phys_addr_t) > 4) {
> +		pr_warn_once(MOD "Cannot support dma_mrs on this platform.\n");
> +		return ERR_PTR(-ENOTSUPP);
> +	}
>  	bl.size =3D 0xffffffff;
>  	bl.addr =3D 0;
>  	kva =3D 0;

Should this be a static check of the pointer size versus installed
memory?  Would it be possible to have this work for machines with less
than 4GB of physical memory even if they have 64bit pointers, or are you
concerned that hotplug memory could take us over the limit after
registration and cause problems?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--0Tf0lEDOAKBf8ICTppSW3rxQPdCPaaGxJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVsV19AAoJELgmozMOVy/dC3oP/j6BgR6cOUPrRZn0BiiQD7gG
GbFa26KRp+LrQw0a+/X3TDErvaMjl2gNxn3DeWpTUndETlDnjm5mQGDECsPeRV+W
U6gzap7ofnZedxR1Xam4+FxfDtmlUH3e6/GYr/h8kfKow1hOq+uE+RyV8+RhVjSi
8qtHH8Mm4J1LE2TqdWQz2zG7gukFqVChdbqCChvU7tr2gwZmlqqxxKYQ/ViIIyy0
Df+vCTJCpfpoPVpLqTUFTetTI2BTnq1k2GUAXSNCzzJni/yz7v3zwKewH6e6pgwi
YW9qWQDYCG8d1R72ulfpFkDIIkuccmgTwvTSSHtt7ds3+lfJLhGgHC8ivxncJhSO
oRBz3VnPO4Q0fRU5OIlK3RWXmCznzeTBgc6CWsurJhtG3mfQo8fYi32L6e6f7tyY
KAR8UyWF4xjY4V9WcLWFDa0At7fHkU+L01RU3qgOvGp7ZcsbplJlEVYL2yG02H4N
NHYOy/lOCpbLhgQXD1gIorfMzy3kwuTKfhCrmdd1cDyD0LOZHokRHS0laUr0V0uK
viDxEWFNyll+yN5CcSC2Egkif8zLaYqiNKSzSjI+cKvDfzfkgeOw6faycnljRFh8
RJH6uc527v7ovA7b4G7T6Kzx3Ct1abPJJxbLlfhBz+xm7KhiqQBeiI7sGN+ArNWz
RJYagO8D+ReqYja3EgNR
=Ayo9
-----END PGP SIGNATURE-----

--0Tf0lEDOAKBf8ICTppSW3rxQPdCPaaGxJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
