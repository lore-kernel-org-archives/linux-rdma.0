From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Wed, 08 Apr 2015 14:44:03 +0200
Message-ID: <1428497043.22575.176.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427987752.22575.65.camel@opteya.com>
	 <AM2PR05MB0929EDC60BBE5DAAAD4AB1B4DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
	 <1428495568.22575.172.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1428495568.22575.172.camel@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Shachar Raindel <raindel@mellanox.com>
Cc: "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 08 avril 2015 =C3=A0 14:19 +0200, Yann Droneaud a =C3=A9cri=
t :
> Le jeudi 02 avril 2015 =C3=A0 16:34 +0000, Shachar Raindel a =C3=A9cr=
it :
> > > -----Original Message-----
> > > From: Yann Droneaud [mailto:ydroneaud@opteya.com]
> > > Sent: Thursday, April 02, 2015 6:16 PM
> > > Le jeudi 02 avril 2015 =C3=A0 10:52 +0000, Shachar Raindel a =C3=A9=
crit :
> > > > > -----Original Message-----
> > > > > From: Yann Droneaud [mailto:ydroneaud@opteya.com]
> > > > > Sent: Thursday, April 02, 2015 1:05 PM
> > > > > Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel =
a =C3=A9crit :
> > > ...
> > > > > > +	/*
> > > > > > +	 * If the combination of the addr and size requested for =
this
> > > > > memory
> > > > > > +	 * region causes an integer overflow, return error.
> > > > > > +	 */
> > > > > > +	if ((PAGE_ALIGN(addr + size) <=3D size) ||
> > > > > > +	    (PAGE_ALIGN(addr + size) <=3D addr))
> > > > > > +		return ERR_PTR(-EINVAL);
> > > > > > +
> > > > >
> > > > > Can access_ok() be used here ?
> > > > >
> > > > >          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ=
,
> > > > >                         addr, size))
> > > > >                   return ERR_PTR(-EINVAL);
> > > > >
> > > >
> > > > No, this will break the current ODP semantics.
> > > >
> > > > ODP allows the user to register memory that is not accessible y=
et.
> > > > This is a critical design feature, as it allows avoiding holdin=
g
> > > > a registration cache. Adding this check will break the behavior=
,
> > > > forcing memory to be all accessible when registering an ODP MR.
> > > >
> > >=20
> > > Failed to notice previously, but since this would break ODP, and =
ODP is
> > > only available starting v3.19-rc1, my proposed fix might be appli=
cable
> > > for older kernel (if not better).
> > >=20
> >=20
> > Can you explain how this proposed fix is better than the existing p=
atch?
> > Why do we want to push to the stable tree a patch that is not in th=
e
> > upstream? There is an existing, tested, patch that is going to the =
tip
> > of the development. It even applies cleanly on every kernel version=
 around.
> >=20
>=20
> access_ok() check for overflow *and* that the region is the memory ra=
nge
> for the current process. The later check is not done in your proposed=
=20
> fix (but it should not be needed as get_user_pages() will be called=20
> to validate the whole region for non-ODP memory registration).
>=20
> Anyway, AFAIK access_ok() won't check for address being not NULL and
> size not being 0, and I've noticed your proposed fix also ensure addr=
ess
> is not equal to NULL and, more important, that size is not equal to 0

It only check address not being 0 if size is already PAGE_SIZE aligned,
and it only check size not being 0 if address is already PAGE_SIZE
aligned.

> before v3.15-rc1 and commit eeb8461e36c9 ("IB: Refactor umem to use
> linear SG table"), calling ib_umem_get() with size equal to 0 would=20
> succeed with any arbitrary address ... who knows what might happen in=
=20
> the lowlevel drivers (aka. providers) if they got an umem for a 0-siz=
ed
> memory region.
> This part of the changes was not detailled in your commit message: it=
's
> an issue not related to overflow which is addressed by your patch.
>=20
> So I agree my proposed patch is no better than yours: I've missed the
> 0-sized memory region issue and didn't take care of NULL address.
>=20

Regards.

--=20
Yann Droneaud
OPTEYA
