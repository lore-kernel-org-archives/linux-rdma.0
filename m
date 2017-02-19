From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/rxe: use setup_timer to simplify the code
Date: Sun, 19 Feb 2017 08:21:31 -0500
Message-ID: <1487510491.86943.104.camel@redhat.com>
References: <20170207151510.12503-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fSOvca6bP8TzRcNk9GKf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207151510.12503-1-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-fSOvca6bP8TzRcNk9GKf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-07 at 15:15 +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Use setup_timer function instead of initializing timer with the
> function
> and data fields.
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-fSOvca6bP8TzRcNk9GKf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqZvbAAoJELgmozMOVy/d0+UQAIGc48z8HGsia/rv/fv9/vHv
wJPDBxQsJDhLGfaVojkWOygTR84D413+rwAkfgGRg7SdcUrGWQY/FWEz0XJ/phYk
xFr267QVGCbjmHP4XFyQYnSwDMLrxVbAxJ4Jr1xYI5npv3xqtE3r4+EWnaQCaOn6
jx3t88uYEdFBVYVN+nHr1qWvsLh1/pmCAoXlgsI4lsKYise5HlmI8WGkmNE12gge
wvN24sr6HuskqUZfwwiB3w9LE0L+H1e+JbugjU+llvXMDRw+39od94YBvijfnCBm
ZCpBMZLIyoiC7v+ONpQ1I6hSxfH1r6HoW5NMS26uda4OFBsco5Vpr7Ble9cXkbI/
58eI+Z2jfkfDYtuHKhAaOxk1tFbuW1HHftJJ5P1SOsRcwrpglQHWO5aEPdLDYuxg
l2PRIwhfE2g7uUV5ijqx9Fx7GR9tVhSAaoN1iq9pmCF1QwxKGjA1dVSH7z7RBHph
q+GQZdPZdPJOp+j9NCJaq9aVbxJnK2kCyeJjoNi8mi1XHWx9shgXL19WirpsS7+W
BEPHIDkgBlemWlIDM5tq5XFwNGHe9BwgLMUPP3b+olzItPXoz9hBuX4KsbsdFIl/
PIf+mK+y2ymptFaCB2cEOim1DQ9HQNT64zbVbD8z1uSHAJlXKL4E69gnjGRtoe0G
YNfYlGhulfHBHpRtPw17
=atXR
-----END PGP SIGNATURE-----

--=-fSOvca6bP8TzRcNk9GKf--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
