From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1] IB/ipoib: Don't allow MC joins during light MC
 flush
Date: Fri, 16 Sep 2016 14:11:26 -0400
Message-ID: <4ff87d50-eecb-9ee8-3a4a-958fe6d0d750@redhat.com>
References: <1473663328-30743-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1jEENTd6XM8ICA3GUS4NItpiWDKktBL2B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473663328-30743-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1jEENTd6XM8ICA3GUS4NItpiWDKktBL2B
Content-Type: multipart/mixed; boundary="kJcTw8uW8JNnCt1wnT6gnvVbJEWdMuvEw";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <4ff87d50-eecb-9ee8-3a4a-958fe6d0d750-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1] IB/ipoib: Don't allow MC joins during light MC
 flush
References: <1473663328-30743-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1473663328-30743-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--kJcTw8uW8JNnCt1wnT6gnvVbJEWdMuvEw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/12/2016 2:55 AM, Leon Romanovsky wrote:
> From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This fix solves a race between light flush and on the fly joins.
> Light flush doesn't set the device to down and unset IPOIB_OPER_UP
> flag, this means that if while flushing we have a MC join in progress
> and the QP was attached to BC MGID we can have a mismatches when
> re-attaching a QP to the BC MGID.

[ snip ]

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--kJcTw8uW8JNnCt1wnT6gnvVbJEWdMuvEw--

--1jEENTd6XM8ICA3GUS4NItpiWDKktBL2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DXOAAoJELgmozMOVy/dvm8P/iMPkMULPKAoSO2qd+V7XN6q
pBT/7ltjB+g9zuFXGNbd5v6BltSqzG2sT6Aj1T15HiqQnTd1wEVf3yktStV0L9L/
Vk9G2ySagFQr0jbfhuaXvnqrbj88oYEWnUwXCl6Tn+CcKQ5JTeKxJcjjNdKBxw/L
bSlhzfIOksehQ3d5PE9KU1qBl1iTTmWZCEkjCYgWZgLdwAZVy4baOUqL+amNClBH
zQnsex5PIWfRPUIpy4Kh7NDJes9UfIt7K5q5AGXRVsrDV1G4T+kVvT+KuzvIwcQt
M3kgZzcMC+g7XXkOwqN/VF+8uDXP1pdcdASZDqA9ZKGq1YxqG0G2g+qfVClgU5Yo
cb7dwTZXCJCzb3T8pkZXpZqmQ9sxCd4LbzqNF9hQdIhVyEcWIKnBvK1SvXQ31h2h
DrgE+ssgsRbY3xKD9PbJCDMAK4aQYeSDwn3h6E/7Zai/Lgy23PZqHYvAkZiH5VIX
DqE4cMb/dpcGKviJmF0W7rwt22D3s01QTnhhQqHjMJaK9D8onqE66DlFZw50XURV
WgwRT8j3d93psDgKaknI38UOzrMccRXqnzm/AzXoLljBTGN2BaJaY6ZzejVrrO6f
3044YJJHODydZT7ZWY6qE49oeT+DCA66iBnxguwtiWruneV1NJDzsChWI+XBQDXk
p8OX9cfPagxY9lKfER6u
=UeEu
-----END PGP SIGNATURE-----

--1jEENTd6XM8ICA3GUS4NItpiWDKktBL2B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
