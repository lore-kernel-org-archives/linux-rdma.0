From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Fix for parsing netlink string attribute
Date: Tue, 12 May 2015 16:00:10 -0400
Message-ID: <1431460810.43876.78.camel@redhat.com>
References: <20150508213633.GA13012@TENIKOLO-MOBL2>
	 <20150508215328.GB3917@obsidianresearch.com>
	 <1431450866.43876.65.camel@redhat.com>
	 <20150512175033.GA15891@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KXh+jL8PaGSn0UcdjsTj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512175033.GA15891-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-KXh+jL8PaGSn0UcdjsTj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 11:50 -0600, Jason Gunthorpe wrote:
> On Tue, May 12, 2015 at 01:14:26PM -0400, Doug Ledford wrote:
> > On Fri, 2015-05-08 at 15:53 -0600, Jason Gunthorpe wrote:
> > > On Fri, May 08, 2015 at 04:36:33PM -0500, Tatyana Nikolova wrote:
> > > > The string iwpm_ulib_name is recorded in a nlmsg as a netlink attri=
bute.
> > > > Without this fix parsing of the nlmsg by the userspace port mapper =
service fails
> > > > because of unknown attribute length, causing the port mapper servic=
e not to
> > > > register the client, which has sent the nlmsg.
> > >=20
> > > Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >=20
> > > This actually will copy some kernel memory to userspace. I think the
> > > overflow is in .text, so probably not a security issue..
> >=20
> > It shouldn't be in the .text section. =20
>=20
> Pedantically, that is right, it is an archaic colloquialism to refer
> to the entire set of post-link read-only sections as .text. (typically
> the linker used to merge everything into .text)
>=20
> I realize now I didn't consider modules when looking into this. No
> time right now, can you check if there is any chance the read can
> overflow past the page allocated to the module's .rodata?
>=20
> > char array, so it should be in one of the data sections.  And since we
> > are using an initializer smaller than the specific size of the array, I
> > would expect all of the unitialized bits to be 0. =20
>=20
> I was talking about the situation before the patch.=20

Sorry, my misunderstanding.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-KXh+jL8PaGSn0UcdjsTj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUlvKAAoJELgmozMOVy/d2Q0P/A15PGEKzU81cO0zm86g3+b9
mAXRB4C3DnWiP+SagafPrs9U2B9jsseuBN3h7i8XP5ZGT235KdIUuVQ0XDV8lODf
JoindZJ97Zv/UKKr2NHHWFUnFenizyCiso+EkEd5sE8NIww1JAxBFcgjc5UgK9Tv
VPZyJCctaI6U1jK7Olt/UoSIXZKdi5bDLBJIaCIIIYQcaIBe9sJdEUnBKgjQwbqE
PGmTmwdORumSEdmuTScv5oFsYHNCr/0RGTGRe/I8OKPWX8k0AC2SI7twbZYmarPk
3Ijer4zpMMxtUbrVfTWCXrXRj+FiLdrqHgvUeFbPLvfj40GMKDArYioyEXalqNmt
/K34sGRwgdeLGDmVWMBdYqyO3gxylbeiJ74Qgq9GRdoU+pGpCaqlUtEGCc1GJpOP
uXGxSrMXr7A7hdMQaVDjCpx+TkGB7pvh+9gmcQXQBIdfbx6uhYQM84JiQ6y3dqx7
u4H7A3hM7GtLcQDUVXaFngZ/Y6INlfo4KYyur7TVQTp34aFfnFG3WI0v0Z9J9s8i
3w7yBd1sVbVemgWuTGdIm0ZfpP1NwnFY/0JQzq9UGXS17WPRQxocP1RJDwqa5GT+
ASSnIdTEvJpQs4pFcWSmghmLs4RMA+3oC2PyzUxK+QEpBahdIYtyCAHS3B5elgAY
xbWxHvtDQDk246a52KbK
=IaH7
-----END PGP SIGNATURE-----

--=-KXh+jL8PaGSn0UcdjsTj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
