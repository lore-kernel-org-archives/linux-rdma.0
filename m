From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Tue, 26 Apr 2016 10:19:37 -0400
Message-ID: <571F78F9.8010401@redhat.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <AM3PR05MB141161876D5CA05B1993D20CB1610@AM3PR05MB1411.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IUtdQEev7rX84LehMHce4X0OwvRCmxh5d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM3PR05MB141161876D5CA05B1993D20CB1610-LOZWmgKjnYgmsg45OnKo/9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IUtdQEev7rX84LehMHce4X0OwvRCmxh5d
Content-Type: multipart/mixed; boundary="O83oqhHl7tHA2wliveQqxKcii8L24d7Ba"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <571F78F9.8010401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Further thoughts on uAPI
References: <20160420012526.GA25508-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB044043-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <AM3PR05MB141161876D5CA05B1993D20CB1610-LOZWmgKjnYgmsg45OnKo/9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <AM3PR05MB141161876D5CA05B1993D20CB1610-LOZWmgKjnYgmsg45OnKo/9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--O83oqhHl7tHA2wliveQqxKcii8L24d7Ba
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/24/2016 10:15 AM, Liran Liss wrote:

> For generic interfaces (currently includes Verbs, Ethernet QPs, and IB =
management), the new scheme should map what we have today in a flexible m=
anner.
> This would enable us, for example, to pass only RoCE addressing attribu=
tes while modifying a RoCE QP (and optionally optimizing the kernel repre=
sentation as well).
> These interfaces have a matching kAPI.

This sounds like something I was thinking as well.  Of course, abstract
ideas are sometimes less similar than you think, so putting something
concrete down can help make sure that people are actually thinking about
the same thing.

For certain operations that have lots of optional items (work requests
for one, work completions for another), the old method has been to stick
everything in one struct (which bloats it for most uses), or the extreme
opposite end of the spectrum was the recent timestamping API patches
that totally deconstructed the wc struct and rebuilt it from individual
elements and completely reordered.  Another approach to dealing this
this is tons of different structs (Christoph's work request struct rework=
).

Maybe we can reach a different arrangement.  I'm thinking of one base
struct that's versioned.  This base struct is the common items we always
need across the board:

struct __work_completion_common_v1 {
	union { // Only first for alignment reasons
		u64		wr_id;
		struct ib_cqe	*wr_cqe;
	}
	int	magic =3D 1; /* magic starts as the version #
			      in the lower 8 bits, then we
			      add flags for optional struct
			      elements */
	enum ib_wc_status	status;
	enum ib_wc_opcode	opcode;
	u32			len;
};

#define rdma_wc __work_completion_common_v1

Then we create optional, additional structs.  Such as a specific struct
for each address type:

/* The common struct and option struct versions always match */
struct __work_completion_ib_addr_v1 {
	struct ib_qp		*qp;
	u32			src_qp;
	u16			pkey_index;
	u16			slid;
	u8			port_num;
	u8			reserved[3]; // preserve u64 alignment
};

#define rdma_wc_ib_addr __work_completion_ib_addr_v1

struct __work_completion_eth_addr_v1 {
	u8			smac[ETH_ALEN];
	u16			vlan_id;
};

#define rdma_wc_eth_addr __work_completion_eth_addr_v1

=2E...

Addtional optional struct items can then be defined, for things like
errors, immediate/invalidate data, timestamps, etc.

When building a wc, you start with the base struct, the magic is set to
the version, then for each optional element you add, you set a flag
field for that element in the magic item.  Optional element flags occupy
the upper 24 bits.  The length of the total struct is the length of the
base struct plus the length of all optional structs, and the order of
the optional structs matches their bit order from lowest to highest in
the magic element.  It's not quite as free form as the patches for
timestamp support were, but still allows the structs some flexibility in
what is included and what isn't.

When parsing the wc, you verify you have the right version first, then
you process what you need from the common struct, and if you have need
of it, process any additional stuff by walking the set bits in the magic
struct to get to each optional struct item.

Something like that can be applied to wcs, wrs, and where there is
enough variability to warrant it, other items as well.  Of course, if an
item doesn't vary all that much, then a single struct is still preferable=
=2E



--O83oqhHl7tHA2wliveQqxKcii8L24d7Ba--

--IUtdQEev7rX84LehMHce4X0OwvRCmxh5d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXH3j5AAoJELgmozMOVy/dlMMP/0QVae83sUrBiIUp861Ertr9
QdtelMB6zMz33MyrbBAMtgFn4qGDCq9yoMf/Fxq2O/BEIp4WWagAioUY/YxOaTvw
jJc31ym1ATJaUt/GuOlMfNxYeE4+9l9iZwtXhaL8gwEue4nzx0lUvp2XngFpntaF
OpJ21CzfZPU4rRgxksolSbMNle2WNOhmrIr16WH8Jo7x9NSojbGTsPmVDE0mCUdu
bUIUqqFMJD+wY5rxYdx6/M7o7DoJRbI3pGfspQ+4QmKd3m6Y8Aozk0sn4knW6voJ
PSHBqtv0TNkneDhUi5IIgyHtnNdBB5s4Ws4SF1ALUgJsNFkfBydikLMS5Juo+11R
wsAS3hacXG/FxpV2rA43U9Hh/xy/RN0ys5XU5tEiatWUsCmjUmjP5n8XI+VtefkQ
Iw4k1ZL6EcBuFljYupgMutHeGo/0jAUSsI+0wQNr99Ndp44KaOFhcu3qjD0Xua4n
uGxQa4qDzLywvu/BBskWFN0TQpzb4ygEPp8tDvZR0SyD0O4g4szhsXA7Jds9np2Z
Hbr6CiiYNV24e7nb6l0zuJ+Bq14zX0ExsNdmlgN8ublL3a0SfhamX082nCPMUNMH
0wSW7XKDW3AtXE+WFoZVqauZxNENJJBLTqs7PwdoMCQvCzr/E3zD1c2gE9nBlGdb
kQfeN2CDaYQrLRUoorjA
=P/uY
-----END PGP SIGNATURE-----

--IUtdQEev7rX84LehMHce4X0OwvRCmxh5d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
