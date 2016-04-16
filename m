From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 09:00:42 +0300
Message-ID: <20160416060042.GA6349@leon.nu>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
 <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
 <20160415212328.GF10689@leon.nu>
 <20160415233732.GB25662@obsidianresearch.com>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160415233732.GB25662@obsidianresearch.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ira Weiny <ira.weiny@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 05:37:32PM -0600, Jason Gunthorpe wrote:
> On Sat, Apr 16, 2016 at 12:23:28AM +0300, Leon Romanovsky wrote:
>=20
> > Intel as usual decided to do it in their way and the result is presented
> > on this mailing list.
>=20
> Dennis was pretty clear he was going to send the patches to address
> Al's concern, which he has done.
>=20
> I was also pretty clear I was looking to get rid of the char dev :)

Yes, and I was pretty clear that we need to converge on one common API
prior to converting old code (including drivers in staging) in order to
do it once only.

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEdUKAAoJEORje4g2clinc3YP+gOwsufeehiZEPr6jjGkmWNo
Q69255Rxu6AvUZOTmugm/4b8MNbS5t6ibSXgkRF6SyOOd0eWrvi1ady1zNbsq7QD
V39x5ibx4wqs4lkdY3iKc+MhjHKzcA9lV8YNLvzSbfOA4qR/SG8SdBaJEzwsdhdo
DEsTicEDvWon3LB/PCrZyJdvHOioo7bHXU0cpXHy0xU/Sa4jHWYgvfzTpxO2zhKr
0X9xVYAEEPqvT5/laGHLVI8Kue8CPaoQOUZa/R25XmO2v8/WjvPGig7rlewKlS3s
H3bYfzAXavK1brkLqIyUMrRRa0etTL0AGJEdGYCvKn7rX4I3y3C2321LfNaRj9id
iJVP1JWILTybiIzGTaqPCIv2nSDE2qyERYLimimJDywQMtX1rDW2rvDyYDPZOZGo
dQCpJvzfjwnnp0YZ844l3PP2/hI6lcV6pHnZA1BdhI9T4GNptJ5ySGG0xoXenBPu
UIWnkiHobBbf0AwBeboL1NXRmQKU2BM7YCa3V542ZGQqSDCZQ0qpXhEyeyStUtu3
Ow9DkDPebYqsHVVuj2B7XYcQjX3HXRJwNxb6CTDnPCuBbfv7nYt0O4D26yu9MQqm
hrHYGd0vdflBqVC3rHemg87/zIUjlAGisiIiDeinJK8/in2mYQ90PjlHP2LSzuXp
w/PWY6exGxh1O7b8QHuk
=Mk5l
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
