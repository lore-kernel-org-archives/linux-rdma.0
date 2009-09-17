From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Thu, 17 Sep 2009 12:22:11 +0200
Message-ID: <e2e108260909170322t3f053fb3yc37e6df7900ce70@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>
	 <4AAFC42D.4030708@vlnb.net>
	 <f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>
	 <4AAFC794.7090205@vlnb.net>
	 <f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
	 <4AAFCA77.6050305@vlnb.net>
	 <f3177b9e0909151351p12173c78oe01cc8bcca957550@mail.gmail.com>
	 <4AB12B40.9050902@vlnb.net>
	 <f3177b9e0909161241h89dabdbybaf98edc5b10f735@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909161241h89dabdbybaf98edc5b10f735-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 16, 2009 at 9:41 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>
> On Wed, Sep 16, 2009 at 12:15 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org=
> wrote:
> > Chris Worley, on 09/16/2009 12:51 AM wrote:
> > >
> > > On Tue, Sep 15, 2009 at 11:10 AM, Vladislav Bolkhovitin <vst@vlnb=
=2Enet>
> > > wrote:
> > > [ ... ]
> > > [ =A0357.250550] ib_srpt: srpt_xmit_response: tag=3D 38 channel i=
n bad state 2
> > > [ =A0357.250553] scst: ***ERROR***: Target driver ib_srpt
> > > xmit_response() returned fatal error
> >
> > It's because srpt called scst_tgt_cmd_done() when the corresponding=
 command
> > hasn't yet been sent to xmit_response() callback, so srpt should us=
e another
> > function to abort commands in this state.
>
> Could this be related to the hang (i.e. the command has been aborted
> before xmit_response has been called... but w/o causing a panic)?

When analyzing such logs it's important to distinguish between cause
and consequence. What happened first is that the OFED SRP initiator
noticed that something went wrong with the IB communication, as
indicated by the log message "srp_qp_in_err_timer called". This means
that an error occurred in the IB network or in one of the two IB
stacks. This resulted in the SRP initiator trying to relogin without
intervening logout. The error messages logged by SRPT are a
consequence of the initiator relogin. While the SRPT issue will be
fixed, such a fix won't solve the slow reads and the hang you
observed.

Regarding the SRP communication problems you observed: since my
attempts to reproduce this issue have been unsuccessful so far, I'm
afraid these communication problems are caused by some component in
your IB network that is not working as reliable as it should.

By the way, the description of the patch that generated the message
"srp_qp_in_err_timer called" is interesting. The patch description
indicates that the condition "srp_qp_in_err_timer called" should only
happen during multipath failover. See also
http://www.mail-archive.com/ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg01959.html
(which is not the latest version of this patch).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
