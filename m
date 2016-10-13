From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 16:30:10 -0400
Message-ID: <a3495685-69c7-26a7-ba97-9761848535a8@redhat.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
 <20161013170641.GA9094@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095647@ORSMSX109.amr.corp.intel.com>
 <20161013195605.GA8077@obsidianresearch.com>
 <20161013200208.GA8998@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2qLs00IKvp8nQU2ErgqFpbmMmORijekDR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161013200208.GA8998-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2qLs00IKvp8nQU2ErgqFpbmMmORijekDR
Content-Type: multipart/mixed; boundary="CKEaoGxCO8NoVvu2f0k35h5mw5QMWq6xU";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <a3495685-69c7-26a7-ba97-9761848535a8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
References: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20161007145620.GV9282-2ukJVAZIZ/Y@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB093986-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <6259953b-27fe-77c9-ea90-af744f188671-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095429-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20161013170641.GA9094-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095647-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20161013195605.GA8077-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20161013200208.GA8998-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
In-Reply-To: <20161013200208.GA8998-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

--CKEaoGxCO8NoVvu2f0k35h5mw5QMWq6xU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/13/2016 4:02 PM, Christoph Hellwig wrote:
> On Thu, Oct 13, 2016 at 01:56:05PM -0600, Jason Gunthorpe wrote:
>> A bigger objection I have is that much of this new stuff is not
>> adaquately documented.
>>
>> Tag matching is a great example. It looks like this introduces many ne=
w
>> headers into the on-wire protocol. Where are these headers documented?=

>> Where is the spec for the on-wire format? Where is the implementation
>> for rxe?
>=20
> Agreed on that part.  For pon the wire changes we need the hardware
> standards organization to act.  IBTA for IB and RoCE and IETF for iWarp=
,
> although not even having an active WG for iWarp there is a major proble=
m
> at the moment.
>=20

I think there are some fundamental questions here about what this is.
As I understand it (and Mellanox can chime in if I'm wrong), tag
matching already exists on the wire, it's just implemented above the
level of the link layer transmissions.  This enables a hardware
accelerator for something that is already done at an upper layer, so the
implementation is mostly defined by the defacto existing use in upper
layer applications, not by the IBTA.  I believe this could roughly be
considered analogous to a network driver enabling a layer3 or layer4
accelerator.  It's not a layer1 thing, so the IBTA is not appropriate to
review it.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--CKEaoGxCO8NoVvu2f0k35h5mw5QMWq6xU--

--2qLs00IKvp8nQU2ErgqFpbmMmORijekDR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX/+7SAAoJELgmozMOVy/dIgEP/1nD7x1HGRLyS5iu8i5rMSRs
kOgB9vPrp27LG83LfNQAO/mq7hyFe7io+AM7E7blTRlbwIA29YSHgD1FR88OyE0F
zBdJZJu0vm5cGNZW+X486LOqBREtVAFr/YG8kv8V7A3KCGITIXG3imVEMkAazUJ/
c7QEfn2JjwYPvAnHD6sya9+o7yCMqXGISbt9DTTAPrLnYHwrAKwDvwWodqyOT5ap
GP6WRxWkC3zF3Mx13GGTj92m59Qx+OzqeQC9tGhPCrRvxkJ0SVqC5FgRW1ry7kDw
TyfqMzLl/WuSmfKVq1NDvJpGQx77L56lG+gJiKeIJxZDXwqpDGK7TR0VsPmXL/ds
BOZaQxYx2DoEyAzwBq0+1WBCAjLTutVmkeJHLyV+ifB0YkWGGRRWgmscNBgJ+EL8
2lqsHmIYE+6KAne3+3wPGkTy+cb0qJOHf4CIIdJBmS6PsJ8fRgQiWRDPWCzHP53M
vFJKTyxx3vTl+eWDq+MpI5Tu0HAaS51x1GXG1Q7S5MrYbR0TVwkwm4w9u+GgaA0y
0qIjd7nrq4ZegSNiJU0MDOiY+rFxBS0TE5idC9MzRVDXNiv0g0Ji2Ncrkk99ks9a
3FkYPxdejJ03XXJowsqjm9t/S7TcJJYZn0pLacWkYnp/BqN3qwtkIHwPwq4RwGdI
iPyo/BjD6DQNxb4/uK35
=wFv3
-----END PGP SIGNATURE-----

--2qLs00IKvp8nQU2ErgqFpbmMmORijekDR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
