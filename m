From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Wed, 10 Jan 2018 17:01:40 -0500
Message-ID: <1515621700.3403.174.camel@redhat.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
         <1515620434.3403.169.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-3NSRKnOWP8q0w63YdoM2"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1515620434.3403.169.camel@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-3NSRKnOWP8q0w63YdoM2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-10 at 16:40 -0500, Doug Ledford wrote:
> On Tue, 2018-01-09 at 11:23 -0800, Bart Van Assche wrote:
> > The following sequence:
> > * Change queue pair state into IB_QPS_ERR.
> > * Post a work request on the queue pair.
> > Triggers the following race condition in the rdma_rxe driver:
> > * rxe_qp_error() triggers an asynchronous call of rxe_completer(), the =
function
> >   that examines the QP send queue.
> > * rxe_post_send() posts a work request on the QP send queue.
>=20
> If rxe_completer() runs before rxe_post_send(), the send queue is
> believed to be empty while a stale work request stays on the send queue
> indefinitely.  To avoid this race, schedule rxe_completer() after a work
> request is queued on a qp in the error state by rxe_post_send().
>=20
> I think that improves the log message, yes?
>=20

I did some further edits.  But, patch applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-3NSRKnOWP8q0w63YdoM2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpWjUQACgkQuCajMw5X
L92aCQ//YYaMWDPGifwf7TNYAhEHXWsKCfumxjBkZOR7L19Dnxi7rwMgmgkPe0Vw
tVvwj93zkklZKhskkxh/zap0EWKMzTu4UbNXwhp3c2LgZFNEn8U2VQc9TrUW60Zv
RtKFOQqAtlpPNqUOV+KuDhyEEbeNOsxp6dcLAzSA4GhRX5uRq5oQVwl+rI6o5BQI
nbQ6X/h42Q1bETaLwmRa/S3W00S4dYtoviT5IgxO5Qfi60cyPhvRJO2QBpCwa4rP
LVwXM3ZBcJrHQBHQ6ruyFTxoe07WHJMDXVyqbez4qrkszWBuZsIs14LfECTCOZH9
Xf1AMqBWy2MUzWE/HJuyKvH/KwThkhx4Jb9hb8wqEaXO+s2ReDrB3w6VDRBsfOTI
jXPaH/VhwZNnrr9x31vUvCEmkpyd8SIFMdtVrSnN94UEHnWtLXDYmHParkyT5PoW
Y8c1XIwkNsuQDJLZd7qogFY43+YkEATgW0ecLCEhpRghOloGio43ZF0tTkZnBkDL
2wy7FXJ6djrWq7SyPCaHsJ26k3OJcNU5kGz56NBT6hVtSD6lv8JqzHe+dvGVx+sh
m1RD0gD1Xw/5a0C9VJLuVZCTGJm2BqdiX1SPHFPITfdNLmCev9/yMRXEvPXh0mh5
FsmoyAcmLSqxFkEw2PxrvmFWd8R5UF573V6rY75g6C5exlCpWus=
=TNkr
-----END PGP SIGNATURE-----

--=-3NSRKnOWP8q0w63YdoM2--
