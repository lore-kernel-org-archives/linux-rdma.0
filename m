From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/hfi1: fix a locking bug
Date: Fri, 18 Sep 2015 11:51:29 -0400
Message-ID: <55FC3301.80706@redhat.com>
References: <20150916062251.GD21542@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aeRvGbh96R7uUprqpnR0rkRPLmqQweMbu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150916062251.GD21542@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aeRvGbh96R7uUprqpnR0rkRPLmqQweMbu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 02:22 AM, Dan Carpenter wrote:
> mutex_trylock() returns zero on failure, not EBUSY.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--aeRvGbh96R7uUprqpnR0rkRPLmqQweMbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV/DMBAAoJELgmozMOVy/dEp8P+wTDLZA46tStoUN4C1Bg1QA/
uU0Nc9ncDUpkwWt5NiCzHBgjciePqIYgbqDyqprLaB1tH2Rz3e1hc4W8IY6JmSbC
ecbVyfsEW9T/KKTb0FU5ykA5dW4EdUmeGpiDnCIaxk7P7cMuso1nNKZPOAevqZbQ
F+Ow/95OxjwnY/FNkf00+db+GFA0qMP97dCzL3uZV6ItbEOjg3UQy5uGyNWj8Uz4
Zvk9ybVmkMlTOQf1IoW0nbODmyn1URQ/ahG8ZqbCh18thh8lzS3MEjutUVidysQ2
QwHXPwsXM9mSnds0NN8FWIscbGQ4DB6XSKXdB+JuH+3uAz/EFSbcZdemKOM2hVcE
t5WXy8YMovkWxVvbH/g1i2Ex0eFjkTFxTiGJENgGK8mRnVDKrF+kUxt6X20f+e9N
j8DeVuVL2fRp/XCPewlq1eT0CLIIqZVOM8bIpQOujY6g295M1B/rn7w1cUE5ZTun
MzyVFU8szLt9ncM70uXujmqK8CVIEnzFDlaJyGY+XyW0nUPtKocm5Grgg7NTikv3
NSv+YIVbgxIEOy1RaC2u4F/qGfjwPpzaX7+nmoW8nt16/J0J1o0i39ccKOaluqQS
3vl59KIINfELNm7dpP/QzNLQIYKWHigJHh59p3tOL+abo2DUfgkSxtLBVeDSX3MQ
eVeUls/8gcdl+HsnZavu
=y8Ab
-----END PGP SIGNATURE-----

--aeRvGbh96R7uUprqpnR0rkRPLmqQweMbu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
