From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Wed, 10 Jan 2018 16:40:34 -0500
Message-ID: <1515620434.3403.169.camel@redhat.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-o0YcvQofVDaCWKiKPTVi"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180109192340.25702-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-o0YcvQofVDaCWKiKPTVi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 11:23 -0800, Bart Van Assche wrote:
> The following sequence:
> * Change queue pair state into IB_QPS_ERR.
> * Post a work request on the queue pair.
> Triggers the following race condition in the rdma_rxe driver:
> * rxe_qp_error() triggers an asynchronous call of rxe_completer(), the fu=
nction
>   that examines the QP send queue.
> * rxe_post_send() posts a work request on the QP send queue.
If rxe_completer() runs before rxe_post_send(), the send queue is
believed to be empty while a stale work request stays on the send queue
indefinitely.  To avoid this race, schedule rxe_completer() after a work
request is queued on a qp in the error state by rxe_post_send().

I think that improves the log message, yes?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-o0YcvQofVDaCWKiKPTVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpWiFIACgkQuCajMw5X
L933rxAAlg3tm0MooPzD8fzRVNQDYwBTFCJBPXGEqhU/Vnl6VRpDpB9qB0KhsIXu
5fP4L4tK+wkL41uBfp1MDz9Zu2vzfvHNPr48L1s9K9MylgQ9CLpcZZUNXnYGfHNw
qv6jof7L7l4TZ+782jdXH68erQVBQZdaY1voelmE489ZxaIZoT5YgHmo73pvfMcn
SHSi+qvm0j+FZ2jWPUbsC+b2m9157RkihL2W9OFXUhS0brHC92O7M1mf37oUEbMw
/FtPwq9ogS7zbpYsBdMrOZUkCc3t5979/zUM+qg3eGAT4XQ+E5VL53d+bp4Tl/d9
PD4kKYZ1sF12VY7M85e/K5uPncKB1OIn82pqR+UUHGLQu36rX8vAruSXKgQEIa9T
aTgFulWK8OQJq6ripIgtpYJ6nkKnD/tZ5zvNnbFyfFY57OodFyYAC5/zcaduNWXk
fKotrSbIcvuyO253v+EzBuaDRtskAAkBm2nYA46dCQAtswpMMRZLPfd9t8MBbOHG
wG/ljw51q37cufQinGkQBDz9xERUEGY7kfWDGZ64JIxTPvS8q4I2NUZTKNZTwmYr
NKf3mqBbRqOiaMD62w+UkzjRjLWNAY4X51GMgsRgw4diyRhgp9pSWlVdb9CAN4O9
6IicbY/b7j8wt4b5IMEgEB6zZoOmOIQ1i6JCOjVRMaOT7MWeNOg=
=g81Q
-----END PGP SIGNATURE-----

--=-o0YcvQofVDaCWKiKPTVi--
