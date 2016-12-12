From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/rxe: Use DEFINE_SPINLOCK() for spinlock
Date: Mon, 12 Dec 2016 16:36:13 -0500
Message-ID: <7fdbbaaa-5b82-b22a-47ec-43b1b763cc0a@redhat.com>
References: <1477757973-32052-1-git-send-email-weiyj.lk@gmail.com>
 <CAG9sBKPfW9uBAKN8r4tRHyzP9NSoEnhpwSwH9QBiVbq2k+a6gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0lBgE8edPvdfV6AVDbJ0eEvsGmCJMtgEL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPfW9uBAKN8r4tRHyzP9NSoEnhpwSwH9QBiVbq2k+a6gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0lBgE8edPvdfV6AVDbJ0eEvsGmCJMtgEL
Content-Type: multipart/mixed; boundary="QG8eR1t0deku0HaPQCnP0pRIkFjD4g2ie";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <7fdbbaaa-5b82-b22a-47ec-43b1b763cc0a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/rxe: Use DEFINE_SPINLOCK() for spinlock
References: <1477757973-32052-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <CAG9sBKPfW9uBAKN8r4tRHyzP9NSoEnhpwSwH9QBiVbq2k+a6gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAG9sBKPfW9uBAKN8r4tRHyzP9NSoEnhpwSwH9QBiVbq2k+a6gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--QG8eR1t0deku0HaPQCnP0pRIkFjD4g2ie
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/6/2016 5:05 AM, Moni Shoua wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> spinlock can be initialized automatically with DEFINE_SPINLOCK()
> rather than explicitly calling spin_lock_init().
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--QG8eR1t0deku0HaPQCnP0pRIkFjD4g2ie--

--0lBgE8edPvdfV6AVDbJ0eEvsGmCJMtgEL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTxhNAAoJELgmozMOVy/dWKcP/0IbgknPvdWbhoicWhfSjFTd
T6jsrNOBCEvzuIWab1D8nH6yl0Kr2e51/kdj3hhpvInwh55m0gib6ScKsvTsXcqV
IA01yxBSRwb3jcStl8tn6rE7XFObzcIbPG0ljUQeuEku0js+oaoXnW1q1S1NpbQG
sI+/50IcAw2gGOdIHtYjJqniicPFf26aCj4zcX4z2XuDKfsAi3X77jKpcYJa98uK
GOrk7jg9MnvA1Z5q/4l0IEscX9LbdCkh6L3cMhbE6hA8Tj9hRWjdkJE/HRB7CbNJ
uDRF9CCUpIhSnxGzdBbj91sENyiT68yEOEochLFHfv6aK6Zk8d2S8AJ27z+79o9j
hWB/XGDxF+RIgB5cJQnwJ8wPFDzCNuHZwc12/aWUD/IWiQ+pP598L9UFHme8vrEn
oB4BlzL1PbsUCX53SHp/8hVlY4WCvfMIJjk6vQZ1oS549C5cGHtTPt1SJpMD9SCb
+auibaF0Gm2r9UYoNiFEgih6P2r5DrCTiH5S8tF/Fq4AXnI10lMU0bNKJlC+aWrf
OI40ATsJ1gabjtJ9hESPbtE0t2JJgsGlf9OTYb7TSRk3B6szS2SzmI9xRRBeyeXn
XBjs0T69V9g8L6sUgFHqg6+WR2e35f1KZXCEwyEFhlQMI7Sorvvea0jSuGqT7kol
ilzfCJz9m5Qu6RuxJOaD
=+rL4
-----END PGP SIGNATURE-----

--0lBgE8edPvdfV6AVDbJ0eEvsGmCJMtgEL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
