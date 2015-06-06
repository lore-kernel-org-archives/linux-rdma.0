From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Sat, 06 Jun 2015 11:45:46 -0400
Message-ID: <1433605546.40123.217.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
	 <1433255724.114391.225.camel@redhat.com>
	 <20150602180844.GD17776@obsidianresearch.com>
	 <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com>
	 <20150603204633.GE7902@obsidianresearch.com>
	 <alpine.DEB.2.11.1506031953500.11879@east.gentwo.org>
	 <20150604042540.GA8837@obsidianresearch.com>
	 <alpine.DEB.2.11.1506060304480.29634@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LPtEGPBNUzAM5Jtii801"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506060304480.29634-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-LPtEGPBNUzAM5Jtii801
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2015-06-06 at 03:16 -0500, Christoph Lameter wrote:
> On Wed, 3 Jun 2015, Jason Gunthorpe wrote:
>=20
> > On Wed, Jun 03, 2015 at 07:55:58PM -0500, Christoph Lameter wrote:
> >
> > > I thknk the raw cycles and the rought oscillator speed are fine.
> >
> > Time keeping is designed to adjust for 100's of ppm drift between
> > clocks.
>=20
> What time keeping? Ntp? pptp is supposed to be accurate to 10s of ns and
> we would need an accuracy in that range.
>=20
> > A communications clock source will be spec'd to be below 200ppm in
> > accuracy. IB clocks are below 100 ppm, and PCI-E is 300ppm (approx, I
> > didn't check, order of magnitue is close)
>=20
> Well that is not usable. ns are a billionth of a second which is the unit
> of measurement of these activities here. A send action can be around 600-=
1000ns.
> If we are off by 200ppm then that is 200 microseconds meaning 200000 ns.
> And its our experience that these clocks can be off by milliseconds in
> practice.

The ppm rating is based upon the speed of the clock, not time.  It's how
many cycles of variance you are allowed from the target speed given in
cycles / millions of cycles of the target clock frequency.  If you have
a 312.5MHz clock, and your accuracy is specified as 100ppm, then the
total clock variability is 312.5 * 100 =3D 31250 cycles (I suspect that
this is an absolute variance, and so the tolerance would be +-1/2 of the
total amount, but I don't know that for certain).

> > That translates into 0.0625 Hz. for a 312.5 MHz ethernet reference cloc=
k

I don't know how this number is derived, but 0.0625Hz sounds like an odd
variance.

> Ok that is around 3ns per cycle? And you think the accuracy is therefore
> in femtoseconds? I have never seen something that accurate. Wish somethin=
g
> like that would exist. Maybe in some labs that provide the source of
> global timekeeping?
>=20
> > Compared to 5,000,000 Hz in error from rounding.
>=20
> Huh?

He's pointing out that the design as specified passes the clock
frequency to the user space library in terms of integer MHz.  The
standard Ethernet clock frequency is 312.5MHz.  That .5MHz, or
500,000Hz, must be rounded off as it is passed from the kernel to the
user space library.  And that 500,000 cycle per second error in the
stated speed of the clock is *way* larger than the +- error variance in
the clocks you are using.  If you are having problems keeping your time
numbers synchronized, then this is likely a bigger problem than the
variance of the clocks.

> > So no, I disagree that rough is fine for anything.
>=20
> I am sorry but the practical issues that we are dealing with in
> timekeeping today shows just the opposite. For a true comparison of clock=
s
> with nanosecond accuracy you would need time corrected values and that is
> a challenge due to the variances of the clocks that we see.

Jason's point, and one that isn't addressed yet, is that this might not
be variance in the clocks and instead might be a design flaw in the API
you are using and the way the clock speeds are passed to user space.
Changing from int MHz to int KHz might solve your problem.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-LPtEGPBNUzAM5Jtii801
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVcxWqAAoJELgmozMOVy/dylgP/0knDcM/6oIoXynAAxoesWLK
s9noKJlOhZT9IT0rFBXl4EdFZiry65f319BGmazT/CvG+Q+xtrvzPLqAy4uCAZwX
4l164PkoBLDhsIGTsQfXyQeC3ayKsMS0qWlUGo8LsR18XUstZbhKEeiaXCs+NH9U
9Betp9YshUpC9YoeCtzH2LBo58k+qCl4B2w7zb0r5woc5B5/+iT8kWBVMIMrZNeV
5twx4nPcCzH4XvHHUy6Px8FtM/inDMtd5IRsoCMUO2WryT2hwIBMAfXNyChNauDh
T5wZ+XrarNEjuI1l4eztiiNHwoaBa50xYNOL7vr8g3BlYwuoOGCQyWmmgNG8uC3r
ZQS7NskSm6dTeMvzgkJbHmFRG0uUPNAO2XYwIDPmkL/gD3gbuV57gsOs/wFSPKPz
nCdQ8P+SXmJ6/pBdrSYLfOcPiy/gnA+M14bCPRLMgoGfsPBEB21mwVgdD9q3afDu
BQkPA36aqwQ5rGH5iWg/SfAfpiuFwSKjEv5I6BmY2EvwV0arU2L2SIVoRC/rQNEq
KUbNMnwXVunDP1VmBkyGWgHQB+3RKZ+H8VNtoXL8NfE/c3ZYYnwJOSFEEQr/RUpG
cxRp1xbkCvSm2AjxJszdkns7sjM1JDrHNvHxlwhpNtfT6Y1npj1U2vP0MmOgQShn
8tsQdXmI51yV4E7SdzIK
=qRPL
-----END PGP SIGNATURE-----

--=-LPtEGPBNUzAM5Jtii801--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
