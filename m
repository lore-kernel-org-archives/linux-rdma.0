From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Wed, 25 Feb 2015 12:13:58 -0500
Message-ID: <1424884438.4847.91.camel@redhat.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
	 <1423092585-26692-15-git-send-email-ira.weiny@intel.com>
	 <54D52589.8020305@dev.mellanox.co.il>
	 <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com>
	 <54DCB1E9.7010309@dev.mellanox.co.il>
	 <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>
	 <54EB7756.7070407@dev.mellanox.co.il>
	 <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NwcVOHn1iaPAsOq7kVXw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-NwcVOHn1iaPAsOq7kVXw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-02-25 at 00:29 +0000, Weiny, Ira wrote:
> > >>>
> > >>> Do you have a suggestion for alternatives?
> > >>
> > >> The desire to leverage the IB MAD infrastructure for OPA is
> > >> understood but the current approach represents OPA as a device
> > >> capability which does not seem appropriate because OPA is clearly a
> > >> different type of RDMA technology than IB.
> > >>
> > >
> > > While it is a different type of technology, standard verbs[*] remains=
 100%
> > compatible.  Unlike other verbs technologies user space software does n=
ot need
> > any knowledge that the underlying device is not IB.  For example, PR (a=
nd SA)
> > queries, CM, rdmacm, and verbs calls themselves are all 100% IB compati=
ble.
> >=20
> > Even if OPA is 100% standard verbs compatible which it does not appear =
to be,
> > that does not make OPA an extra capability of an IBA device.
>=20
> I don't want to make it an extra capability of an IBA device.  I want to =
make it an extra capability of a "verbs" device.

And this, friends, is why it's bad to make both a link layer and an user
space API with the exact same name ;-).  Anyway, I get your point Ira
and it makes sense to me.  However, I also get Hal's point.  Our track
record on this particular issue is a bit wonky though.

First we had InfiniBand.

Then came iWARP, and we used the transport type to differentiate it from
an actual InfiniBand device, but left the underlying link layer listed
as InfiniBand.  Then came RoCE, and we listed its transport type as
InfiniBand, but changed the link layer to Ethernet.  Which left us in
the oxymoronic position that even though iWARP was over Ethernet, the
tools said it was over InfiniBand, while RoCE was the only thing that
listed Ethernet as the link layer.  We later fixed that up with some
hacks in tools to keep users from being confused and filing bugs.

Maybe this represents an opportunity to straighten some of this mess
out.  If I remember correctly, this is the matrix of technologies today:

Technology	LinkLayer	Transport

InfiniBand	InfiniBand	InfiniBand Verbs
iWARP		InfiniBand	iWARP Verbs (subset of IBV, with
				specific connection establishment
				requirements that don't exist with IBV)
RoCE		Ethernet	InfiniBand Verbs (but with different
				addressing because of the different
				link layer)
OPA		?		InfiniBand Verbs

It makes me wonder if we shouldn't make this matrix more accurate:

Technology	LinkLayer	Transport

InfiniBand	InfiniBand	InfiniBand Verbs
iWARP		Ethernet	iWARP Verbs
RoCE		Ethernet	RoCE-v1 or RoCE-v2
OPA		?		OPA Verbs

With this sort of setup, the core ib_mad/ib_umad code would simply check
the verbs type to see what support it can enable.  For IBV it would be
the existing support, for OPAV it would be the additional jumbo support.

I'm not sure how much we might expect a change like this to break
existing software though, so maybe staightening this mess out is a
non-starter.

> > While it is a primary goal of the RDMA stack to have a common verbs API=
 for
> > various RDMA interconnects, each one is properly represented to allow i=
t's
> > unique characteristics to be exposed.
>=20
> The difference here is that we have maintained IB Verbs compatibility whe=
re other RDMA technologies did not.  We have tested many Verbs applications=
 (both kernel and user space) and they function _without_ _modification_.
>=20
> Despite this compatibility we are still having this discussion.
>=20
> I can think of no other way to signal the MAD capability to the MAD stack=
 which will preserve the verbs compatibility in the same way.

See above.  Define a new transport type, OPAVerbs, that is a superset of
IBV and enable jumbo support when OPAV is the transport on the link.

> >=20
> > > Therefore, to address your initial question regarding tradeoffs I bel=
ieve this
> > method is the least invasive to the code as well as removing any potent=
ial
> > performance penalties to core verbs.
> > >
> > > Ira
> > >
> > > [*] We don't support some of the extensions particularly those which =
have
> > been most recently introduced.  And we would like to make our own exten=
sions
> > in the form of higher MTU availability, but the patch is not yet ready =
to be
> > submitted upstream.
> >=20
> > There appear to be a number of things that are not exposed by the curre=
nt
> > patch set which will be needed in subsequent patches. It would be bette=
r to see
> > the complete picture so it can be reviewed as a whole.
>=20
> Is there something in particular you would like to see?  There are no oth=
er patches required in the core modules for verbs applications to function.=
  The MTU patch only improves verbs performance.
>=20
> Ira=20
>=20
> >=20
> > -- Hal
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n the body
> > of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-NwcVOHn1iaPAsOq7kVXw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU7gLWAAoJELgmozMOVy/d54IP/jp7xYYbPUY2QmuNmLyrV0r6
ACixoj0ewXiL+wpte6rqPTAmwH1ECzpXtpgZm1k9dn651Mdm+I9NpOLZFyk8CfPt
CQYu67WO++KupRCzVP+RjXYTYFuszhKAfXWGkglMa8Oca61WjKur9qSKi4SMoqXJ
+qA8guFM85UI6lkaf5aJOmm65lGvKqgXaw00uSMdRPilTBT53umLAVfcDCLDlvbx
KeXaDJV9iwdsdcGzeoaDm5K76f4YxYRJjVE7j+F9mSJaYWYn4r5Tvfhlnkt9Uev/
TFGykiLtuqgRnKzR6QQ2WGzZB59jimt5J+RvDwv7oJ8SgOlgsJxP+jkkR2iqeG5g
EPLp3KYWjMVI25pVIVVt7o3h6ZuyayLFMlQdmhFktHduXEXbtZuOE7crqEZfE8H6
vMwZ7EYcVONjASXtK0z3jFdv8ZQrzNzjxDHbHGD/gqTD09isfujau1idlzoE9vVl
b1cgmHkmR3lNgXxwmqG3bXRA53KZmKiygajz/BjLjkGx6LkrlZ3CIyR2OWFU5l69
1mtNlu22Nq+JFniyDvXjy0nB8mK3JcNvalIFifpjklov8nC/etAAIBxiNr8NTJCY
j9OV5i8cTe9ON2fKFFKciLzoo5A9I6Wl1Y0kLz/EQ9EzZLZUtCjxj2ablhmZpyWH
jDg/oUxwwb7aB1iKYn/5
=DT2d
-----END PGP SIGNATURE-----

--=-NwcVOHn1iaPAsOq7kVXw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
