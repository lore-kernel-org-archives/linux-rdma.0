From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/core: Formalize the creation of immutable per
 port data within the ib_device object
Date: Tue, 12 May 2015 13:54:24 -0400
Message-ID: <1431453264.43876.72.camel@redhat.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
	 <1431395218-27693-3-git-send-email-ira.weiny@intel.com>
	 <1431444301.43876.34.camel@redhat.com>
	 <2807E5FD2F6FDA4886F6618EAC48510E1107CBB6@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-hQBKfyYHAEttjmt4gymo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1107CBB6-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-hQBKfyYHAEttjmt4gymo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 17:48 +0000, Weiny, Ira wrote:
> > > In preparation for this create a structure for per port immutable dat=
a
> > > and place the pkey and gid table lengths within this structure.
> > >
> > > This type of data requires a new call back "port_immutable" parameter
> > > to ib_register_device to allow each driver to create this data as app=
ropriate.
> > > This callback is added to ib_register_device rather than as a new
> > > device function because the callback should only be used when devices
> > > are first registered.
> > >
>=20
> I tried to explain my decision here...

I know.  I just couldn't handle the function declaration ;-)

> > > @@ -273,7 +273,9 @@ out:
> > >   */
> > >  int ib_register_device(struct ib_device *device,
> > >  		       int (*port_callback)(struct ib_device *,
> > > -					    u8, struct kobject *))
> > > +					    u8, struct kobject *),
> > > +		       int (*port_immutable)(struct ib_device *, u8,
> > > +					     struct ib_port_immutable *))
> >=20
> > I'm having a hard time getting past how ugly this is.  Passing callback=
s as
> > arguments to a registration function should be a last resort.  I would =
rather see
> > this added to the device mandatory list (and it *is* mandatory, we use =
it
> > without checking for NULL). =20
>=20
> Your correct I should have checked for NULL and returned an error if not =
supplied.
>=20
> > In truth, I'd rather see both of those moved to the
> > driver callback struct.  They can be placed at the end, after a comment=
 that
> > says something like "These are single use entry points for initializati=
on, keep
> > them away from the rest of the entry points to help prevent growing the=
 entry
> > point list beyond any more cachelines that needed for the more commonly
> > used entry points".  I would find that much preferable to this.
> >=20
>=20
> I'll change to this method in the next version.

Excellent.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-hQBKfyYHAEttjmt4gymo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUj5QAAoJELgmozMOVy/dNdYP/3bIsoXKA6SOiJPPsXc1e/RW
F6sCAaVgl10JSa8upj+rhQCa4UFhSjVTDeYeWwOsj1cvyT2s9fJ/OpGXlWAfL3hz
yZizov+XHfjtVYWwfU2V/GhYHO6jHJUTXNQoDzLMMj1Ue51D947T2iYR28DYKJM8
YLKeoL90WQfbDKWWT+CUK7YQT8kGG3rHJCT/BlhRkQ5YU/M0I5Td/PHnDlLfQj7c
D5ChmUmdA6kPo0XiHLzPJbZ8MQA3Hc1Ukk1rqUzZwjy8Qc48pi/hncOjWpKVrRIy
qWKmbN/4uhEsPEjSRzjBLjUGS32BAt1Ws6gy2/tcV3V1Bh54K0xQ23T6uc3KBjF1
LMNJYpTiuvL2Vpx0uTAXvzF5XuYJOXpG78CRF5niCE9yaO4p3Gz/O+tfO3R6tYN8
zA1xyTw/lBruknFasz2Ci1uJ59q4QWuL+whobp4BFsRU8skfMlknSNClOZqa7MZj
7HETt01P7nxiMo7ex3kP/IZyHniPrTZg0DbLDr5vnBIB/D36nsz8EGNqUFqFVnT+
QllDb9Q2LI4bXRKkcjkJWpBmw8GzK7uIBl98ACSDCZ/bw8/ggvOeLOTVSWRvgPtg
IHavalubsqbloKo8U+f+cUPn29IBXYQW/wNh1eO935T63Tje6eiPa1GRxi+U+77v
D+qaJ405DKE6DRwFCv7F
=4ObI
-----END PGP SIGNATURE-----

--=-hQBKfyYHAEttjmt4gymo--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
