From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] staging: ipath: fix build failure
Date: Tue, 1 Sep 2015 10:52:55 -0400
Message-ID: <55E5BBC7.1020007@redhat.com>
References: <1441112498-22057-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IFfceqaC7J5noe9k1faN4BRhNbIsM077v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441112498-22057-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IFfceqaC7J5noe9k1faN4BRhNbIsM077v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/01/2015 09:01 AM, Sudip Mukherjee wrote:
> building of ipath depends on infiniband. And if ipath is selected and
> infiniband is not then build fails with:
> ERROR: "ib_alloc_device" [drivers/staging/ipath/ib_ipath.ko] undefined!=

> ERROR: "ib_dealloc_device" [drivers/staging/ipath/ib_ipath.ko] undefine=
d!
> ERROR: "ib_dispatch_event" [drivers/staging/ipath/ib_ipath.ko] undefine=
d!
> ERROR: "ib_register_device" [drivers/staging/ipath/ib_ipath.ko] undefin=
ed!
> ERROR: "ib_unregister_device" [drivers/staging/ipath/ib_ipath.ko] undef=
ined!
> ERROR: "ib_modify_qp_is_ok" [drivers/staging/ipath/ib_ipath.ko] undefin=
ed!
> ERROR: "ib_wq" [drivers/staging/ipath/ib_ipath.ko] undefined!
>=20
> Config at: https://lkml.org/lkml/2015/8/31/328
>=20
> Reported-by: Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sudip Mukherjee <sudip-ofJRbWXBVFamYgehrs7/Lw@public.gmane.org>
> ---
>  drivers/staging/ipath/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/staging/ipath/Kconfig b/drivers/staging/ipath/Kcon=
fig
> index 041ce06..1edc21b 100644
> --- a/drivers/staging/ipath/Kconfig
> +++ b/drivers/staging/ipath/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_IPATH
>  	tristate "QLogic HTX HCA support"
>  	depends on 64BIT && NET && HT_IRQ
> +	depends on INFINIBAND
>  	---help---
>  	This is a driver for the deprecated QLogic Hyper-Transport
>  	IB host channel adapter (model QHT7140),
>=20

The ipath driver was moved to staging/rdma/ipath and has proper
protection against being built without the InfiniBand subsystem.  Where
are you seeing this tree?  I'm curious because I no longer have this
driver in this location in my tree and I never pushed it anywhere other
than one of my trees.  Is this maybe in linux-next?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IFfceqaC7J5noe9k1faN4BRhNbIsM077v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5bvHAAoJELgmozMOVy/dN/MP/0uIt+xsUrIF4CbW9uy6Q/z5
3gnXFGcvSqJeJyOmWR/c8wzG8nz68kqASvYMlhqaRXzFrG6CpLLGwcZUKYE/9tVs
JuNQb4mIs96tc0r/rFBZQTTCF4ZSINC6jXowG7TuRTHv8NGxlXI2WrnqZM7RKbsg
3MCtkaRS9pXcxT4Y9asKfkirRn/MQG6tuu+XlgcOmI2eIqCz28UkOaTi6LiIKqG7
2IPepU+fzgDD9JMCjMOGDBGtqSLVP9RzXC3TM8yjtcvxC66u8B/A9O4MC5Tqh3FB
BSEU26OrgUzVfriCqlMWud3w4n7IIyCEiPISFEyppv0DYszp9DGlHx4F8JUPd+b7
VEvX6Ax1VfL7a+HkLQwSWZET9WDxw27r7vSM2kgEwdoBGuLj5f4fgR0OD9Y7u/30
V9n8WhYI5teG5qahZ8UweW96j5tvW84IbyNCWibxJF4Jvud5nb0oNxadQwbvGdqv
4BCAI3G0Jbbbf5SnQsdKaJk4Zw1qWODC/+g1a+PnKe2GJsrA9QSGNiUC2lfJMpmJ
2yIRqZFYNc78QLU80vSK/+Mq1awnZbJRhID7XYWlsrPFAJ5xgBRYMFDPB5dCQed2
WpV0+oAJJB+tCG+bmeVToCukdLUwlcIw3mOt1mecp8TW6LVUwFqs/WzAvqXLeg6L
wh+x2d1JXwISOnGywbqM
=hAA7
-----END PGP SIGNATURE-----

--IFfceqaC7J5noe9k1faN4BRhNbIsM077v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
