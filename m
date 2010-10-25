From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Mon, 25 Oct 2010 18:45:37 +0200
Message-ID: <AANLkTi=JRNYQXOrPNTkmUmfkxPEq+V2Ew7=wW8Ep7k3k@mail.gmail.com>
References: <20101024075835.GA11359@mtldesk30>
	<adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30>
	<adaocajo90s.fsf@cisco.com>
	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
	<4CC54D4E.7050203@Voltaire.com>
	<4CC5604D.2080803@Voltaire.com>
	<adaaam2jswk.fsf@cisco.com>
	<20101025161730.GA9335@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101025161730.GA9335@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 25, 2010 at 6:17 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wro=
te:
> On Mon, Oct 25, 2010 at 06:36:43AM -0700, Roland Dreier wrote:

>> I suspect I broke either the UD header packing or the build_mlx_head=
er
>> function when I "cleaned up" the patches. =A0I see the same problem,=
 I'll
>> take a look today.

> I think this will fix things up. The + operator has precedence over
> the ? operator so we end up with packet_length equal IB_GRH_BYTES / 4
> which is wrong.

Once you guys feel to have a fix I would be happy to give Roland's
for-next bits some further basic kernel (e.g IB link up/down, IPoIB,
running SM on a node with IBoE patches) testing and a bit of more
advanced (e.g IB/iSER, IB/RDS [Andy]) testing to see that things are
in place with L2 IB, I would recommend also the iWARP folks to do the
same as the addr/rdma-cm modules were also modified.

The merge window still has about 9 days, so we're okay with delaying
the push in 1-2 days, thoughts people?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
