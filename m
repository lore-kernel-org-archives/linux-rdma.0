From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 15:31:29 -0400
Message-ID: <2fc6b394-ff39-4df5-7658-ed02272e7b1c@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="33gXqjlgJA0TPBFUJiHvtr44VBBVlRMFo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525190039.GA5525-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--33gXqjlgJA0TPBFUJiHvtr44VBBVlRMFo
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/25/2016 03:00 PM, Jason Gunthorpe wrote:
> On Wed, May 25, 2016 at 02:06:38PM -0400, Doug Ledford wrote:
>=20

> To be very clear, an *API* break is not tolerable. The libibverbs 1.0
> API must still be 100% functional on the new interface.

You're drawing a distinction that doesn't exist.  Libibverbs presents
both an API and an ABI to user space applications, and the kernel
presents both an API and ABI to libibverbs (or libfabric or whatever
chooses to use it).  Changing from write to ioctl changes the kernel to
verbs API, and creates a new ABI, and possibly removes an old ABI if we
dropped the write interface.  The bare term API is not deterministic.

>> If we end up just doing a behind the scenes switch from write to ioctl=

>> with no changing of data structures or command flow or anything else,
>> then we can ignore the end to end picture because it won't change
>> significantly.
>=20
> You should describe what specific things you want to see.
>=20
> It is time for the people who are hand waving about non-verbs, non-qp,
> 'new data transfers' to sit down and specify what they want to see out
> of the kernel uABI.

This is a fair point, but one I don't have time to respond to at the
moment.  I've already spent more time on this topic this week than I
should have given the other tasks I have at hand with the merge window
closing in a few days.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--33gXqjlgJA0TPBFUJiHvtr44VBBVlRMFo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRf2RAAoJELgmozMOVy/dMgYP/Rm8gPLuCCNuocubJpxcOSTQ
QzX2ACqxRPhpAQ1vBNHJuX2wbOBds5J0WOns39c1j/KhVjm7NqvgTiGDra/ELTw7
7INHIjJqYx083kpIEUlYhxhUw/dT85Ty8fi7cQ4qvUV6cUYOQwMA0hqclXAyJ9iY
AAUohAUzk49voLY2SFHqI2vkkwN4OjeVy5M7hUuDmzbU08npW7mFkU4dAxpfkX+I
nKNTzf0K2bxvHXlHQ4FIruBag2s53v+5pAdkbr4vkp7bzJ4bBLuX4JmmL1FyBNBT
j9zZU287JdU1eJfrfC2o3OpaSm8z8y72nww9aQmQHz0XTemipXDOgW8jXtWLCsYR
FiSa9bJkqis1Gm3bALJGELMyYnJh0XLp5mezTUig7kRrymsuAc4GpH6VYOf12/ss
EY8u2tThXOGbHqbXdi4+++oObXGnMVcbX2MgKJTFATToC8aT0dVW1i2OdWW3XODM
vRkSU97PXZzOUZsjgEBBzsrN0Q2hEoVJPpu309CgKuvu7sGBdsmp2zJ4MoHufDxf
y1+jwoDEuIC22t9k46HgNDfx7icqIXQL3mIVa0DSOBL/jLh4Bt3fBBRjHjwLlKK6
W+cbVW7LkKY80LVIw7QEGh/VbG7c6p1xG6U77t4Jox5/iokVdNcTiwmoHXLYiIOL
BVxg6Ueg3P7UfcH9X+WD
=Jj9v
-----END PGP SIGNATURE-----

--33gXqjlgJA0TPBFUJiHvtr44VBBVlRMFo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
