From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Simplify rxe_init_ports logic
Date: Tue, 12 Jul 2016 10:54:35 -0400
Message-ID: <d143a0f6-8b0e-f0cd-fb2d-ac7fd8714f2a@redhat.com>
References: <1467735023-21942-1-git-send-email-monis@mellanox.com>
 <CAJ3xEMjZT3BO4TzwNiGVrKrqyRsqjYnUraYZopw7L-k4+BUB8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vxK9C3EOkFIdsseQXR5oma4sr4fT77cu9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjZT3BO4TzwNiGVrKrqyRsqjYnUraYZopw7L-k4+BUB8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vxK9C3EOkFIdsseQXR5oma4sr4fT77cu9
Content-Type: multipart/mixed; boundary="LW5roo88OFL2Gp6qLvwdTksaudEwXv4jk"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org"
 <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Message-ID: <d143a0f6-8b0e-f0cd-fb2d-ac7fd8714f2a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Simplify rxe_init_ports logic
References: <1467735023-21942-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <CAJ3xEMjZT3BO4TzwNiGVrKrqyRsqjYnUraYZopw7L-k4+BUB8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAJ3xEMjZT3BO4TzwNiGVrKrqyRsqjYnUraYZopw7L-k4+BUB8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--LW5roo88OFL2Gp6qLvwdTksaudEwXv4jk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/5/2016 5:53 PM, Or Gerlitz wrote:
> On Tue, Jul 5, 2016 at 7:10 PM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
>> Simplify rxe_init_ports and remove double free.
>>
>> Fixes: 0784481b2f32 ('Add initialization for Soft RoCE driver, pools c=
onstants etc.')
>=20
> same
>=20
>> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied, and squashed into original patch.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--LW5roo88OFL2Gp6qLvwdTksaudEwXv4jk--

--vxK9C3EOkFIdsseQXR5oma4sr4fT77cu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQSrAAoJELgmozMOVy/dfGMP/2Aep0G293MY7nZCP2wKhGoX
gJfDcc+a161svOCXl1vTI7N5tqCbCVKxaOzDQIa6aUVtfs3DqStensHrR3V6Ip29
wy+BBWCyFlnFMUI4UbZDrhyo686aQeMB7OhzmyIXaWiN5G/Qojs2fxUXHofmLQne
gVXXTjtSMuDjWGPpsmmBVFMPFM1V6fGbIaJG8K1I42liCsyWddmR3wxB0DoNy6aA
YLTRB9LHsAZkqSmbl9rjjxlcbsIayQ7TOhQfQp/uySczLTQidp6JEeOqqA2IS4Oc
S4o6oEoQG9A6w/LxZZKDHxFtRiyoaXV+2BJRMAnI3a3cIZmu3SlLvzuIo1ra7hhK
P4xv5JkncYI7AT6rDjSXgZRoD+9b0mPz+BwVLwp21TQrC4xBsEcm9pwHhlByFfAG
nOxs7CMPFaWJL9VoglDLOCAe2/qdhUZfWb6J6M4psRzDzlo4DIE75OxIwLUc6hOa
GWqHDnWm0QxqX3so6a4zPVVRVwntLPqbGsqYVZuLiZ1o3bObB5cMl4NZWBKHJNiE
RMUCy5gZK8xdR8eJHvkZelvOAXP4RbSkr9cH/s/ud9ny9Qf6B/Vm8t0wzdjoumSg
PKhGNh5hzZ6EK2vB9oURaVxtgUqJztlMlTMH5qVTozccdnv97ANbckwsd7DFHLcg
8J6r/BmLZlF0KX9gsLjU
=y+MU
-----END PGP SIGNATURE-----

--vxK9C3EOkFIdsseQXR5oma4sr4fT77cu9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
