From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 18/22] IB/ipoib: cleanup a couple debug messages
Date: Fri, 13 Feb 2015 12:21:58 -0500
Message-ID: <1423848118.3387.11.camel@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
	 <7aeffef3862526da5a472c15f94564897a4d7537.1423703861.git.dledford@redhat.com>
	 <CAJ3xEMi2yvaL6QGPFXDcJavnnw4Lxk64bdkZnm--FE8NiKQmbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-t804Q1U5cgAWPuwWChe4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi2yvaL6QGPFXDcJavnnw4Lxk64bdkZnm--FE8NiKQmbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-t804Q1U5cgAWPuwWChe4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-02-13 at 18:40 +0200, Or Gerlitz wrote:
> On Thu, Feb 12, 2015 at 3:43 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > The one I removed in particular can prevent progress in the driver from
> > happening because it isn't rate limited.
>=20
> So isn't the right thing to do would be to rate-limit that?! note you
> need not solve the whole world (ipoib...)
> problems for 3.20-rc1, this can be 3.20-rc fix

I'll let you know when I get to that patch.  I'm still squashing.

>=20
> In my testing, I have seen the
> > flood of messages from that debug message delay multicast joins for in
> > excess of 30 seconds.
> >
> > The added debug message was just so I would know when we were leaving a
> > multicast group that we didn't fully join.
>=20
> so squash them to downstream patches of the series?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-t804Q1U5cgAWPuwWChe4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU3jK2AAoJELgmozMOVy/d3zMQAKR000+5ZLmHZjWXaGZTKKpE
PiIvYGurJKjlJ2rlsTw/kEPOHTR0AY1EhCN+eL4RLrBKC1m6oaj2peIBMCSWfrxH
8XpUoxcezTMOMMTjOhv3bZ7gxyBrGeYof7+aKri+1QLt/RruMMV+I8oDblne5i2L
F9nf+C/yEjBsaLPHS/Pcx2Y6rwwd6UuPrhPng+zIcEODRZOjWaB+DamL2wu99fqR
OnDuK07c2pKxV7GSX0ytEqMszXMohFQrSUHdSGMEENnD2JLkrz2XC2061tyk8Uzw
CFZBGEfWuY4FK4AG9vldB0vpdMfCxvEG2Yv0s165H6bwj4kUJ3vpM3nDVk1pE0h4
axIYuqQBUI1/NJgcpBQo35KHT9QSAh9ZEnrR5eMCJKAAyoNbiDj0QF22h4mgjyuF
HmyqA+HHUjSqwLojO7MgR/qjsUGTiZMbO/joy6wCJHPUSFpChEW7XMTIsVwRgYNi
Z2kOMay1pxmhqMTO2IdxNLqLYrHKUaQ1UCTfGxYc6MFuIhAvnPgmv4n5hReLtd5U
XNHC7AgUTUtgH2RucYT2bAa4BWylqt/evfNiuO3L0WUYe67s+EQZjd7Od+6p1gOC
ajTPHmRKpGVXkEckUTM+1z6dIUkWhSvT4g+vgabpQSF7WLvgcS9bzJbtIGPw2YTx
dnv+lNlU4XDDsvurEbP2
=mnne
-----END PGP SIGNATURE-----

--=-t804Q1U5cgAWPuwWChe4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
