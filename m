From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 21:12:23 +0300
Message-ID: <20160531181223.GE7477@leon.nu>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com>
 <20160531173033.GC7477@leon.nu>
 <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Max Gurtovoy <maxg@mellanox.com>, matanb@mellanox.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2016 at 11:05:00AM -0700, Bart Van Assche wrote:
> On 05/31/2016 10:30 AM, Leon Romanovsky wrote:
> >On Tue, May 31, 2016 at 11:13:06AM -0600, Jason Gunthorpe wrote:
> >>On Tue, May 31, 2016 at 08:35:10AM -0700, Bart Van Assche wrote:
> >>>On 05/30/16 03:09, Max Gurtovoy wrote:
> >>>>ib_device_cap_flags 64-bit expansion caused a possible caps overlappi=
ng
> >>>>(depending on machine endianness) and made consumers read wrong device
> >>>>capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by t=
he
> >>>>iser driver causing it to use a non-existing capability. Fix this by
> >>>>casting ib_device_cap_flags enumerations to ULL.
> >>>>
> >>>>[ ... ]
> >>>>diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> >>>>[ ... ]
> >>>>enum ib_device_cap_flags {
> >>>>      [ ... ]
> >>>>	IB_DEVICE_SG_GAPS_REG			=3D (1ULL << 32),
> >>>>     [ ... ]
> >>>>};
> >>>
> >>>How can this patch make a difference? The presence of any constant
> >>>in an enum that does not fit in a 32-bit integer makes an enum 64
> >>>bits wide. In other words, all the changes from "1" into "1ULL" in
> >>>this patch do not have
> >>
> >>The expressions are evaluated before the enum type is decided, the
> >>enum type has no impact on the type of the expressions.
> >
> >It is machine/compiler dependent.
> >
> >Bart,
> >Can you share your source of C-standard?
> >
> >This link [1] states in chapter "6.7.2.2 Enumeration specifiers"
> >
> >"Each enumerated type shall be compatible with char, a signed integer ty=
pe,
> >or an unsigned integer type. The choice of type is implementation-define=
d (110),
> >but shall be capable of representing the values of all the members of th=
e enumeration.
> >The enumerated type is incomplete until after the } that terminates the =
list of enumerator
> >declarations."
> >
> >And the footnote (110):
> >"An implementation **may** delay the choice of which integer type until =
all enumeration
> >constants have been seen."
> >
> >[1] http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf
>=20
> Let me rephrase my question. Before and after this patch
> IB_DEVICE_SG_GAPS_REG is defined as 1ULL << 32, so how can this patch mak=
e a
> difference? And if the issue is that some compilers choose a 32-bit integ=
er
> for ib_device_cap_flags and others a 64-bit integer, shouldn't
> ib_device_cap_flags be converted from an enum into a series of #defines? =
Or
> is the issue rather that some compilers choose the enum size depending on
> the size of the first enumeration constant? Anyway, I think the patch
> description needs to be clarified.

I understand from the description/standards that first enum declares
type.

>=20
> Bart.

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTdQHAAoJEORje4g2clinymAQAJW0lihu73B03iw//gHFX4sj
42VkzrUtw9D1cH8R773itNEgM+uMy2+SjvYs9Z2uocYyGvaegriOQR7NSk3Is6hL
ZTvEGJN54TFRrKr58pSfgv6Kj9Oc0ejIE7npNwqR3OuZPCaw1sWVUJrgGDAMgZtF
zYD2+19mF8gsPv3WpGynMMvi+rK39EgGJ51zX27M9syFACZJy6VS8h76QzyDVU9p
WNRFepQgd5HwGhHJJF7VnNiULiA8FD1YDUjuzATPecF20PQiB+7NiRxAHLQRFzx3
HbXR5MV4j3cW3NWN52sltERNdGtCw2KEHTmurpt7t91e8YiDpF+R9lH0m1yAEjPq
yM6OFaG/SN2fibFNaO434x4bEFJHOC7or3H51AklOpnBQlLOxloiFL+5IWQklCyf
LExwcUCjF1v0ZvBO7XA8aEFszWqyIxp6tr/WZAmdTnZ2jsohtMW1x90991KlOrPn
ALAYRiOCfzcRdDIiQmATqKl7G69NHj6AzXCN/ME8IN7/qhoHKV4CaiJs3qkOMNob
i5tdSVVtYjntF5SOqXiSZdEK41RJyBYV81UK6LhmtnXpz7jsnbXjT/mKXwwfcigR
k5pGWXF2qdRBqmso0aKRKnyv3gsHfvUhivIhDFLaUs1NpGN4oAEUEKFH6sY9wcog
x5RFsKSVGT42e81t3JBc
=XHrB
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
