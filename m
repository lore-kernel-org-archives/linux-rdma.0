From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Wed, 10 Jun 2015 19:54:37 -0400
Message-ID: <1433980477.71666.57.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
	 <1433255724.114391.225.camel@redhat.com>
	 <20150602180844.GD17776@obsidianresearch.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com>
	 <20150604164759.GC27699@obsidianresearch.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE4F98@ORSMSX109.amr.corp.intel.com>
	 <alpine.DEB.2.11.1506060318570.29860@east.gentwo.org>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE5AB8@ORSMSX109.amr.corp.intel.com>
	 <alpine.DEB.2.11.1506092018190.6681@east.gentwo.org>
	 <5577F93F.9030405@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Xw6l7QBzqloDBS5dfqEZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5577F93F.9030405-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Xw6l7QBzqloDBS5dfqEZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 11:45 +0300, Or Gerlitz wrote:
> On 6/10/2015 4:26 AM, Christoph Lameter wrote:
> >> >I have no problem with a bare metal interface exposing this.  But pre=
tendin=3D
> >> >g that it's generic and that this is the one and only way that this c=
ould b=3D
> >> >e implemented doesn't make it so.
> > This is a way it was implemented and its usable. Shooting for pie in th=
e
> > sky does not bring us anything. Nor ideas of requirements from a new
> > experimental API that does not support the basic features that we need
> > and seems to be on its way to mess up the latencies of access to RDMA o=
perations.
>=20
> Doug,
>=20
> What's your maintainer say here?
>=20
> The current proposal has:
>=20
> 1. raw HCA clock completion generation time-stamp for CQEs
> 2. HCA clock frequency in KHZ
> 3. mask telling how many bits are relevant from the 64bit time-stamp
>=20
> This is fairly simple, practical and very much usable to FSI=20
> applications and users, and can be extended later if someone comes up=20
> with better/other combination of the frequency/mask. Have a GO?

This is all related to the kernel <-> libibverbs interface.  In that
regard, I'm fine with what we have here.

To be more specific, the CQ creation flags and use of create_cq_ex and
the extension of the query_device struct and use of extended query
device are really the only user visible items here, and I'm OK with
those.  None of these items are hot path items and structure growth with
new fields is not the major item it is for the wc struct.

Now, the change to the wc struct and the change to ibv_poll_cq are more
important and still need some work to get to a final implementation IMO.
But that work is all limited to libibverbs and doesn't impact this
kernel patchset.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-Xw6l7QBzqloDBS5dfqEZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeM49AAoJELgmozMOVy/d2g4P/0LB4ICCaFkWNXJC1Qrjy3/5
rB92FKaILk5GqoL96vdEfDFy5G694UI+Wjyl3dzK1Bj6b/a1JMWoKCTp2FmWoHDN
ELsfFkvS32mLTI0885O0t3Xmdc0Cnz2KK41qQJO8g+xg57Nd0gOEKGswLFwB1aHj
zInWPR7AsU+UDEZnoo1UK4u6hgCfjkiw4S+QkG5KXF+6wVtDxL3I/sfSv+kzAZ1J
PpVuJtmdCLoKKHsODENOIVABXeX+2w8Fk0Hm8f/UOdDsDuC3RcG2sKeueS1sMNX7
/B0n+XE2NqujlpKHI+7SV2tPosgsMsVs43SCcRdG5/I2XA59d7AE15UaXxOK1Uo7
jhHMeIL47q5f+ATqsNcQgGEzBbdr7z4QkTYj0apbVdUSQJNkCxEAPZZiz+scJjBd
m2PPPhg5CAxHgznsgt0S9RuxciL2jW379np+Fxoept5J8Om93JyKWEQW3ieK7MZo
slA+aspTVFVhRQ/Gc2guajTOYH9Qxq84k38uMrwNeHo6/nIr5Z06Q2h1cGQtsT+F
Y056JAZPNxyDDyHOZQiEUJV7EAZpTp+lrCSHWo4bCoc9fZDS+FnfwkDjFAKZ+u3B
V5qYKX6MtmQFKwAO+d/BcdwMMOPzvu9ouRykezYbU5qXp1uip9X1PecRe9V/+6x7
gUFGUNOTnRlMqBw7/OOc
=nalC
-----END PGP SIGNATURE-----

--=-Xw6l7QBzqloDBS5dfqEZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
