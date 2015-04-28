From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Mon, 27 Apr 2015 21:24:35 -0400
Message-ID: <1430184275.44548.44.camel@redhat.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
		 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
		 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
		 <553DE799.5050608@profitbricks.com>
		 <20150427215229.GD5347@phlsvsds.ph.intel.com>
	 <553ED159.2090006@talpey.com> <1430181360.44548.35.camel@redhat.com>
	 <553EDA01.9040708@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-c1m5++FsxOiZrTmJr0Gk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <553EDA01.9040708-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-c1m5++FsxOiZrTmJr0Gk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-04-27 at 17:53 -0700, Tom Talpey wrote:
> On 4/27/2015 5:36 PM, Doug Ledford wrote:
> > On Mon, 2015-04-27 at 17:16 -0700, Tom Talpey wrote:
> >> On 4/27/2015 2:52 PM, ira.weiny wrote:
> >>> On Mon, Apr 27, 2015 at 09:39:05AM +0200, Michael Wang wrote:
> >>>> On 04/24/2015 05:12 PM, Liran Liss wrote:
> >>>>> [snip]
> >>>>
> >>>> Like:
> >>>>
> >>>> enum rdma_protocol {
> >>>> 	RDMA_PROTOCOL_IB,
> >>>> 	RDMA_PROTOCOL_IBOE,
> >>>> 	RDMA_PROTOCOL_IWARP,
> >>>> 	RDMA_PROTOCOL_USNIC_UDP
> >>>> };
> >>>>
> >>>> So we could use query_protocol() to ask device provide the protocol
> >>>> type, and there will be no mixing with the legacy transport type
> >>>> anymore :-)
> >>>
> >>> I'm ok with that.  I like introducing a unique namespace which is cle=
arly
> >>> different from the previous "transport" one.
> >>
> >> I agree the word "transport" takes things into the weeds.
> >>
> >> But on the topic of naming protocols, I've been wondering, is there
> >> some reason that "IBOE" is being used instead of "RoCE"?
> >
> > Because back in the day, when RoCE was accepted into the kernel, I'm
> > pretty sure it was prior to the IBTA's final stamp of approval and
> > before the name was set on RoCE, so IBoE was chosen upstream as the mor=
e
> > "correct" name because it properly denoted what it was deemed to truly
> > be: IB Verbs over Ethernet.
>=20
> Well history is all well and good, but it seems weird to not use the
> current, standard name in new code. It confuses me, anyway, because
> it seems like IBOE could easily mean something else.

Having some of it refer to things as IBOE and some as ROCE would be
similarly confusing, and switching existing IBOE usage to ROCE would
cause pain to people with out of tree drivers (Lustre is the main one I
know of).  There's not a good answer here.  There's only less sucky
ones.

> >> Also wondering, why add "UDP" to USNIC, is there a different USNIC?
> >
> > Yes, there are two transports, one a distinct ethertype and one that
> > encapsulates USNIC in UDP.
>=20
> But this new enum isn't about transport, it's about protocol. So is
> there one USNIC protocol, with a raw layering and a separate one with
> UDP? Or is it one USNIC protocol with two different framings? Seems
> there should be at least the USNIC protocol, without the _UDP
> decoration, and I don't see it in the enum.

Keep in mind that this enum was Liran's response to Michael's original
patch.  In the enum in Michael's patch, there was both USNIC and
USNIC_UDP.

> >
> >> Naming multiple layers together seems confusing and maybe in the end
> >> will create more code to deal with the differences. For example, what
> >> token will RoCEv2 take? RoCE_UDP, RoCE_v2 or ... ?
> >
> > Uncertain as of now.
>=20
> Ok, but it's imminent, right? What's the preference/guidance?

There is a patchset from Devesh Sharma at Emulex.  It added the RoCEv2
capability.  As I recall, it used a new flag added to the existing port
capabilities bitmask and notably did not modify either the node type or
link layer that are currently used to differentiate between the
different protocols.  That's from memory though, so I could be mistaken.

But that patchset was not written with this patchset in mind, and
merging the two may well change that.  In any case, there is a proposed
spec to follow, so for now that's the preference/guidance (unless this
rework means that we need to depart from the spec on internals for
implementation reasons).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-c1m5++FsxOiZrTmJr0Gk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVPuFTAAoJELgmozMOVy/d8GIP/ixqTvhn4RFBGDlyukSvOaz8
vSUv6IkQllnHo+gtRxlg8wgixpB/xiSq3FORyPI6jldA86d1bGNGB6jOGTgGqfRv
deTN7NNcXAu42XOS3dLIjuz3lGG8l0QwBrvS4fH2PCD48Ht0sj6ilK9vSyO34oq7
ugp5m70gUAsZmfNV6RvXH7DmcRIULOTVmXCcD2lWR62XuAsAcCaFThB568NXNDrq
oLlMfYXpfmy92Uqsd8G2d/kmqZKK6I2Hjf7s5esQHNUeF9hy3kJc8GfeG3YEQSxT
u5n7KyVtjO2g7eK9K1HMdpL3jqdYl6Ey7PbY5kpaGWAyhkDpXOTU4gbHRERbBBBn
SnYMpnEw1SsLooI5nnZEgTL8HuOjI85zvAvDY/dVwTy/UGeELH7vxmWjct8Zpc6Q
0vsfI6ZiaG46D0t3JnmTnX6KMYLnHEieAuLOI1ftNxRrXq96Ejfj3W68SOSl6xJS
f4ltZLak4n0D8sEmbN54bcRJO1noO9rXjCHIealYdKGrHDFVFjiGtizHcCQCsGjH
Y9oObW8FMkIFFV0ze1LY0fIfkIKWXg5Eer+M61cO8NaIT62l7/DglAn6MNioFUXv
MLd5gtKTXTCVP95B9t+8KUkuUVsOkdfEfbmy+bNWxXW/CqbM0wl7iS1BX1od2AEE
5uTQEBRnrjmyYYV9r6qj
=iAVA
-----END PGP SIGNATURE-----

--=-c1m5++FsxOiZrTmJr0Gk--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
