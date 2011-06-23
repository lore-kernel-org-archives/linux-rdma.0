From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Thu, 23 Jun 2011 09:35:07 +0300
Message-ID: <201106230935.07425.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201106222221.05993.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373029BDE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373029BDE-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday 22 June 2011 22:57, Hefty, Sean wrote:
> > > We can report the creation of a tgt qp on an xrcd as an async eve=
nt.
> > To whom?
>=20
> to all users of the xrcd. =A0IMO, if we require undefined, out of ban=
d communication to use
> XRC, then we have an incomplete solution. =A0It's just too bad that w=
e can't report additional
> data (like the tgt qpn) with an async event... =20
>=20
I do not think this will help much.  Just knowing that a TGT QP exists =
is not really relevant.  The sender (who is on a remote host)
needs to know about the TGT QP, to use it to send to the XRC SRQs. We c=
annot propagate an event over to the sender side!  The local users
of the TGT QP don't really care -- it is the responsibility of the Appl=
ication to get the INI-TGT linkage up, and the XRC SRQs created before
sending from INI to SRQ.  At that point, the SRQ either receives packet=
s or it does not.

I do agree, though, that the need to use out-of-band communication (rat=
her than the CM) to establish the INI-TGT RC connection is not clean.

If you are thinking of using this for tracking, there is no way that I =
can see except reference counting to know when all users of the TGT hav=
e
finished with it.  Indicating usage by "tapping" the TGT QP whenever an=
 SRQ receives a packet via the TGT is not a good idea (this is data
path!), not to mention that quiescence is not a good indicator of wheth=
er an app is done using the target (the amount of time that things
are quiet depends on the app).

We discussed using a "heartbeat" in the thread link I sent you, and ult=
imately discarded that idea.

If you have other ideas which you think might work, please send them al=
ong.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
