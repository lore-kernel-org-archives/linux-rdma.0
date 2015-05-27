From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Wed, 27 May 2015 09:13:29 -0400
Message-ID: <1432732409.28905.181.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	 <1431530845.2377.30.camel@redhat.com> <5554B7E8.4020902@mellanox.com>
	 <1431615776.3276.14.camel@redhat.com>
	 <CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	 <555ABD9D.3080303@mellanox.com> <1432038160.3114.16.camel@redhat.com>
	 <CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q@mail.gmail.com>
	 <1432064993.3114.80.camel@redhat.com> <1432069455.3476.12.camel@dworkin>
	 <CAJ3xEMjk5JyY14ySXQsLRAMewxtqfJBDint6K=wGwnp6SOf9Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-J1zXMclh5Ia0urP2UIQN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjk5JyY14ySXQsLRAMewxtqfJBDint6K=wGwnp6SOf9Pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-J1zXMclh5Ia0urP2UIQN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-27 at 12:50 +0300, Or Gerlitz wrote:
> Doug,
>=20
> Do you have everything in place such that what you stage for upstream
> is subject to linux-next auto merge tests and such?
>=20
> Or.

No, I have 0day in place, but not linux-next to my knowledge (unless
Stephen already set it up, but I haven't asked him to yet).

Stephen, can you set it up so that the linux-next tag from
git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git is added
to the linux-next testing please?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-J1zXMclh5Ia0urP2UIQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZcL5AAoJELgmozMOVy/dA3YQAKnoymkz5GxXKZVA1xTdXsgr
SXB3qXvRvoE5HWO6IeOqnPGh75yqGqcIL/eZMBbAOmhNsowaP/CwZz0Nlg3QlyD0
0Ng2ki5N8dQtqRIvE/JWRbCBOOjUw38YqWKvHC2MLLfpCF2b9FdVsbntRajHzJ1B
+BXHpx9xEZpQlLF951rQaOatnC8emLOb9u4ycOKqCDfvlCVYTA3pDdQ4rN4ZlO7y
NW17nEEpDRS0lhsY2D+btdR9vPZKjKAeRgqBWGKVMTAfh24NTPb4Gi8XivSb3QU4
6ZQVSaUf50ysuRqt5GsTu0Mx6j/EAu+Kmq9CVAqWmIaJ8TShDL6/a2P9mq/hB0TK
nxHHSaakErFn2tyyiF09mhY2eqRvEfjUEaXNSLA766OStGg5Ho7TmOEgndwTwcMK
NVsT2nFztPxc6+xG65BRKtP28drai4338qWrMupl+RCKBN3agKFqeD8uIvkIM0BD
iqocqH6P2VYALeCN0QJV04uE6w5ZXLBv5nLQJJLM+7LHjFK1SlMy/vO6qcIA0rb7
L8LQ73zQrHEzToL9nuVrV4XhOcpzWzWLL6Et7h6nPWdBWuroqmzy3j14R84/E+gQ
qvj61twyhne82hoGPmfGxNEgn1FV+5xHyirMfsnhr65PWx0ru6ZeD2Hy7piZ/otL
PMbZ9ZwqxtjDEsRi4ndW
=vLep
-----END PGP SIGNATURE-----

--=-J1zXMclh5Ia0urP2UIQN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
