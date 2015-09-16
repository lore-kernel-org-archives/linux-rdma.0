From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Wed, 16 Sep 2015 11:14:03 -0400
Message-ID: <55F9873B.2080407@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com>
 <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com> <20150915191159.GB24173@obsidianresearch.com>
 <alpine.DEB.2.11.1509151852530.15731@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9G6NoNwBK0COiBmBwQFfgxOqejcvkQOgT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1509151852530.15731-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9G6NoNwBK0COiBmBwQFfgxOqejcvkQOgT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/15/2015 07:53 PM, Christoph Lameter wrote:
> On Tue, 15 Sep 2015, Jason Gunthorpe wrote:
>=20
>> The mcast list in the core is soley for listing subscriptions for
>> inbound - ie receive. Abusing it for send-side is probably the wrong
>> direction overall.
>=20
> Ok then a simple approach would be to port timeout logic from
> OFED-1.5.X.

It's the simple fix, but not the right fix.  I would prefer to find the
right fix for upstream.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9G6NoNwBK0COiBmBwQFfgxOqejcvkQOgT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+Yc7AAoJELgmozMOVy/d6ekQAIScOFBJHrhWUiVXtENCfozA
9EEL3OoEKoRyIy63mbZi60J0an2EXTx5/L614FbrvHsdfif6O3XKnJRshbiiDhDT
NOzhWBz+bHrtMWJ7sg72rTmsubOkLwXZssqGrbLSf/2KxRka4dUBRkT67d2I4kHn
u6WXigWXyBlfNYf0PZEYlTqiuFk1WVF7suk6H7emwkWakQcU/snK06KqUd4mMuQq
Bfl9oHBjg5LDCDHjrE0/eAiYlJGvg/7MCnVmaqetIENDnYcGZsJdvJuwIABNi4lW
GMZcfbyc+ORD/sB5hRFfh6MSyd0Zq+kFXpfECeMPuwd1rD9X49XBKWF0+8+kVFFd
Z5p05nrX3TUZ+fnuD4S/G+vZS786J5Kvkt8QLaP5ZkkGYkYA/L3nA3EM0wWFeiGj
mNUFw3t2ssPupdYPnVmxgO5rB9p7Y2lQfEBAoGLh5jXuHY/fgQtRsOa28hKViCuD
bGsDyiAAyb8R6lsxR/br1hii4yCXnunZmC0xmW5GdTyYAJfx0cx+y7o0kPqSect9
s2q2xDnwMev7tFAcYdy4GuG7FZBmqQbcZt784KUsPudELUZKlvWPGQ/8kUlJ2rD0
++c9hdK/+U373K6G9XUMuwwMmENXq9IOUxs9wQql3ntCO/Fchx9RJaf8624cMR7B
kcbjtcy+AESVzUcUkyFG
=YEIH
-----END PGP SIGNATURE-----

--9G6NoNwBK0COiBmBwQFfgxOqejcvkQOgT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
