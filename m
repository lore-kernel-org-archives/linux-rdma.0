From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: XRC Questions for Mellanox and All
Date: Wed, 20 Dec 2017 23:11:57 +0200
Message-ID: <20171220231157.00000e11@dev.mellanox.co.il>
References: <BN3PR07MB2578462C1760953F6D4690E2F8570@BN3PR07MB2578.namprd07.prod.outlook.com>
        <BN3PR07MB2578DE457E8E49E57CF49F17F82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578DE457E8E49E57CF49F17F82D0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 19 Nov 2017 12:02:10 +0000
"Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:


Hi Ram,
I apologize for the delay in responding.

The Linux XRC implementation does not provide XRC specific errors.
Rather, these errors are perceived as local access violation errors at
the responder. Consequently, at the responder side, for both XRCETH and
XRC domain violation errors, a local access violation asynchronous
error is reported (IB_EVENT_QP_ACCESS_ERR). The remote QP then
transitions to the ERR state.

At the requester side, these errors are perceived as Remote Invalid
Request errors, and generate IB_WC_REM_INV_REQ_ERR completions. The
local QP then transitions to the ERR state.

Operationally, then, the resources behave as they should upon XRC
errors.

On the responder side, XRC receive completions report the XRC_TGT_QP in
the =E2=80=9Cqp=E2=80=9D field of the ib_wc structure;  the XRC SRQ number =
is returned
in field =E2=80=9Csrc_qpn=E2=80=9D.

(The src_qp field was previously used only for UD qps; there was no
reason not to use it to return the XRC SRQ number, especially as doing
this meant no need to add a new field to struct ib_wc).

-Jack

> Hi Leon, Mellanox,
> Can you help get a comment on this e-mail?
>=20
> (Added Sean and Roland as by git log they seem related too)
>=20
> Thanks,
> Ram
>=20
>=20
> > -----Original Message-----
> > [This sender failed our fraud detection checks and may not be who
> > they appear to be. Learn about spoofing at
> > http://aka.ms/LearnAboutSpoofing]
> >=20
> > Hi Mellanox, All,
> > I've been reading XRC code, currently implemented only by Mellanox.
> > I have a few questions regarding specifications vs. implementation.
> >=20
> >  (1) The protocol specifies:
> > 11.6.3.2 AFFILIATED ASYNCHRONOUS ERRORS
> > ...
> > The following describes the new Affiliated Asynchronous Errors for
> > XRC TGT QPs:
> > * XRC Domain Violation - Responder's Receive Queue detected an
> > XRC Domain that does not match the XRC Domain of the XRC SRQ.
> > * Invalid XRCETH - Responder detected that the XRC SRQ does not
> > exist or is not in the right state or wire protocol violation.
> >=20
> > I don't see any dedicated entries in the enum ib_event_type.
> > Why? How, do you currently treat these errors?
> >=20
> > (2) The protocol specifies:
> > 11.4.2.1 POLL FOR COMPLETION
> > ...
> > Output Modifiers:
> > ...
> > * Local XRC TGT QP Number. Returned only for completions
> > of WRs posted to XRC SRQs.
> >=20
> > I don't see any dedicated field in the struct ib_wc.
> > Why? How, do you currently return this value, if at all?
> >=20
> > (3) The protocol specifies:
> > 11.4.2.1 POLL FOR COMPLETION
> > A new "XRC violation error" is returned for requests that caused
> > the responder to return a "NAK-Invalid RD Request" NAK. This could
> > have been caused by either a Remote XRC Domain Violation or an
> > XRCETH Violation as detailed in the transport section.
> >=20
> > What entry from the enum ib_wc_status do you use for this?
> >=20
> > Thanks,
> > Ram
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html =20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
