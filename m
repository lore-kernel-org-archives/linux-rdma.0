From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2 v2] IB/rxe: Fix mem_check_range integer overflow
Date: Wed, 08 Feb 2017 12:40:54 -0500
Message-ID: <1486575654.86943.16.camel@redhat.com>
References: <20170207134431.GK11103@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-5IIMw7ujGSJ4oAZqtwqZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207134431.GK11103@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-5IIMw7ujGSJ4oAZqtwqZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-07 at 16:45 +0300, Dan Carpenter wrote:
> From: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Update the range check to avoid integer-overflow in edge case.
> Resolves CVE 2016-8636.
>=20
> Signed-off-by: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2: I completely misread Eyal's first patch.
>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c
> b/drivers/infiniband/sw/rxe/rxe_mr.c
> index 8cf38b253c37..37eea7441ca4 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -59,9 +59,11 @@ int mem_check_range(struct rxe_mem *mem, u64 iova,
> size_t length)
> =C2=A0
> =C2=A0	case RXE_MEM_TYPE_MR:
> =C2=A0	case RXE_MEM_TYPE_FMR:
> -		return ((iova < mem->iova) ||
> -			((iova + length) > (mem->iova + mem-
> >length))) ?
> -			-EFAULT : 0;
> +		if (iova < mem->iova ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0length > mem->length ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0iova > mem->iova + mem->length - length)
> +			return -EFAULT;
> +		return 0;
> =C2=A0
> =C2=A0	default:
> =C2=A0		return -EFAULT;

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-5IIMw7ujGSJ4oAZqtwqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYm1gmAAoJELgmozMOVy/dMgoQALDH8kka8cUIbOcM6NRwqTLg
3CLdPS+zMIgB8/sFzboIwIY+Lq7QpiB4K8nlBvKuEmWIGGilbKUQANGKJT30tUF6
+K4LzMJZJwSNeNC9sbki90xiq283pCXweYqfA0yyN3o7n/4Eu8yRnlzUxu6vewHR
xxzpeDIPsvDFANCDPPLc6w1yS8VOy51b6phN1i6oKaj2Jq1RSdxt4xYQcEJ+8p/i
TF93/i1H5vJP/WgAn5kVAs0QQITW0BjDZBZC6Ye1/Ub7avqV+e534iwUqn9/nRzd
Y35RFjw4aqZnTYs9JVnSSaDFr0+0mTwT33gkQ+oc4gFSMwzsGEiCeQNblDI72dto
Kmbl2ZwSzJJJhoTE81w2QCllP1UMi69hAFKrQGs+pliklUAaNqXJQufFSb21PVfd
eSxrxJt8fU/eQ9LMmtnyMfPROEaYegHowAbufkscuA8UDJuurt6qQC1pZnPzF+Ja
mUgwXRCgmX9g/ObN8YFrAbKudQegeygJWkeEkt4uG7qi6i2aUSP3RcDRDY0R/9f2
y7pF4XWjy+ac3Y9xbgyiUAPp8XJWKtSuldJ3z+IJchIiey7wcPL71PujfCINeK3h
sTkMz2YMjuF4x4NrWszfnWg1DVRw70f8BWc/o71hOh0bQgy/hlAAzAMsmx/5K64U
5FTq5EmvEDu20+Nupwj6
=0Nt5
-----END PGP SIGNATURE-----

--=-5IIMw7ujGSJ4oAZqtwqZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
