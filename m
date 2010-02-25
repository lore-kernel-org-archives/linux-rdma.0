From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: link width question / opensm
Date: Thu, 25 Feb 2010 18:01:07 -0500
Message-ID: <f0e08f231002251501m74cb87c6sc1190ae9241f98e7@mail.gmail.com>
References: <20100225063905.GA4690@X300.wifi.conference.usenix.org>
	 <f0e08f231002250645u1a728u60e6269921affac8@mail.gmail.com>
	 <20100225193721.GB15303@X300.wifi.conference.usenix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100225193721.GB15303-XsFsJpinAmpgDlDR3U7vgBiktiNgz6Q3On3nfQqNrRM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dries Kimpe <dkimpe-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 25, 2010 at 2:37 PM, Dries Kimpe <dkimpe-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org> wrote=
:
>
> * Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> [2010-02-25 09:45:04]:
>
>> The link won't renegotiate automatically. The link needs to be reset
>> after updating the speed/width enabled values. Was that done ?
>
> I assumed OpenSM was resetting the link. Are you saying I need to run
> ibportstate reset in addition to running a modified opensm?

Yes.

> (Or, using only ibportstate using ibportstate speed followed by a
> ibportstate reset?)

That's another alternative (to using the modified opensm to change the
speed/width.

>> > - Is there another way to get what I want (control over link width=
+speed)?
>
>> The latest ibportstate can do this.
>
> I installed the latest version, and it indeed has width and speed.
> However, it doesn't seem to have any effect:
>
>
> [dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 query
> PortInfo:
> # Port info: Lid 232 port 1
> LinkState:.......................Active
> PhysLinkState:...................LinkUp
> LinkWidthSupported:..............1X or 4X
> LinkWidthEnabled:................1X or 4X
> LinkWidthActive:.................4X
> LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
> LinkSpeedEnabled:................2.5 Gbps or 5.0 Gbps or 10.0 Gbps
> LinkSpeedActive:.................10.0 Gbps
>
> [dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 speed 1
> Initial PortInfo:
> # Port info: Lid 232 port 1
> LinkSpeedEnabled:................2.5 Gbps or 5.0 Gbps or 10.0 Gbps
>
> After PortInfo set:
> # Port info: Lid 232 port 1
> LinkSpeedEnabled:................2.5 Gbps
> [dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 query
> PortInfo:
> # Port info: Lid 232 port 1
> LinkState:.......................Active
> PhysLinkState:...................LinkUp
> LinkWidthSupported:..............1X or 4X
> LinkWidthEnabled:................1X or 4X
> LinkWidthActive:.................4X
> LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
> LinkSpeedEnabled:................2.5 Gbps
> LinkSpeedActive:.................10.0 Gbps
>
> [dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 reset
> ibportstate: iberror: failed: smp query nodeinfo: Node type not switc=
h

You need to reset the peer switch port to get the link to renegotiate.
Hopefully then you'll see the correct values for active.

-- Hal

> =C2=A0Thanks,
> =C2=A0Dries
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
