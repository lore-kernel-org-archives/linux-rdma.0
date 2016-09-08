From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Thu, 8 Sep 2016 17:07:52 +0300
Message-ID: <20160908140752.GN18398@leon.nu>
References: <1473232990-22766-1-git-send-email-dchang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hOh8F6DNH/RZBSFD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473232990-22766-1-git-send-email-dchang-IBi9RG/b67k@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hOh8F6DNH/RZBSFD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2016 at 03:23:10PM +0800, David Chang wrote:
> When using MAD_IFC command, we should also consider avoiding in
> ISSI > 0 mode, otherwise most of the MAD_IFC command features
> are deprecated and cannot be used.
>
> Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
> Reported-by: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>
> Signed-off-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>

NAK,
It is wrong, the deprecation is removed from programming manual.

Thanks

--hOh8F6DNH/RZBSFD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX0XC4AAoJEORje4g2cliniVgP/ieCqccnXEfGTm02TrIcLbeE
qMhccdbd2irJNhJnBQuzHpuQptOeubF12P+EWO/T/cCz9edlYFMjOjlkyKBEO9ne
N/dpLDsO/h7hb4WvAyXf97wwoLDsV+TF5ZlLr1QJogQZHITgljOC4K+qXZ12yF0Q
twI1nhttWRiZWlz7RaV7Ju8k9gnH9PLY7L+wFFkf5MjcMQ6Y3y6K3ne2bkcKJera
Vy6q7ZcgyYUzauiytJJO2Ufxyu+DPzyys/aGfFlNZ5T3fRZYmFF6u/gBx6xqOA9k
ci4xUdZr7Mx97ZSAvFG80Wdx7r+ITKok7TIAp4pohW0/U+oDlPB69Jrtkvu5ND4d
BA4EPPa7O/8nDa70E3zd+RCXusLJ2cHF/e+xiy7p4Zd2YFaoXE43405IExJHVKsP
9S2cUkroyCVlBXUcz4MIAHrdGWCRWLV1+3HN3GWawdtCM5TRv3w+SYohs6U+eEwH
8QrgDYGRHefFiya5qQRZFBNnS93WVDOwWU9NY91WTmqS2Ii5zneSyBch5rZFs4L1
ZV1e1JYK408pJt6W+gsGRxMdY77XbDFO6lxrn2j3olI8FGPoiFLqtgpHXiH/4Avh
iJEyD/x5cjD5shN0gb3VEyyRDXqeKWb3/lcpcXIvuizknIhPjEbMxFWmN1VuFr1w
VQpvLk6tXKuiLVI59eWH
=3LO0
-----END PGP SIGNATURE-----

--hOh8F6DNH/RZBSFD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
