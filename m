From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 16:22:50 -0400
Message-ID: <5609A19A.806@redhat.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l9jPwfhIVkcF0soogggHNwWCPvqNl0lMF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928190024.GB8358-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l9jPwfhIVkcF0soogggHNwWCPvqNl0lMF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/28/2015 03:00 PM, Jason Gunthorpe wrote:
> On Mon, Sep 28, 2015 at 06:18:52PM +0000, Woodruff, Robert J wrote:
>> On Mon, Sep 28, 2015 at 10:42:08AM -0700, Jason Gunthorpe wrote:
>>> We are well past the point of doing experimental breaking stuff in th=
e core uapi libraries. If it is in the master git it should be shippable =
by a distro, and it is so easy >to slap a version number on the HEAD if a=
 distro/ofed/etc wants one.
>>
>> This may be true, but since it is the master, there could be all
>> kinds of new stuff in it and not just the simple bug fix a H/W
>> vendor might want to put into his/her user-space H/W specific
>> library. Consider the situation when some H/W vendor just wants to
>> provide a simple fix to their library.  In the current model, they
>> simply fix it and release a new H/W specific library that a customer
>> or distro can pick up and ship.
>=20
> It makes very little difference, once a distro has gone stable they
> will review and inspect all patches - checking a new tar release for a
> sub component or backporting a git patch for the same subcomponent are
> very similar end results.
>=20
> I would guess all-together is actually less work for the distro side
> because the whole candidate patch stream for backporting is right
> there, easy to see, not sprinkled across all manner of git trees.
>=20
> And again, if the master is unusable, then we have not done our job
> right. The master is *NOT* for stuff that doesn't work.
>=20
>> just a bug fix. Further, that new stuff might even require new
>> kernel code, so it could not just be replaced as a new user-space
>> package by a distro w/o updating the kernel.
>=20
> We are not going to make a change like that, that violates the spirit
> of how the uabi side is supposed to work.

Actually, that's not true.  Master is for things that have reached a
state where we think they work and are ready to commit to them.  Between
releases, you can add a number of new features.  The on demand paging
feature went into master for libibverbs a while ago.  The checksum
support patches didn't go in until after those.  The on demand paging
feature is pretty invasive, while the checksum patch set is very
minimally invasive.  As a distro, I can take the checksum patches, but
the on demand patches need bake time.  None of that violates the spirit
of the libibverbs development, but it still doesn't necessarily match up
with distro needs.

Anyway, I had intended, and I've started on, making a change in how
libibverbs is done anyway.  The idea that a new release is just a script
that throws a version on and we go is naive.  I *will* be doing
pre-release rc tarballs and there will be testing and there will be a
release process that helps to make sure we don't see things like what we
saw with librdmacm (sorry to pick on you Sean): 1.0.17/1.0.17.1,
1.0.18/1.0.18.1, and 1.0.19/1.0.19.1.

As for bundling the packages together, I'm fine either way.  I don't
think there is a huge benefit to one method over the other as long as
all the maintainers can coordinate work that needs to be coordinated.
It might be a little clunky to write all the autotools checks to make
sure you don't compile a version against another incompatible version,
but the tradeoff is that you can do separate updates easily to fix bugs
in the dependent packages.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--l9jPwfhIVkcF0soogggHNwWCPvqNl0lMF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCaGaAAoJELgmozMOVy/d030P/2XDPSsw1SW6xK8UvXdGS7Rt
NC1/IDQywwr9zLfGVYxARdCSPAk/bgU9R9T02BDRfox0yz5rToJTtJW/vltlYc5q
xzSrWLEigEhNJrC5XVcZct0n6mFgxW2KOJhSXuwPsMdXbdm/z9VeLKMJ+03apF99
theZH1n7E5pPJzKaPm/PVpRDPs4p7H1hb7/p+CZE1VGJutu5QD0YFpgTUWxMcyHz
cATqNDfvG9r1ScGmFRcl/J5xsSmMJn67luzLnLmxOTZ5Wuii1ePXnNU8UVTHhJTj
fgQ2NgZZmtZcRihGdAKmrw8jkjVQb56U9zg6PznIp2QhPWAw1QmQpKXOz9JxWdzY
Ky4OMKzl1nPZPXk3iqKbrWNh4xCQA/wpdPOGS468ldG888Rno48YxVnYio0KEjHH
VMszbvfbc3SYz0asRv/CiS1ayV24R1M5ACz+N6UQQFhc+gij+TdClJsPZIto5PYJ
blI9qEyHMevqyk4D8DKh27NiCrjfbVDPSAVk8gy54od4UulUmmYZiaNf9pD6qhsr
lgkgStzvpmf92AcwEeVUpJ32/FwQPxJ6HJ70YUnTPCn1Izz1wMIi15jNEy6N5/mb
wEQBkBztFy1KkmP0HSqYvBIwagXltjA/fSoeHU9g8iFR5bKGh4gmao1VVW+jHLbz
DfI4ibvYjbrpJE2ZhyZR
=Xjt5
-----END PGP SIGNATURE-----

--l9jPwfhIVkcF0soogggHNwWCPvqNl0lMF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
