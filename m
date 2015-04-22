From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v5 01/27] IB/Verbs: Implement new callback
 query_transport()
Date: Wed, 22 Apr 2015 12:42:11 -0400
Message-ID: <1429720931.45956.137.camel@redhat.com>
References: <5534B8C9.506@profitbricks.com>
	 <5534B981.1030302@profitbricks.com> <1429714975.45956.113.camel@redhat.com>
	 <EE7902D3F51F404C82415C4803930ACD5DC446F3@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AT7Lh64fQf9H4phH8qCJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC446F3@CMEXMB1.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <Devesh.Sharma@Emulex.Com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org


--=-AT7Lh64fQf9H4phH8qCJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-22 at 15:21 +0000, Devesh Sharma wrote:
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> > owner@vger.kernel.org] On Behalf Of Doug Ledford
> > Sent: Wednesday, April 22, 2015 8:33 PM
> > To: Michael Wang
> > Cc: Roland Dreier; Sean Hefty; linux-rdma@vger.kernel.org; linux-
> > kernel@vger.kernel.org; hal@dev.mellanox.co.il; Tom Tucker; Steve Wise;
> > Hoang-Nam Nguyen; Christoph Raisch; Mike Marciniszyn; Eli Cohen; Faisal
> > Latif; Jack Morgenstein; Or Gerlitz; Haggai Eran; Ira Weiny; Tom Talpey=
; Jason
> > Gunthorpe
> > Subject: Re: [PATCH v5 01/27] IB/Verbs: Implement new callback
> > query_transport()
> >=20
> > On Mon, 2015-04-20 at 10:32 +0200, Michael Wang wrote:
> > > Add new callback query_transport() and implement for each HW.
> >=20
> > The more I think about it, the more I think we need to eliminate this p=
atch
> > entirely.
> >=20
> > The problem here is that, if we follow my suggestion, then we are going=
 to
> > eliminate the query as an API function and replace the information it g=
ives us
> > with a static port attribute bitmap.  If we do this patch, then reform =
this patch
> > to my idea later, we introduce a very short lived API/ABI change in the=
 kernel
> > module interface that serves absolutely no purpose.  Instead, let's do =
the
> > bitmap creation first, update the drivers to properly set the bitmap, t=
hen do all
> > of the remaining reforms you have here using that bitmap and completely=
 skip
> > the
> > query_transport() API item that will no longer serve a purpose.
>=20
> Any vendor device that registers with IB stack already has capability fla=
gs, are you referring to the same as bit maps?
> Is it possible to use same as bitmaps you are referring to? I am trying t=
o understand you complete idea.

There are two capability flags right now, a device caps flag set and a
port caps flag set (not counting possible driver internal flags).
Regardless of whether or not we wanted to use one or the other, they are
both too full to be used for our purposes.  We can't get enough bits.
We would get to drop the node_type, but that's only a u8 and so it
doesn't have enough bits either.  In addition, node_type is set per
device, and it would really be best if our new bitmap were per port.

That then raises the issue that right now, the core code doesn't have
direct access to per-port information, everything is done via a
combination of direct access to the per device node check and per port
driver callbacks.  We may have no choice but to continue with that for
now, but I find that inefficient.  And if we make the bitmap per port,
then even our node check becomes a callback.

So, what we need to do, is define a specific bitmap just for the
node/transport/link bits and the capability bits that explicitly go with
that tuple *and* define a way to access it without necessarily requiring
a callback.

Michael's patch set has gone through a lot of revisions and I think we
are getting close to the set of things we want to know, so it shouldn't
be that hard now to create the proper bitmap that makes knowing those
things quick and efficient.

The harder part will be making it accessible.  Since the current struct
ib_device doesn't include direct access to the ports (it has a list head
for port_list, but that's just for the sysfs entries for this device, it
doesn't hold anything we can use for this) we are limited to either A)
adding a new callback or B) changing node_type to port_type, making it a
larger size, and making it a port indexed array.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-AT7Lh64fQf9H4phH8qCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN89jAAoJELgmozMOVy/dwUEP/i7G1fodWVGkF9eP5qhvnEqp
4Vm0ro8sBuBZbkzntjWHf1ubwLJJdoWcriGg2ZsDiryAPFjgneWzUQeC1p/2HrAA
f5S6uGBYt2ISIr2wn7Z6k7qETRadgfQYRScmoinl8Bih8i0Kv+Z1qy65BWjFCm9u
NV7m3WOzx5R3bZGhmcSsRMRSkor+1+/TPUwXxTy3G7iUSyBteLsCPShOug5wb1Md
x7cp0E+18i+uvYZqK7bIVk+ej16xwriAgflPs1fvW4zgd4so6Anbb/Kc5wBk+f1O
mEzgQPSPUgXHxkzgxMPndFlJw6roozUoqCMY2Ac5/p5OhbnLsoPoonBOol8OIeb0
SaFgAtbY2Zi8VSG2jPaE3By+6B48nVZqPNaUpNsnw/1Tj1ZE1LXUoHaELSP4vWQX
K/IjiG0+qHl+4WUhAd3jPshPjcH1xgitgc7H/pw68Zu1JfzztzustqmRuMWISVT9
DmkSM1xhaXTMNfgY4Zorix6Bl+ZO2CpIOfobiGT/b0eDhgyuUGfYfXVc5SYoZWHa
9TWmiEiTYOafT+yDU4CvaugXYpx27PeNIj985zK6Ts6CKlnZvthDecXwjlJQo92A
FCNXEqD7E9LFIqbAbN1hqkjPT77FMbksfnsHaeVH0AlMMRYS4F3PhvmKp84EI48B
eAlTl6B6CXRcoUEeOk4x
=cotK
-----END PGP SIGNATURE-----

--=-AT7Lh64fQf9H4phH8qCJ--
