From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 12:49:30 -0400
Message-ID: <1432918170.114391.104.camel@redhat.com>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
	 <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com>
	 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
	 <20150528162416.GA6515@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org>
	 <20150528175043.GA10966@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org>
	 <20150528195034.GA11182@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
	 <20150528204749.GA12780@obsidianresearch.com>
	 <alpine.DEB.2.11.1505290845040.8178@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-3myyNVYJ/M09gYc2x/rI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1505290845040.8178-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-3myyNVYJ/M09gYc2x/rI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 08:46 -0500, Christoph Lameter wrote:
> On Thu, 28 May 2015, Jason Gunthorpe wrote:
>=20
> > My point was exposing raw wrapping counters is a horrible UAPI.
>=20
> Well this is a kernel bypass API and a lot of raw hardware issues will
> have to be handled since you do go directly to the device.

No, that's not entirely true, and it *certainly* is not the correct way
to think about verbs extensions.  Is it kernel bypass?  Yes.  Does it go
direct to the hardware?  Not as far as the user application is
concerned.  The direct hardware access is abstracted away in the verbs
library.  Because the verbs library is a hardware abstraction layer, any
extensions to it need to be well thought out.  And by that I mean if it
is of general use, then it should be added in a general, abstract way
that any hardware can implement.  If it is specific to just one vendor's
hardware, then it can be added in a means that is specific to that
vendor's hardware.

Now, as a general rule, I would call timestamps general.  They should be
added in a fashion that anyone can implement.  They should also be well
defined.  Sean's questions raise a very valid point.  Exactly what is
being timestamped, and do we care about different timestamp options?  Is
it completion of message, start of message, transfer from HCA to main
system memory completion, etc.  The 00/10 header to this patch series
was probably answering Sean's question, but just based on the name of
the TIMESTAMP flag to the CQ creation attr struct it isn't clear that
this is the case.

> > > through a complete cycle. But that is the nature of these counters. A=
nd
> > > thats what you see when you look into the kernel timer subsystem for
> > > example.
> >
> > Very little in the kernel is exposed to that wrapping, the timer
> > subsystem takes care of it. Certainly, userspace never sees it.
>=20
> Right but then we are not at the comfortable sockets API here but at the
> bare metal level.

That's not entirely true.  We still hold to our abstrations, they are
just intentionally kept very thin and high performing.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-3myyNVYJ/M09gYc2x/rI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaJiaAAoJELgmozMOVy/dfecQAJ1JmZISP1TWXx9swEQu22Ou
ll0sIkaAmb5j++CIokrl1XCSqX8wOWtwsW4l35ekE8q72eJwGKjkssOJfueVSb2a
6slVtvguU1bWyisJocBWdlXpxnUNsQIMwbmButP2wMPNMZLhh6XWTqKxLAqvbnOR
4NX2ZGVX2IjMfUPAtIq1D2MnbpWbkSMi4nGefSD78O1b2XLcG1E7toVp2kn0lLWh
RW3isHa/VM87wbKhRg0nKTxA2o7B5DRj5VkME4VoHXHA/zv7qGzeo1Kn1oEY3yBq
AoyM0hCT47iYXs4x36J1Dr6zoryBJ+LopyFIH0XatMC2pDlwO24MXRU5pR108Uif
gV7el/13862tkYyT3C636/dgPEwIe8Q+irEw+6ZtJZ/H1XmqsjtNS5umCv+nsyEx
FucV0lvKw2gz4EHMYc69ReXsbzhv9hA84nHeTRQ/sTMJu0cHBIgIfpD4PWfbzB6q
544p6SLz7GOdm2UWjm4/FrUAtluGCHg4tbISZg9eFfCxvS8y34dufwsPgQOqbJhx
3+AAP/t0fhYTyhMq1sRSs7nHG36rtqknu8naB/FKFGNvWPT+zQf01W1XThRifL/U
jMSwB/jtkECEQZ2EjTl46mKGym2libDK+bF7u17kBCRcGRu9bWyAtvWOTaxvAQcc
0/SHJvfQe4SzTbrHVl8n
=R+k9
-----END PGP SIGNATURE-----

--=-3myyNVYJ/M09gYc2x/rI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
