From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 13:14:48 -0400
Message-ID: <1432919688.114391.116.camel@redhat.com>
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
	 <1432918170.114391.104.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE2126@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-WUd2O41BTp/a3i67XLRW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE2126-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-WUd2O41BTp/a3i67XLRW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 17:09 +0000, Hefty, Sean wrote:
> > Now, as a general rule, I would call timestamps general.  They should b=
e
> > added in a fashion that anyone can implement.  They should also be well
> > defined.  Sean's questions raise a very valid point.  Exactly what is
> > being timestamped, and do we care about different timestamp options?  I=
s
> > it completion of message, start of message, transfer from HCA to main
> > system memory completion, etc.  The 00/10 header to this patch series
> > was probably answering Sean's question, but just based on the name of
> > the TIMESTAMP flag to the CQ creation attr struct it isn't clear that
> > this is the case.
>=20
> I didn't see the information that I was looking for in the patch header t=
o this series.  As Jason pointed out, the use case is lacking.
>=20
> IMO, it could make just as much sense to associate/enable time stamping w=
ith the QP as with the CQ, or even make it configurable per operation or op=
eration type.
>=20
> If Christoph has a clear use case and wants to go to the 'bare metal', th=
en a vendor specific option seems ideal.  At least until there are other im=
plementations or the driving use case is clearer.

The use case is clear IMO.  It's for financial trading software.  I
don't think they really care about details like whether it's the start
or end packet, or completion, or whatever.  They need a tie breaker
between when they have two different buy or sell orders on the same lot
of stock.  Any deterministic timing/ordering method will do as long as
they consistently apply it I think.  And the faster and lower overhead
the process, the better.  He doesn't really want a timestamp, he merely
wants a sequence ordering.  But a timestamp is what they are using to
get him what he needs.

Is that a fair guess Christoph?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-WUd2O41BTp/a3i67XLRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaJ6IAAoJELgmozMOVy/dYPgQAJl+NRhy/PpaHP2iqrSrowNo
w67kUqV51pLwEMF477AU8BA7UBP/RchCPim/dQSpyR2JubNveX5QtWnH1kLKtB1O
G/8PDpx+kNOOEFUzi+zox7XqzA2eYdXVXQzQd7wVbnrGESgHrLKcOjJQv5UMaRFT
nJwDWlFbSlX+3Rl8Oe3XpEp69/EGVlAQ6uNQl12jzPHnowJqQC4cMca9C0eKYjs4
W2PIYggBTdLfpa3HERdH9Vix0FQd/jpe+kpZ6d3gB2l8F8fEHcW0n1gXPY5eU5QD
C2XITmSBixZwzQRrr4jGTK7GKF+efTE1mkpeepJ74dqNbMcykNxo3cirNg4IfZt+
M7XT+eP0C53TWngb8ixD1E/PHWdCP2M3BMJiUqVY1IMJot16SB+bwII83HZOIHFF
aGZwJSueQP3OVny7PMJrSVgDFIAk8JNPVzVjzAh65TZLoIAzqn72Uik536I2gofC
TzOtk58IWEohCOoWYTU84lEBoNlEnLJPHa9E1CphOe7JGxg/5dUnA3CjDnJLw8Xw
DNgrAKvezf/9BxzuwfJdlIsrYXPs8z2cwStyDQ9SE0V2hZBZOkrtRgUBIHUTix0m
s+1ehlB9dVhLWJIntMxAXTwOoXb3NnwRRxm/peckfiMA5yGkN3dHHsPOAd/PKCQH
1IIppkdP22Rr0I48fe8O
=Zneo
-----END PGP SIGNATURE-----

--=-WUd2O41BTp/a3i67XLRW--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
