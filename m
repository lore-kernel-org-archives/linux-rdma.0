From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: XRC Questions for Mellanox and All
Date: Sun, 19 Nov 2017 12:02:10 +0000
Message-ID: <BN3PR07MB2578DE457E8E49E57CF49F17F82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <BN3PR07MB2578462C1760953F6D4690E2F8570@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578462C1760953F6D4690E2F8570-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon, Mellanox,
Can you help get a comment on this e-mail?

(Added Sean and Roland as by git log they seem related too)

Thanks,
Ram


> -----Original Message-----
> [This sender failed our fraud detection checks and may not be who they ap=
pear to be. Learn about spoofing at
> http://aka.ms/LearnAboutSpoofing]
>=20
> Hi Mellanox, All,
> I've been reading XRC code, currently implemented only by Mellanox.
> I have a few questions regarding specifications vs. implementation.
>=20
>  (1) The protocol specifies:
> 11.6.3.2 AFFILIATED ASYNCHRONOUS ERRORS
> ...
> The following describes the new Affiliated Asynchronous Errors for
> XRC TGT QPs:
> * XRC Domain Violation - Responder's Receive Queue detected an
> XRC Domain that does not match the XRC Domain of the XRC SRQ.
> * Invalid XRCETH - Responder detected that the XRC SRQ does not
> exist or is not in the right state or wire protocol violation.
>=20
> I don't see any dedicated entries in the enum ib_event_type.
> Why? How, do you currently treat these errors?
>=20
> (2) The protocol specifies:
> 11.4.2.1 POLL FOR COMPLETION
> ...
> Output Modifiers:
> ...
> * Local XRC TGT QP Number. Returned only for completions
> of WRs posted to XRC SRQs.
>=20
> I don't see any dedicated field in the struct ib_wc.
> Why? How, do you currently return this value, if at all?
>=20
> (3) The protocol specifies:
> 11.4.2.1 POLL FOR COMPLETION
> A new "XRC violation error" is returned for requests that caused the resp=
onder
> to return a "NAK-Invalid RD Request" NAK. This could have been
> caused by either a Remote XRC Domain Violation or an XRCETH Violation
> as detailed in the transport section.
>=20
> What entry from the enum ib_wc_status do you use for this?
>=20
> Thanks,
> Ram
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
