From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 10:15:17 -0400
Message-ID: <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Lj5otxkcFepWoDto2kgGQaEi1kO08reWn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB093986-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lj5otxkcFepWoDto2kgGQaEi1kO08reWn
Content-Type: multipart/mixed; boundary="1QQ7qFWtb1p8LI7LTkdfn3jRbPd8StQgW";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <6259953b-27fe-77c9-ea90-af744f188671-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
References: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20161007145620.GV9282-2ukJVAZIZ/Y@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB093986-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB093986-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>

--1QQ7qFWtb1p8LI7LTkdfn3jRbPd8StQgW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/7/2016 12:47 PM, Hefty, Sean wrote:
>> For any reasons, I don't see this patch set in your tree. Did I miss
>> it?
>>
>> Thanks
>>
>>>
>>> Thanks,
>>>   Artemy & Leon
>>>
>>> Artemy Kovalyov (10):
>>>   IB/core: Add XRQ capabilities
>>>   IB/core: Make CQ separate part of SRQ context
>>>   IB/core: Add new SRQ type IB_SRQT_TAG_MATCHING
>>>   IB/uverbs: Expose tag matching capabilties to UAPI
>>>   IB/uverbs: Expose XRQ capabilities
>>>   IB/uverbs: Add XRQ creation parameter to UAPI
>>>   IB/uverbs: Add new SRQ type IB_SRQT_TAG_MATCHING
>>>   IB/mlx5: Fill XRQ capabilities
>>>   net/mlx5: Add XRQ support
>>>   IB/mlx5: Support IB_SRQT_TAG_MATCHING
>=20
> I was out when these were submitted, so this may have been answered.  T=
hese patches change the uABI.  Have the changes been vetted out by the IB=
TA or some other standards (I'm using that term loosely) organization?
>=20

I doubt they have, but they change the kernel to user library API.  I'm
not so worried about that since it's entirely under our control.  It's
the user library to application API that I would be more concerned with.

As these stand, they look fairly clean to me.  Minimal in disruption and
I see no reason other vendors couldn't use this to do tag matching on
their own hardware if they wanted.  I'm inclined to take them.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--1QQ7qFWtb1p8LI7LTkdfn3jRbPd8StQgW--

--Lj5otxkcFepWoDto2kgGQaEi1kO08reWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX/5b1AAoJELgmozMOVy/dSQMQAJc5R9OymUCtO3SED9xxSHuf
ogcwlUXBUHwCJY9bYULDKwJo6izOC/0IgtcJSJ4bux7Pdzq6iATYyW4asev6YO4W
qO1IqicHaae4vUC14w/MgKT37QLc9zdK1GoJPQA6ciCkkRxvoXiJ31Pdx+FxOC3F
EGChtzZlb9qOntQrn+G3dlbJBVpCbm23NuUHm7/zGSwNCQAH/E/q4JtzmJwIRR9M
CiLa62wLoRBT5M3uVqVHlvIUqyITXUsppVbF40mwcUOkBuGBzVQBMvGu6+cyUwTg
dOC9b3vx/V068TLWcz57Z+opYalH93N/l9ebjbeWMjCwmn1COK7JglDHCni6MrdK
IwfZCiTk53YjnLD1d5JQ6jkARgX0DhSjQZBV4J7uUIE+YyoiTpjC8zEUvHEArw2m
icOuvboUeEMWp8SIqzduqpHRQGwF7bHia/7D/SRKJ8TcV6AdiLohEpOXid2yvYQV
16rOi4Tlr7kb55g+lWulfWf+GOjmpUTIQ8/F5+7LoqzpO9cIjsSNWMCW3ii6o/GQ
RtdXzoWK20j6oz0uuJxKxajKaFKApBPeFy7/eeZ6or6d15zD4gV+6uBFxOKpgZpu
YVEdHrlS2g/7a8wRlT2TLc4+eo/6JhMef8aO2U1jp/bNHdDk2XsqEReRKbsZBgY2
Of24XD0REMAKJVe0r0F3
=/zTI
-----END PGP SIGNATURE-----

--Lj5otxkcFepWoDto2kgGQaEi1kO08reWn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
