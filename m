From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] Add support for CQ moderation
Date: Mon, 13 Nov 2017 17:08:34 -0500
Message-ID: <1510610914.3735.48.camel@redhat.com>
References: <1509372543-26603-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ELL/JGQtSbdX/oD+NLpx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509372543-26603-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ELL/JGQtSbdX/oD+NLpx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-10-30 at 16:08 +0200, Yishai Hadas wrote:
> This series from Yonatan is the supplementary part of the kernel series t=
hat
> was sent for 4.15 few days ago.
>=20
> The series introduces the ibv_modify_cq verb to enable CQ moderation, it =
can be
> extended in the future for other options by using the attr_mask field.
>=20
> By using the ibv_modify_cq verb a user can moderate completion events by
> specifying the number of completions that cause an event and the timeout =
in
> micro seconds to cause the event even if the number of completions was no=
t
> reached.
>=20
> The series includes below:
> Patch #1: Exposes the related moderation capabilities via ibv_query_devic=
e_ex.
> Patch #2  Introduces the ibv_modify_cq verb to enable the moderation.
> Patch #3: Add support in mlx4 driver.
> Patch #4: Add support in mlx5 driver.
>=20
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/238

Kernel support was merged today, so I merged this too.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ELL/JGQtSbdX/oD+NLpx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKF+IACgkQuCajMw5X
L90KGg//VhfbYWjLsDqUit4G4BhKgEe8UD+nFIg+NZcy6LInjn5Ma8uCFyI1+jFa
k/ix4rQXcFNsGAHFvoWs6U4sDg+eCiCnAbUdi0PWj7UGOpjrW2Ui3qpHKtEpzfDP
EoYO324vb5ZGsFVYbQDYXhmkeIMY0DZ+ie2McmSixTRPTGdIGsKFVvL+lVf0pqzc
IfXrSzecyPId9JL/LvZ8NEvO61DDJUJ3ObkJAXqivFtbxbkP3hAUIiltwCT8AH2u
CVI6bHMvLLNoLAgr0s51Q1xL6kQNJ28H6aYO6pQ8FEcKScDR6uBUw1l75BcSM8cp
1jMShxWrPUtPmCb3VE7zAEguvBAmz+gMf6QatF7PC8Kupm88dU7JZlWq6Mr7XHbC
nAMEYNWeYXQi8E6Mfa3JoAysEvGyxOFgUvQVTdfr0EDSUaf584f+Psi/pj2ASEI5
viMMP2Z9btaF+wHjXlDsQ9ZoiITyP/SRJHFB1mM2NhyA7uxAsA5rEs6DRqN4ndxo
Z6piUbCGHxdXJA2Ns/4SjpXEfSuYWkMnMk8bPXXn3KJuGzPjyqLW7JBqUGEMdy2y
EalqFQOliYavMwUHV2nWOFawlqIhsebbtgxvmI3XQHGjKZBhr3uyzdtHrvdPDsta
MMrFTdJ3Dya3PUGPZgvr3eAb/qNkaDpeE1l63L1oH8a4KYNYefA=
=pvmR
-----END PGP SIGNATURE-----

--=-ELL/JGQtSbdX/oD+NLpx--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
