From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] libibverbs: On-demand paging support
Date: Fri, 4 Sep 2015 19:43:35 -0400
Message-ID: <55EA2CA7.8000702@redhat.com>
References: <1441292199-8371-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tLvcC5g3wafiLlbJqhxRrtXlusq01uPf0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441292199-8371-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tLvcC5g3wafiLlbJqhxRrtXlusq01uPf0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/03/2015 10:56 AM, Haggai Eran wrote:
> This series adds userspace support for on-demand paging. The first patc=
h adds
> support for the new extended query device verb. Patch 2 adds the capabi=
lity and
> interface bits related to on-demand paging, and patch 3 adds example co=
de to
> the rc_pingpong program to use on-demand paging.
>=20
> Changes from v1:
> - Patch 1:
>   * move code to revert to legacy ibv_query_device when ibv_query_devic=
e_ex
>     is missing to the inline function.
>   * add an input parameter to the ibv_query_device_ex verb for future
>     extension.
>   * add the size of the ibv_device_attr_ex struct as a parameter to the=

>     ibv_query_device_ex verb, to allow the verb to handle older
>     applications.
>   * check the validity of the input parameter and output struct size.
>   * remove reserved words from ibv_query_device_resp_ex, and remove unu=
sed
>     ibv_device_attr_ex_resp struct.
> - Patch 2:
>   * let print_odp_caps() receive a const pointer instead of a by-value
>     struct.
>   * check that the application has enough space for ODP capabilities in=
 the
>     provided ibv_device_attr_ex struct.
>=20
> Eli Cohen (1):
>   Add support for extended query device capabilities
>=20
> Haggai Eran (1):
>   Add on-demand paging support
>=20
> Majd Dibbiny (1):
>   libibverbs/examples: Support odp in rc_pingpong

Hi Haggai,

Series applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tLvcC5g3wafiLlbJqhxRrtXlusq01uPf0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6iynAAoJELgmozMOVy/dy08QAKMQuTbsGUk0jK9JJVdMao0v
ZXEduQb+0znv/vP7YlNEDJpQ399eu1LbDDzZA2IiBql9tIX2FMaI6aGYxzKGtyGr
CRv+zNClBZFCH6o9TgDVMf3U0nJEZx1w2VvdX9jvQP58EB8at3w+Jd4iVzjx7bW4
VOWfwtyq7tjCMBNDI/Mm0vX2XBWFiXTqhCgSRQNwwelTgNX/lcgsPJNWBWAbkE5d
uqI1SkKbPq59CEuXgOyY6KYHlcAmC9hEKYRb+SvyZzK4L01y+m/a1+tBwiaCUbGD
Na/ChYFlP215nLWrP5yt/pK3PRSbbXXVIR9+7jYCQtsLTlrQgI3YCi6lI5RTi2C8
hKNdLEPwepJyQsFkc5ygJCl9HwwY/4T+iNT3T4wkIixjLgVIHuNW6fnfAQYkV9b4
a0Hz7G01TGwvlHaiCziDvbyYkd1YJ4TehQa1ThNs/EmnfelrZGL2VTWL6kqF0jbb
LuI02b9W48+bslUiwtkCc8UJnJjmEGOId3+QrVraR+PKToS88PifLs18+dUonmdp
y8ZMrd4qpHQ51WUj3IavVn3fnfEuQtaQPle9FUwbFpDZraTOB34NwaDLtw1RwsdA
zoQN2gEfu/lydyVS6DAVeGSTgLCDgauh3C58A+nZCTNWCfjK5gaf4D0bCfU2RgYx
EEv3bWSZ+6Ad255m9AsI
=J4GU
-----END PGP SIGNATURE-----

--tLvcC5g3wafiLlbJqhxRrtXlusq01uPf0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
