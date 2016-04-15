From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 00:03:33 +0300
Message-ID: <20160415210333.GD10689@leon.nu>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
 <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDAAE43@ORSMSX115.amr.corp.intel.com>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7DDAAE43@ORSMSX115.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Woodruff, Robert J" <robert.j.woodruff@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Weiny, Ira" <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 05:44:48PM +0000, Woodruff, Robert J wrote:
> > I fear it's kfabrics, which is an entirely crackpot idea and a total no=
n-starter, but for some reason Intel and their buddies keep wasting time on=
 it.
>=20
> What is being discussed her is not kfabrics. That is a totally different =
out of kernel pathfinding project at this point.
> What is being discussed here is how to best solve the write/writev issue =
with the PSM interface. The code submitted was to move
> to IOCTL instead, but people like Jason have suggested routing the IOCTLs=
 through the verbs layer instead.

The discussion here is much broader than conversion of PSM interface.

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEVclAAoJEORje4g2clinYd4QAJKt0pD6Y2+U5/V40LsFyDKn
ulSUny79i6BdzIzpSzWlBbIvFUMW3xtZKreJfHtMkTf+dS2PJJryMwm3Vvs2ew3/
3HUseywYO1ShXvR2HnKecWzbzpeGlPQ9M8yKR4j2jevWxlxrBSR76M8HAVM8udsa
xzO6x9+V8XzA8HBviHBKsuT+in7JrB+JN72yHWe3lz2b9I4KH6oaJcPQba6Z/iWG
fvHETMYhye6Gn/QstPR4lF1RNhdRu3hcNxnUmebWP1+QWKEb2fbtMZWnj4yPeC/N
9IiSw6Y521pU8mDU25otejRFcoedXGsa5PcJYMbM95wDPYLoko9QoJn669BSZTQF
yHBdDHk7SgUmL0XM26GHSLIJZ9n6wTGtUDaTGjoOnDIN1A16C2IOmlmCS5hCePOi
SaCFlj/sNRtLdBN0HOmEJ+mlt5ONo8hx9EK9EdDSOHlCF8Qsm6FhFuunGR3k4gXY
z0SSGcZVvbgmik1Cwur54ZRQkgCfObwIxPkZda/HHkuX702xHoAZ9uk21UPmXB+0
fLf2ww9qAXd2JaHPyqvM/mgjNjcZuBWX5kS7pZc59zluwlwU/YqfEntWLn5REPfd
LMZyOJh52UW6b0uG/GnFQRBwtmOPzqSAmiq/sKnPTBYpMAxdZPoSOK3H/zLNitfH
A3djys47Bz3bbtAyiZVs
=9DbW
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
