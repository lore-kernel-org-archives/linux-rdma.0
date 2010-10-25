From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Mon, 25 Oct 2010 21:15:11 +0200
Message-ID: <AANLkTi=yZUoexwVUCfbeGypEWC_8=oZaMu9mBTF+VJgq@mail.gmail.com>
References: <20101024075835.GA11359@mtldesk30>
	<adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30>
	<adaocajo90s.fsf@cisco.com>
	<AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
	<4CC54D4E.7050203@Voltaire.com>
	<20101025113452.GB1802@mtldesk30>
	<AANLkTi=ZxB4b463OOS6YGxTJSKxjyCj8vy0rNtj0n+uA@mail.gmail.com>
	<20101025143603.GD1802@mtldesk30>
	<AANLkTimaEcFZMnYE+G3osTWzPkfxuBpRMtrrXF7xUPYv@mail.gmail.com>
	<20101025171332.GA2332@mtldesk30>
	<AANLkTik_4OzMLMWXud89m_rF47OQ3Wji9R_Bye+0DcTV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik_4OzMLMWXud89m_rF47OQ3Wji9R_Bye+0DcTV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

First, I suggest that you sync your tree again.
Second, I assume your link layer is IB since Ethernet will show either
Down or Active so I think you should be fine after syncing.
If that does not answer you, please don't spare words to explain what
is the problem that you're seeing.

On Mon, Oct 25, 2010 at 9:04 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 25, 2010 at 7:13 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On Mon, Oct 25, 2010 at 06:46:39PM +0200, Or Gerlitz wrote:
>>> No, I didn't have IB Link when I used the for-next bits
>> Can you summarize what is the problem that you're seeing?
>
> Eli, this is pretty simple, I do the following
> 1. pull/build/boot Roland's for-next
> 2. modprobe mlx4_ib
> --> the port state is INIT forever, is that clear?
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
