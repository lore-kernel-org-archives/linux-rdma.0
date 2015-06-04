From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Thu, 04 Jun 2015 13:30:05 -0400
Message-ID: <1433439005.40123.88.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
	 <1433255724.114391.225.camel@redhat.com>
	 <20150602180844.GD17776@obsidianresearch.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-C+HG+f7yRHp8W1a3LVIx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE4F16-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-C+HG+f7yRHp8W1a3LVIx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-06-04 at 16:17 +0000, Hefty, Sean wrote:
> > No, if they followed (I didn't check yes) the extension scheme then the
> > poll call is
> >=20
> >  struct ibv_wc_ex wcs[num_wcs]
> >  ibv_poll_wc_ex(&wcs,num_wcs,sizeof(wcs[0]));
> >=20
> > And the drivers decide what to do based on the 3rd argument, which is
> > essentially the ABI version.
>=20
> As a couple of options:
>=20
> You could add a 'completion format' field to the cq attribute structure, =
which would allow poll to cast to a specific structure.

This is probably what I would consider an ideal way to handle things.

> If we wanted to go with Doug's earlier idea, you could add a 'provider co=
ntext' field to the wc.  This would allow calling back into the provider to=
 retrieve more data.  Though, this concept would be racy if other completio=
ns can overwrite whatever data was trying to be retrieved.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-C+HG+f7yRHp8W1a3LVIx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVcIsdAAoJELgmozMOVy/dMt4P/0/E01hTziQ7VbAk6HXW8m9u
lfyWmE1wy7lV5HmsLBBa99fntAfYJKAIXkWJ0v5fpIZor5xeWJr1M8Gww+j5PDi0
Y133S532Dk2eyCgZamYPjQAMgdaUWNiE8EJ8QGhkfOHffJ+2OaCGZtsCx9S0aoBm
QEzhc37BLaQ+MjKVmQylg6YUaV6DrbyEKq2rJRqFM0lUqvhavythfxREOekW9fIN
1KYh6Qjg7A0wxuBBCzFm5+K/ytu2SGYXUwIs6lJpQf0wsb1r51ShIg038NpjVfGX
Axt7CYqVfyATT77XoQHT4t86v4EuV1u1EJ+IHjyeUPxYX8V+u4hQWnwtrtwsXeOk
kGxdz1q0lHN+67MEKzum0gvyKoKSsOIaYIOIHO33776GSw4jXeNlpOTzViJVPvhJ
PmQn/5X5UvH2o8IZpDnGrxIPCRobLToqV3j5ZTFzgwxaTmLGaZBnwRIxbs00C+we
OwyYys3th1cmZPp2Yy/pWpRN0mRkOMsnHx5QctBVdI66kM4H9ByppqIa5nNBGRgw
tc4srzhJe0TztXAQDNUg9jWJYoJt9TgGcsizCypSJvPnAC9LoNp2QSHJbP8TgtE3
kXKzvwc6iq70vApfxhhxZW8UeBfUGQK1LA7cT4tmZUnxHckxfWwjiGGbnJdvtp7/
FvVOZpzYqq3Rad00mblc
=OBHT
-----END PGP SIGNATURE-----

--=-C+HG+f7yRHp8W1a3LVIx--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
