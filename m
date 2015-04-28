From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Mon, 27 Apr 2015 20:36:00 -0400
Message-ID: <1430181360.44548.35.camel@redhat.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
	 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
	 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
	 <553DE799.5050608@profitbricks.com>
	 <20150427215229.GD5347@phlsvsds.ph.intel.com> <553ED159.2090006@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-p4S23daWGYUhE/uibbqt"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <553ED159.2090006@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, Michael Wang <yun.wang@profitbricks.com>, Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-p4S23daWGYUhE/uibbqt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-04-27 at 17:16 -0700, Tom Talpey wrote:
> On 4/27/2015 2:52 PM, ira.weiny wrote:
> > On Mon, Apr 27, 2015 at 09:39:05AM +0200, Michael Wang wrote:
> >>
> >>
> >> On 04/24/2015 05:12 PM, Liran Liss wrote:
> >>>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> >>>>
> >>> [snip]
> >>>> a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
> >>>> 65994a1..d54f91e 100644
> >>>> --- a/include/rdma/ib_verbs.h
> >>>> +++ b/include/rdma/ib_verbs.h
> >>>> @@ -75,10 +75,13 @@ enum rdma_node_type {  };
> >>>>
> >>>>   enum rdma_transport_type {
> >>>> +	/* legacy for users */
> >>>>   	RDMA_TRANSPORT_IB,
> >>>>   	RDMA_TRANSPORT_IWARP,
> >>>>   	RDMA_TRANSPORT_USNIC,
> >>>> -	RDMA_TRANSPORT_USNIC_UDP
> >>>> +	RDMA_TRANSPORT_USNIC_UDP,
> >>>> +	/* new transport */
> >>>> +	RDMA_TRANSPORT_IBOE,
> >>>
> >>> Remove RDMA_TRANSPORT_IBOE - it is not a transport.
> >>> ROCE uses IBTA transport.
> >>>
> >>> If any code should test for ROCE should invoke a specific helper, e.g=
., rdma_protocol_iboe().
> >>> This is  what you currently call "rdma_tech_iboe" is patch 02/26.
> >>>
> >>> I think that pretty much everybody agrees that rdma_protocol_*() is a=
 better name than rdma_tech_*(), right?
> >>> So, let's change this.
> >>
> >> Sure, sounds reasonable now, about the IBOE, we still need it to
> >> separate the port support IB/ETH without the check on link-layer,
> >> So what about a new enum on protocol type?
> >>
> >> Like:
> >>
> >> enum rdma_protocol {
> >> 	RDMA_PROTOCOL_IB,
> >> 	RDMA_PROTOCOL_IBOE,
> >> 	RDMA_PROTOCOL_IWARP,
> >> 	RDMA_PROTOCOL_USNIC_UDP
> >> };
> >>
> >> So we could use query_protocol() to ask device provide the protocol
> >> type, and there will be no mixing with the legacy transport type
> >> anymore :-)
> >
> > I'm ok with that.  I like introducing a unique namespace which is clear=
ly
> > different from the previous "transport" one.
>=20
> I agree the word "transport" takes things into the weeds.
>=20
> But on the topic of naming protocols, I've been wondering, is there
> some reason that "IBOE" is being used instead of "RoCE"?

Because back in the day, when RoCE was accepted into the kernel, I'm
pretty sure it was prior to the IBTA's final stamp of approval and
before the name was set on RoCE, so IBoE was chosen upstream as the more
"correct" name because it properly denoted what it was deemed to truly
be: IB Verbs over Ethernet.

>  The IBOE
> protocol used to exist and is not the same as the currently
> standardized RoCE, right?

I don't believe so.  To my knowledge, there was never an IBoE except in
linux upstream parlance.

> Also wondering, why add "UDP" to USNIC, is there a different USNIC?

Yes, there are two transports, one a distinct ethertype and one that
encapsulates USNIC in UDP.

> Naming multiple layers together seems confusing and maybe in the end
> will create more code to deal with the differences. For example, what
> token will RoCEv2 take? RoCE_UDP, RoCE_v2 or ... ?

Uncertain as of now.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-p4S23daWGYUhE/uibbqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVPtXwAAoJELgmozMOVy/dHOAP/RMTrrIU7DrSxE6bi89yrEYr
VqDVTnfrsvE8PKDysIHvts8YsriSeHvNJJ4Lijs8zi6Tu2CaHInhsfWB6B8HWHWf
lpDpzCUX9zSWGQ+ETJ9XMQvHmJGDYu+5qr6i7s67Xg4gm1g9wUxsasMIgswj3tk/
ZEQprCjcUHa2WRTpW1J+QixjkMhe2v71R3WA7dpL3fT9Rg8WjBOKtv0sZmNP4NCU
5KA9wF1aUDMGzHJ06qJwfewaUKR45QZY3+XSscksc/UR0OMkfHq+PuDMXTONzMh9
5Q7GiCJwsH+8q+fECXUmOzXOIQ0kCeprzXJRoufISFCyrOTk/Fwy2k4gbMW1U1LH
DkHT+eeSzBtErcxmArgKYya9PTGBFVwnm7mD3qejyGRtOD+KiN1GbypgIFXzU1j4
iZZTJVMilguKXUFIb1HLLmbHcs515q1/1Ux33GOmTZXdyTomi4qGs1a4ZGye6yYK
7miQCf/Z842bKTWAL59qnDx92iYth89R+izSi546/SUo+HOEQCEFfMLddzMkBP5R
w0DRSu6udRVcf5MSawf4eRnBcUFmJINwb0IL38uEDzUjfq5An3ispTO1kR/CydNV
0cD1gtgUrHwtTih1rwFtw6jAGVW93YGW5Vcuago6ngzC1F8D/rV2ZKI4fGiCctlQ
NMVzjxbMw36Rm/TcbGfq
=OITy
-----END PGP SIGNATURE-----

--=-p4S23daWGYUhE/uibbqt--
