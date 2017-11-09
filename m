From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 rdma-core 0/2] libbnxt_re bug fixes
Date: Thu, 9 Nov 2017 13:54:02 +0200
Message-ID: <20171109115402.GF18825@mtr-leonro.local>
References: <1510225840-20034-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2+K7TauFN1Oc3ugB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510225840-20034-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2+K7TauFN1Oc3ugB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 09, 2017 at 06:10:38AM -0500, Devesh Sharma wrote:
> This patch series contains important bug fixes.
> Patch 1 address the memory barrier changes Jason
> asked while reviewing a similar change in bnxt_re
> driver.
>
> Patch 2 is another fix found during internal testing.
>
> Devesh Sharma (2):
>   bnxt_re/lib: fix the memory barrier call during poll-cq
>   bnxt_re/lib:increment psn in case of 0 length packets
>
>  providers/bnxt_re/main.h  | 8 ++++++--
>  providers/bnxt_re/verbs.c | 2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>

Thanks, applied.

--2+K7TauFN1Oc3ugB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloEQdoACgkQ5GN7iDZy
WKecxhAAqEtcvgVqD1pCx+m/yCa/TrqInU4hSirHLwVOPWhOW9+PbmF2sU2ffROf
AnGFPkSGKWNOKEaOdHBDPEPXSXgSGzgeSHISNw64efSaR84/DmntT56bojj1KaZS
P8VJC6PeJAww+kmSb9dcOh4maDEb5IRF2/w4AHNBMyFo6fo8dUU+7uP/PRoDeLrH
okNAIiGDg2JsKhUOfQRK0j4IQ/JcVf9vwFy0vZno13uSC1qpCV34IUmwadZ9R+OL
4/OKgz3navI5wANklZgtWIjRjVHpTjJG87n1dY9nqxvlxAScZatPJ+LGbwL3DpX0
FEuqZ4HUwmdUOK9a/PWd3c37cfO9diyVTl68BRdNwSw99hsOxnm5xCmso9h8mAVL
hlhL+dmeUmiCVGnXo552/JuV+4QNnoYYJRYt64hkJZ08+dGtbJECISEHpGhTVM4D
7ttGyNBOTOi8U+1qTo0MNwNwSi4wcV0f3PgF91ziPRwG8LCNunDn9Y/f5VVJpDEc
BAFM7aK0FGtY/haNEeagywuwPtd41JO0Sw6m6kvAuCRbGpWPyfzW5R6JJMS4HIWh
Pb60SpeUYbeWmN1aX7HXh+QriKOGVOz4wVLwN5hGLK/9QHjgvEC1mpz9u50u567O
lvEp+bd/j+LuuZRnX2Rz4Olq9QoHh0u4RyxTSPyblk4N1oUTaHs=
=9HUO
-----END PGP SIGNATURE-----

--2+K7TauFN1Oc3ugB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
