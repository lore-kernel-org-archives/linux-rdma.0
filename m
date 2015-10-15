From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: Print error when umem fails due to locked memory
 limit.
Date: Thu, 15 Oct 2015 12:02:06 -0400
Message-ID: <561FCDFE.5020001@redhat.com>
References: <1444918916-17928-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7THOeG19HjU9oC0uU2QnOM2xqPDTKQgSC"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444918916-17928-1-git-send-email-j.glisse@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: j.glisse@gmail.com, linux-kernel@vger.kernel.org
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-rdma@vger.kernel.org, Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Shachar Raindel <raindel@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7THOeG19HjU9oC0uU2QnOM2xqPDTKQgSC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 10:21 AM, j.glisse@gmail.com wrote:
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>=20
> It can be rather tedious to find why userspace is failing when only
> thing kernel report is -ENOMEM. This add an error message so that
> user can figure out why they are getting -ENOMEM.
>=20
> Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> cc: <linux-rdma@vger.kernel.org>
> Cc: Haggai Eran <haggaie@mellanox.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Shachar Raindel <raindel@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> ---
>  drivers/infiniband/core/umem.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/u=
mem.c
> index 38acb3c..a66929e 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -169,6 +169,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *con=
text, unsigned long addr,
>  	lock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> =20
>  	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
> +		pr_err("locked memory quota exhausted (see ulimit -l)\n");
>  		ret =3D -ENOMEM;
>  		goto out;
>  	}
>=20

This looks like it could easily cause a flood of messages (possibly even
enough to DoS the machine).  Please convert this to some sort of rate
limited output (preferably, you would issue this warning only once per
task, and the error would include the command name).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--7THOeG19HjU9oC0uU2QnOM2xqPDTKQgSC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWH83+AAoJELgmozMOVy/dpGUQAII8YewgnWLwDYz780ar7/hp
3am5ATSKAzPXvULZTEhK1AVmekSEMWLz8tDTWJvSeW0xtiwS1YNdqHbsLAnxj3nj
XLh6gWEzlMuq9wQHjh9R2C1LTzcIikohmFzhyPifY9fyQ7iOVOEyTCUCxrZTPeN8
VQHLS0AGds8wPEStRDMcnZW/UhQs1Lag655yTkSECkC7pMZMqCaeAKQOObYrsuNv
uESWQkdjzZzOtrzmkuesveuGci4kXrbUhNOZzhr7UuhqV0Sv9e5BxLm8YoMGDdMs
+XmvxMfi13sid0RhNuUZAviVmQ0LzJNqrz2JHLOl5aPccZprAwK33kjW+/6omIjx
qFv/R4FEq/hnevwMdH+HDfa77jyAP0dxiR8bGEJsS8jtM06iCX3MnEMYwf+l6Tjj
CC2E1dPVvbghF598h1u4KopE+56HLeqR+h70ymou03mn/6tCUoaA0jubOK/+eG7c
ykiqaBn7K67BCxRLPmzlSQK8GpfbzNenE6455GNj3xAXgIsBJCad3usL/rtwoE2L
FtxsmO0THQYiDA/lUwXkdVEFOsjJAlbdzbyy1YhTxpoCXG0z9IPuTA/0SGXYzc19
6EjQBJpgkEoQGgD0ymR7DUJ6lAFPBrH9rkdDjJiqfAr/EtEv6/0dIMaXmDshN5so
s60WwAj84Ezn30oAt7uS
=RnO3
-----END PGP SIGNATURE-----

--7THOeG19HjU9oC0uU2QnOM2xqPDTKQgSC--
