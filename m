From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: update usnic maintainer contacts
Date: Wed, 21 Oct 2015 16:43:58 -0400
Message-ID: <5627F90E.4070106@redhat.com>
References: <1444964489-24798-1-git-send-email-dgoodell@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tE3mQpOALb4h0SHEx17OCqNeiQRr0QUcf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444964489-24798-1-git-send-email-dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tE3mQpOALb4h0SHEx17OCqNeiQRr0QUcf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 11:01 PM, Dave Goodell wrote:
> Upinder hasn't worked for Cisco for a little while now, updating to mor=
e
> active maintainers.
>=20
> Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

> ---
>  MAINTAINERS | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5f46784..20cb877 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2730,9 +2730,10 @@ S:	Supported
>  F:	drivers/net/ethernet/cisco/enic/
> =20
>  CISCO VIC LOW LATENCY NIC DRIVER
> -M:	Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> +M:	Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> +M:	Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>  S:	Supported
> -F:	drivers/infiniband/hw/usnic
> +F:	drivers/infiniband/hw/usnic/
> =20
>  CIRRUS LOGIC EP93XX ETHERNET DRIVER
>  M:	Hartley Sweeten <hsweeten-3FF4nKcrg1dE2c76skzGb0EOCMrvLtNR@public.gmane.org>
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tE3mQpOALb4h0SHEx17OCqNeiQRr0QUcf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJ/kOAAoJELgmozMOVy/d3EkQAKPsjItsI5lGC+mfQsluQt1m
NiLdQiBF+NL40mDVgCRdO1wE1Rw0y5tSIoWSm5MWGz5Hhwa9OuNq1E09fLccpOAz
NI355N9Hmpdn8nnbDJ3ly1UfdO7cuYu0Fkai3CKpKZWWrj+5TYUEfejwlWwXcHqO
OOkcM6EoSbs0HGpj0VajBt8b3oGJ6ZhJPO1t17/LdAwrX51vX2pzyGcmpNq3+KAS
VS2vyRSppyJFSJ0Fl1ToNFFWDt1JB3WzSEeswXd1Wn1Jx4n22uTyEBLNfO+cAaQw
baklv7Iq3FxMLcetR707m+n7cnERiiXEU571K/8d9uaJXnpU2eR37xPXOF+/REHA
VsjKIwMXvpQcuz7aMZvW2QoqK0QtmYsGWqAlADtvvq9EvV9t1mrjWxzt+RxcxBNU
Dz8rF7XmEcb98bDQmU9I2Gn/wW+x1ZjnxWrgjTgazdXFUWNO7e14JGs489Rf57BC
kQczJlS5uhCqJG35HsoQONDdnUKVsIU2F5E8ks74Ise+/by1SFLTe6W+IXjb7FiJ
c/9H5BnANbDtFsPAzHpOzV2/Hv/4kvrdm0dglDNibwhKS3K6daHQWHRXJNwS58Ar
jesuaJixbbppAFSEBRN6r+hJvAPd2L+S/CYJUknc2plI0nzDerPupc4CderHTSO7
2P/aLlw4oO/Bb5iTxMQA
=ZHR0
-----END PGP SIGNATURE-----

--tE3mQpOALb4h0SHEx17OCqNeiQRr0QUcf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
