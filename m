From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Fri, 08 May 2015 23:32:08 -0400
Message-ID: <1431142328.2407.488.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1430750492.2407.9.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
	 <1430761111.2407.85.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
	 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
	 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-yn4JHrmlHlONUismra3s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20BA79B2-9DA5-49B3-8455-BD4021CB882C-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-yn4JHrmlHlONUismra3s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 20:22 +0000, Dave Goodell (dgoodell) wrote:
> On May 5, 2015, at 2:51 PM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> >=20
> >>> I thought USNIC_UDP had an embedded USNIC protocol header inside the
> >>> UDP header.  That would make it a UDP_ENCAP protocol.
> >>=20
> >> Someone from Cisco can correct me, but USNIC supports 2 protocols.  Ju=
st
> >> plain UDP, and a proprietary protocol that runs over Ethernet, but use=
s the
> >> same EtherType as RoCE.  I thought these could both be active on the s=
ame
> >> port at the same time.
> >>=20
> >=20
> > 'protocol' refers to what your device generates when you do a post_send=
() on=20
> > some QP.
> > In the RoCE case, it is IBTA transport headers + payload over UDP encap=
sulation
> > over IP. In the USNIC case, you might want the protocol to refer to add=
ition
> > information the distinguishes this wire protocol rather than just "I am=
 sending
> > UDP packets"...
>=20
> In the case that usNIC is operating in UDP mode (which is the
> overwhelming majority of the cases), there is absolutely no additional
> protocol that ends up on the wire or headers in the user buffers
> besides UDP/IP/Ethernet.  They are 100% plain UDP packets, they just
> happen to be sent via OS-bypass queues instead of traveling through the
> kernel networking stack. =20
>=20
> [^^^^^ there continues to be confusion about this for some reason, but
> I don't know why]

I really need to just sit down and read your driver front to back.  The
confusion probably comes from people (such as myself) that first think
about this and go "Well, if you have multiple queue pairs, and UDP, then
you need a header to tell what QP a packet goes to" (which assumes a
RoCE like usage of UDP where all packets go to the same UDP address)
where your actual usage is probably more iWARP like in that the IP/UDP
SRC/DST combo maps to a specific QP, right?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-yn4JHrmlHlONUismra3s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVTX+4AAoJELgmozMOVy/dQ3wP/RzBKi4c2W5ndHz5+TarbopO
7cohILcPKDzsSdpYic7GlliDKy0LUfRzTkGNYBlyX3yWryyoMBj5ZPoktfWcMd45
yIqU7fNOQJHfyEH5EZHK7SBiB5zG1KfmfMCcX54rlfuMSOkYELeQc2txMkUliVCt
Lmq1UzPWoddkz3igmKjvOS0gQlrZmx7H8OGlXyZFFGU1X5RoYlSiUQsZdnM9X8zK
91SQOMuZnRq1N6ozMgR+Oi9plNNoGCBnnmsoVFpMUGyiIQ7rw67vfhqPWltpMEp6
eE5epohTnNjpGfKGf0kBa2soh0L6sQTj65l0ItLTHyFPyvPQAuSQ8qlaRKKnu/7V
c4SNlTNPgZBXwS4x5AUxNQG11fCBaOpBBcjqOGciCZMlzyajdFIpOAMisD58jCME
zYf/9wwIGSC3LWwpGAPjoTb/NVornCYPXDkqGDGGy7za7wNgVopZ6IJYqtutzP1P
uusnmU4v2xMtALO9bUb0t3kkBc3tQZVrbOHgYSujEQ/yqEJFpj5APCksZ9wADCCx
5Q7aH2PbkCOkjYiOZ3Nb02DQBw/gHgxsVw50h/XOvuMbo+7fKQKCTsaKwQpuRuhf
xbgZUuQX39/fOPB8Fqf5fEgftqwEb5dGozjmSdU+IY2f2ZED+GJ4z+w82zJAZqtw
CxArD9t6XaIirpqsv1H/
=QWzw
-----END PGP SIGNATURE-----

--=-yn4JHrmlHlONUismra3s--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
