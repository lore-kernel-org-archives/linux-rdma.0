From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V3
Date: Thu, 3 Sep 2015 14:33:41 -0400
Message-ID: <55E89285.6080505@redhat.com>
References: <1440579639-10684-1-git-send-email-hch@lst.de>
 <55E321D7.7000209@dev.mellanox.co.il> <20150831161116.GA24494@lst.de>
 <55E4F02D.4080701@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i4Irg64AbUDPsGmR931VRgf5oCJsrPJ7d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E4F02D.4080701-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i4Irg64AbUDPsGmR931VRgf5oCJsrPJ7d
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/31/2015 08:24 PM, Doug Ledford wrote:
> On 08/31/2015 12:11 PM, Christoph Hellwig wrote:
>> On Sun, Aug 30, 2015 at 06:31:35PM +0300, Sagi Grimberg wrote:
>>>>   - patch 2 now explicitly replaces the weird overloading in the mlx=
5
>>>>     driver with an explicit embedding of struct ib_send_wr, similar
>>>>     to what we do for all other MRs.
>>>
>>> That's nice,
>>>
>>> There is one non-trivial spot that was missed in mlx5_ib_post_send
>>> though:
>>
>> Oh, that was a weird abuse of the old casts.
>>
>> I've foled both your fixes and force pushed to the wr-cleanup branch.
>>
>> I do not plan to resend the series until the merge window for 4.4
>> is open.  Doug, any chance you could pick up the first patch in the
>> series for 4.3-rc?  It's marked for stable as well.
>=20
> Yes, I can do that.
>=20

I've applied 1 of 3.  For the remaining two, I plan to pull them into a
test kernel and run some internal tests before committing.  Just FYI.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--i4Irg64AbUDPsGmR931VRgf5oCJsrPJ7d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6JKFAAoJELgmozMOVy/dGZUQAMT25hykQXqJcfO9f4MrYVMV
Ghjw9cs17GEC8wUsxcbMsUw7nnRF3oAzRULhG0FajVD6NyfGMPqbPC+dZlfAANWN
KfazEihCIVDBUZav0A6vtTUrh834tJS2MQYD7mJ5qN1Mt0dqKtC99hzB1tmAu7zc
TczJ3znLHrIHj+Oc2UdBgbNY/4i53EnrwlZrYqEV1vh272qZqz7q1JIkg/1Pz+5o
uoi87Km6UrQ0GGURYux5rCSZD2mQZMBQcIMWzHSBBaTSlbztVdOcvZkYxWOf/FGg
3d4lBwkSi1bK9MAq8ZPVuqTDBMAEZDRM2nyqN16F5vT1GXN4zxvmKlgjJb3JPl+b
H/33s6PR4u1Em99xB9HYnxZsZf/UosLTz2+bw/q/rOs0+Ih35ksCjkAu+4A06/oJ
nt0K7tIxp002SibF3L9GXH5vVe5dSWoahJoA5NNMM7vO7Owykqid7zlIopKPd3eN
gX/qLb9bJcoGbI475XlTnNzPZ5+haWAGWsm68GWUHbRQ/8GBH9jshEX2K7IQ3L6E
3T1LKNoXzKam/G9+fgcysBGLV1pNQjCIJlcIJ/pCBe+BGV0lb6mwoKVy3YGGxMzZ
v/VlEItmjWkDwdn258CpoykUGH1j4eDGGdsi5YlkVas/3DAWPxMBra9d5gGeSTCs
oH8ueJnHkWT0Q3RFbV6D
=nBgR
-----END PGP SIGNATURE-----

--i4Irg64AbUDPsGmR931VRgf5oCJsrPJ7d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
