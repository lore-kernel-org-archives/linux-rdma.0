From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 04 May 2015 13:38:31 -0400
Message-ID: <1430761111.2407.85.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1430750492.2407.9.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Cq3mlkt5gPCqWMWIcJ4O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCA17C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Cq3mlkt5gPCqWMWIcJ4O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-04 at 16:40 +0000, Hefty, Sean wrote:
> > > +/* Protocol                             0xFFFF000000000000 */
> > > +#define RDMA_CORE_CAP_PROT_IB		0x0001000000000000ULL
> > > +#define RDMA_CORE_CAP_PROT_IBOE		0x0002000000000000ULL
> > > +#define RDMA_CORE_CAP_PROT_IWARP	0x0004000000000000ULL
> > > +#define RDMA_CORE_CAP_PROT_USNIC_UDP	0x0008000000000000ULL
> >=20
> > In accordance with what we've been talking about, drop IBOE for ROCE.
> >=20
> > Drop the UDP off of USNIC, then define a bit for CAP_PROT_UDP_ENCAP.
> > USNIC will be just USNIC, USNIC_UDP will be USNIC | UDP_ENCAP, ROCE v1
> > will be ROCE, and ROCEv2 will be ROCE | UDP_ENCAP.
>=20
> USNIC_UDP is just UDP.  I don't understand why we would want 'USNIC | UDP=
_ENCAP', or what UDP_ENCAP is intended to convey.  Nothing is being encapsu=
lated.

I thought USNIC_UDP had an embedded USNIC protocol header inside the UDP
header.  That would make it a UDP_ENCAP protocol.

> RoCEv2 is IB transport over UDP.

Right, ROCE (or IB, whichever you prefer) encapsulated in UDP.

> I'm not sure what the protocol field is intended to imply.

There is still information in those bits that we can't get elsewhere.
For instance, even though this patch replaces the CAP_* stuff with bits,
if you took away the CAP_PROT_* entries, then there would be no entry to
identify USNIC at all.

Right now, you could infer iWARP from CAP_IW_CM.
You could infer InfiniBand from any of the CAP_IB_* (but later will need
a way to differentiate between IB and OPA)
You could infer ROCE from CAP_ETH_AH (but later will need a way to
differentiate between ROCE and ROCEv2)
The only way to differentiate USNIC at the moment, is that the CAPS
would be all 0.  That's not the sort of positive identification I would
prefer.

So you *could* reduce this to just one bit for USNIC.

And if you then add a UDP_ENCAP bit, then that single bit can do double
duty in telling apart USNIC and USNIC_UDP and ROCE and ROCEv2.

>   If we want
> to expose the link, network, transport, and RDMA protocols in use,
> shouldn't these be separate fields or bits?  And even then, I'm not
> sure what use this has for the ULPs.  iWarp does not require Ethernet
> or TCP.  RoCEv2 would work fine over any link.


>   And the core layer
> should not assume that a device is limited to supporting only one
> protocol, especially at the network and transport levels.

Given that this is a per port thing, there is no assumption about a
device only supporting a single protocol.

>   I vote for
> deprecating the protocol goofiness.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-Cq3mlkt5gPCqWMWIcJ4O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVR66XAAoJELgmozMOVy/d030P/1LDTeZdoPRa4QBx9ScLMtUP
0D79bp8W7/VOySXdnAMAjz19L/tkfjMhW30xnWfUgeRJIKno2lumLarucMH3ykzI
uh0xKREzkRHoD6velqr2K/wr+QtIZ0qPg+OnyUkMAmICDKb4JPzI/bCcUtAo6KZB
+Ioi8H2zABqG/E4K3tGEDF3cN5p8N/y/RZEUzjQHAJDgiX2RsSzQA6jNZXqGaDAt
Whi5lu4Qo4/IpSZME04uAhPkb9mGMzJjYUkNistLVW095v1vxigB5yRWaIcUmnzl
2UIy4JMNaETdVbgGlv96TQL1uoC3RbDgAOFZEtz87PitKR3KT9gEcOeFbTd0B7PV
zHkU0+ijiRge7mcnyTzoEEckbh/Zc1FXmZ9HyzQyEj3P2zLyZJ62Onn2BlZL+U78
tLSLPy+NM5vngAxSWmq7Z8me+a2mpWGI047MFz2F1WG+O8A6vIMv26IoN3flTMmq
seRZmfSq6DFWUg+8WAEONAkWQXGY+DHMtDAEII0UU5ulE29HvBGh7B0fYndzt4Lt
tPqZ8MrAnOfyjor5z9RHNSxydlxRh9cW4oVbRyaLxq6UnR3lihjeN5ltmwjljEGJ
m+zA8BsVUGJ5/S77djvH03a+IjYjbSlR2ZRHen0xmT0PWusXy8ICFS6wU9+SoBLb
WBIaq7c8JQHJUCPUlJyq
=EcwY
-----END PGP SIGNATURE-----

--=-Cq3mlkt5gPCqWMWIcJ4O--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
