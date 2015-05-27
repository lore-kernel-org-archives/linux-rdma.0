From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Wed, 27 May 2015 12:12:54 -0400
Message-ID: <1432743174.28905.231.camel@redhat.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDA36D@ORSMSX109.amr.corp.intel.com>
	 <555486CA.8080409@dev.mellanox.co.il>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDA931@ORSMSX109.amr.corp.intel.com>
	 <55586E5D.1030801@dev.mellanox.co.il>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDC9A4@ORSMSX109.amr.corp.intel.com>
	 <HE1PR05MB1418D0CE0E031DA35E3DDEBAB1C30@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-VIdf18fUm4ZAKO+HSVOA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418D0CE0E031DA35E3DDEBAB1C30-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-VIdf18fUm4ZAKO+HSVOA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 16:17 +0000, Liran Liss wrote:
> > From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>=20
> > > these remaining resources may be device-specific.
> > > The proposed framework first of all allows a provider to indicate
> > > whether hot-removal is supported (i.e., the presence of the
> > > 'disassociate_ucontext' callback), and if so, allow the provider to
> > > perform the proper cleanup so that the corresponding user-space drive=
r
> > > will continue to function.
> >=20
> > The approach seems strange.  The driver knows that it is being removed.=
  It
> > was informed up front which open contexts were associated with user spa=
ce
> > processes.  But the driver calls up to indicate that it is being remove=
d, so that
> > the upper layer can call back down to tell the driver to process the re=
moval.
> >=20
> > I wasn't asking what this series did.  I was asking why the uverbs driv=
er just
> > can't delete the underlying resources.  That's the natural thing to exp=
ect.
>=20
> I suppose that the main issue would be handling existing user memory mapp=
ings,
> which cannot be just invalidated -- the user-space driver may not be awar=
e of the
> device removal and may access this memory concurrently, and we don't want=
 it
> to crash.

In this case, you are mapping it out of the device BAR space and into a
random kernel page, yes?  So, if the driver doesn't catch the
DRIVER_FATAL event and process that to mean "don't bother touching this
RDMA device any more", it's going to write to a mailbox that no longer
responds and have infinite timeouts, yes?  Essentially meaning all
mailbox type operations just go into lala land from here on out, right?

> The meaning of these mappings is device specific: some devices only write=
 them,
> while others read them, expecting some specific format. That's why we nee=
d
> device-specific code for this.
>=20
> While it is true that the device initiates the removal process, the curre=
nt flow is
> to let every ib_client first detach itself before device-specific cleanup=
s. In this regard,
> ib_uverbs is just another client.
> In addition, the "per-open" (fd) state is held in ib_ucontext, which is m=
aintained by
> ib_uverbs. The device driver doesn't hold a duplicate list of open HCA ha=
ndles, so
> it relies on ib_uverbs to iterate the relevant contexts and trigger the d=
evice-specific
> stuff.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-VIdf18fUm4ZAKO+HSVOA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZe0GAAoJELgmozMOVy/d8I4QAIGcVELwfz7GQECF8aYEX13v
YvKpNBml+YHY7lqpVlex5V1Her6oC1mBNagwhpBBCUV/bykJJfEH6P1vXQg7UVVh
fGSQzfsZJXPmwNYUm+mfAFm/JrZi7KNCnI8MPL6av/oP4Akb9Vz16sUJzcfUQ2Tk
y6vHQk1keDkfoHZU9Ynj+lNM5rRxu6iRB90odMwpdDxSWcTFOXWjZIctnlkLP0ol
M+d7NyaXjwyeXZw40RHbCJNKH5wA4KXX1BSVpG6RaeT3tGuYyOQI7xUvhjXWt/j0
ZuL4U6PNUu6TGbXdlzDKS+tmfpRIKjwES2GtkTVxh3GThhnnPfSGhOl9dVoFDCuv
i3yZXRGZvgH+2OjcZIrdZICz3wtKH/YaGbvpd0I89x1QPuYKyeu3OJ437ZJLN+xu
215yAO5h2hK4pQekJUnzgqOuMIfUwuUWh/g5X09CaCcH4F1JOiIHwWw7N1Igz3Q2
eyak/Lc5CmXeFjGgJiJmmYk11YoNglKIn9rN+Zdevcgs039ShlPGn/57ELC3uOl2
OasQZdyQ6Ww1P5RRXo2Yf8QKNVpHvNTVXGvL0UT2UvDdfvn+8zB3VtwcFfwii9va
pGL289Q+dTZwgJnpJ7FMbrS4AbMdPpb+Rk1IXKPQcm5emdUVxrhTNMYKFxV/QIBX
3k6EVZYC3TFCJeJ+JSij
=G5fg
-----END PGP SIGNATURE-----

--=-VIdf18fUm4ZAKO+HSVOA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
