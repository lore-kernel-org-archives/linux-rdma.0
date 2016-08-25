From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: Make ipoib_warn ratelimited
Date: Thu, 25 Aug 2016 10:24:39 -0400
Message-ID: <1b62882b-ed0c-0e65-0149-8585de4596e0@redhat.com>
References: <1470234370.18081.63.camel@redhat.com>
 <1470665662-24028-1-git-send-email-kernel@kyup.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l8VTlBmbh4EkHAOKibSVuxTqHBGuIlWcF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470665662-24028-1-git-send-email-kernel-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l8VTlBmbh4EkHAOKibSVuxTqHBGuIlWcF
Content-Type: multipart/mixed; boundary="CGbmE7C42v1Dmhctg4LqA6DXVS1J65eXo"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <1b62882b-ed0c-0e65-0149-8585de4596e0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: Make ipoib_warn ratelimited
References: <1470234370.18081.63.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <1470665662-24028-1-git-send-email-kernel-6AxghH7DbtA@public.gmane.org>
In-Reply-To: <1470665662-24028-1-git-send-email-kernel-6AxghH7DbtA@public.gmane.org>

--CGbmE7C42v1Dmhctg4LqA6DXVS1J65eXo
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/8/2016 10:14 AM, Nikolay Borisov wrote:
> In certain cases it's possible to be flooded by warning messages. To
> cope with such situations make the ipoib_warn macro be ratelimited.
> To prevent accidental limiting of legitimate, bursty messages make
> the limit fairly liberal by allowing up to 100 messages in 10 seconds.
>=20
> Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>

Thanks, applied to my for-next area.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--CGbmE7C42v1Dmhctg4LqA6DXVS1J65eXo--

--l8VTlBmbh4EkHAOKibSVuxTqHBGuIlWcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvv+nAAoJELgmozMOVy/dW6AQALtNueFXtD6aa+7c8POEvYdH
GMyDSg3ZWOr4Xgt9m5jHHwXPSaBazl188FQGw6CiUYdv5SnJtFftQkD3JRgsdco+
cX42pjiVEUHfkVWJRCFa3sFPbPpe+V9oSA51J6Yr4pRk7bO2y1oT4aRs/bXpF7Un
e1ggdIRbqaraZF1Dph9Ugc3KsN05y2mB5LP6NiVNwrl4aQj3hNZolGGW+vOqCo1+
GVkccyfPtiP+q4niKkqKUKVlsYyo2MPUwUWcVgHuwSRgiqridE5Q+txo013wrDBs
2t1zlOBTjUA5Drv2jCbfGUcMBGSxmUbQThZniAuYsQNdkdXF6u7QPqwWQ499l3DJ
/C+OzGMzKi+cnhqSLGZn+9XXqcnpLarI56voGYK0CHoQKLRjW3dPKc7tM3YfwKSQ
ExdbfVctCwyZmTStRcWOKm2YLhNOnVYpsAAgwTqG41fxN7COzX2AcW220nGHGF5p
wNQkLtOfGB/d8iFG0k1JcFAr4yiPlbIwz0/dEnbUCZ+oz6YrJp0dHUSYTndB/VBo
4YWjFuYXj2UtCtoXAVoS9W0XNNlkp6qOGz23vhREp7IKoIX4kSOEypJgzvMLtvRK
ZOrDckvqSDBo0qTUqN1rP4H5olw+VzOwxJbMN8jnKrz7WIUOfUngCtFzYblIYRd3
rXQ4KQii4Ymt8TtOoQ5f
=IDF9
-----END PGP SIGNATURE-----

--l8VTlBmbh4EkHAOKibSVuxTqHBGuIlWcF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
