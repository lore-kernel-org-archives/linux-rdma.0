From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 09:09:40 +0300
Message-ID: <20160416060940.GB6349@leon.nu>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
 <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
 <20160415212328.GF10689@leon.nu>
 <20160415232800.GA32513@rhel>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160415232800.GA32513@rhel>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 07:28:01PM -0400, Ira Weiny wrote:
> On Sat, Apr 16, 2016 at 12:23:28AM +0300, Leon Romanovsky wrote:
> Do you have a technical reason that this patch series does not fix the
> write/writev issue brought up by Al?

Sure, I truly believe that we can do common API in a months time-frame
and I want to be focused on one transition path only (write/read -> new
API) and not on two parallel paths (ioctl -> new API and write/read ->
new API) plus support of all these intermediate steps.

The original request came after this driver was moved from staging to
RDMA stack, since the driver is still in staging, there is no need to
hurry up now.

>=20
> Ira
>=20

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEdckAAoJEORje4g2clinee0QAI8YSENewv7TI+sMDd1C6XOw
1OfKjCvjudcovoMljof8gVjAxI7rI9oQqfPTkyj3w+gYMIqWTtT0ACD9DPYYQvf6
pxAxWsEv0eHfYTiLn/xa5DlDB+klf+/VQ4EMEIcVY9C0np5RX2PIOK23L0THTVd5
E4XCBg4kOZaclFznEi8lLCXYCi7wj+e1q1jWrsCsupC8H5L3/HtZe4NN+ExTke+q
0xqhHpO1yVyYSIj0tyjj3yFmjzc1CsVzRlZmEdiVHPXj+ySW3GfjnqBbPXYrbeOE
cm/Xj0xkZOC2k7H27JmQgnd0bJ6ckMBSpRJs7slDUdJO/dwAokvoTowj78u0IflU
pJvUDyKO5mVpDjE03S/jYboP+HPHhDdByf8ylJIqoi2QyJ2UFZfMPvkkjfeUILqa
RxpDRK8HVq6fxmHUXr+AtJkczPcGPr181plpO6L62eVnlXI5aASyLCY1W6PRwzPF
xu7W9H7BZEbjzLiG3KZLaIhDUsnJJniAQBJvbCN3QWI2XqEgmv12677Pshiw/G2V
N4vJgpbMpFUEoUgagRdzr44Kt4cy9Pw990k/Pv9P1ZENk5PpB/Z+utmhgxA0Mhwf
lGFPK/Z3T0mv+6zb7g1ZIsddn5OQo/YNGxxV+U/Rcad105//+A/WKUnTAQaF/68C
+8mVExyYfrDdZq02SvHM
=1iM8
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
