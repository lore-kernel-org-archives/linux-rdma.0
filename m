From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/3] IB/core: Add optional AV attribute for Raw
 Packet QP in INIT to RTR
Date: Tue, 5 Jul 2016 09:17:02 +0300
Message-ID: <20160705061702.GA15009@leon.nu>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
 <1467549727-23479-2-git-send-email-leon@kernel.org>
 <CAJ3xEMiaD99d96RKGwD3OpgEOn0RXjXoaRuFWT6PJdXQSOo5rQ@mail.gmail.com>
 <20160704153337.GB23122@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160704153337.GB23122-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 09:33:37AM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 04, 2016 at 12:51:00AM +0300, Or Gerlitz wrote:
> > On Sun, Jul 3, 2016 at 3:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > In order to configure QoS for Raw Packet QP, the user passes the SL
> > > in the AV attribute when modifying the QP from INIT to RTR state.
> > >
> > > This SL is used later on to set the Ethernet Priority of the QP.
> > >
> > > Until today, we couldn't pass the AV attribute for Raw Packet QP
> > > because it was blocked in the QP state transition matrix. This
> > > patch adds the AV as optional in INIT to RTR.
> > >
> > > Fixes: 8a51866f0810 ('IB: Add ib_modify_qp_is_ok() library function')
> >=20
> > This commit is 10y old and was done way before RAW Packet QP was added
> > to the kernel, please fix your Fixes: line...
>=20
> It isn't a fixes if you are adding a new feature.

You are right, I'll resubmit.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXe1DeAAoJEORje4g2clinDDAP/i8jlZ3qmss+3QuQV83dlV+y
DNB/f9HEC5aFGDe1ZULLklm4UscNF3LA4UNr8CcUAWbhc0DS/l616aGm3xLZtuM2
CCIqf0dot0+/eaEwA7pViXhRGv41YcjQqmgMenTf3P81l4uErcuCBjyqAmVJFqS4
k2JIfRbKundqwSf6c4L0xxGl16tUzUJxHj9BwpnXxQpczveUXBNpW5PyxmMXCRrG
IC+rhKU10TypPjMeuLVcuiXMgPkWUrD0GuWAEeDuVBXo6p4s6/VSMo5qNRFOLUHK
545C0s0ugZXLv3AYXJxO578Nj5hmd41q4RQK7W03VMHYxoXDQ0VIPuw0PyaYdw9I
w5FT7yZJTtG1bJcOpfeT1NwiOaN+zESRN5wxBhwvg/rrIH8/N6tXQH3ugV+KRtFN
o5sUNaU0onEVL/vNWFwYnyKSg7JutDiemCTM3W0Fwjjm87BtC2Zs9YMlbwcjPQiv
Q5KomGUy3iiT1PNRwVZUbVClI/+TK3/SzEECjDzn74jd+UjRilOVtvAG9+Osims3
2LcWr4gKjZKvtN30gyuYMP5vc3cC6MwaHquOPy9WSB/beCQjWWLrNVeyBW8tBBfl
Kok0g0F7xCzOqQAQZMbnZcrBEI8D4QbuaMWzgq2tPvX+G+eoMkXinkxeiAow7/gO
d8Q5KN/FqXB2E3BtEddX
=d7Q6
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
