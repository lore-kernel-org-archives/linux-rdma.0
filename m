From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Wed, 16 Sep 2009 09:03:58 +0200
Message-ID: <e2e108260909160003n7d9170edl8289c6fce4f8225c@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>
	 <e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>
	 <f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>
	 <4AAFC42D.4030708@vlnb.net>
	 <f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>
	 <4AAFC794.7090205@vlnb.net>
	 <f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
	 <4AAFCA77.6050305@vlnb.net>
	 <f3177b9e0909151351p12173c78oe01cc8bcca957550@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909151351p12173c78oe01cc8bcca957550-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 15, 2009 at 10:51 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> In lots of testing today, I've seen this panic twice on the Ubuntu 8.=
10 targets:
>
> [ =A0330.155992] ib_srpt: disconnected session
> 0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
> been received.

The above message means that an initiator logged in, did not log out
and logged in again. Has one of the initiator systems e.g. been power
cycled while an SRP connection was active ?

> [ =A0357.207046] ib_srpt: srpt_xmit_response: tag=3D 17 channel in ba=
d state 2

This means that an attempt was made by SRPT to transmit a response for
a channel in the state 2 (disconnecting). This must be analyzed
further, just like the bug report triggered from
srpt_abort_scst_cmd().

[ ... ]

> [ =A0411.636699] WARNING: at /root/scst/srpt/src/ib_srpt.c:924
> srpt_abort_scst_cmd+0xac/0x160 [ib_srpt]()
> ...

This message has been triggered by the statement WARN_ON("unexpected
cmd state"). It must be analyzed whether this is a consequence of what
went wrong before or whether this is a separate issue.

[ ... ]

> This may have been due to low memory, as I was using most target
> memory for the ramdisk.

The kernel warning message in ib_srpt.c at line 924 should never be
triggered, not even under low memory circumstances. I'll have a look
at this anyway.

Thanks for the detailed report.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
