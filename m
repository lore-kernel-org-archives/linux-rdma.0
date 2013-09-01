From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Sun, 1 Sep 2013 16:23:04 -0600
Message-ID: <20130901222304.GB3422@obsidianresearch.com>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>
 <1377694075-29287-4-git-send-email-matanb@mellanox.com>
 <20130828162050.GA31381@obsidianresearch.com>
 <52230648.5000302@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52230648.5000302-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 01, 2013 at 12:18:00PM +0300, Matan Barak wrote:
> >How will user space know what comp_mask values the kernel will
> >support?
> 
> struct ib_uverbs_create_flow_resp contains a comp_mask value. This value
> should contain the supported comp_masks fields.
> Currently, we don't support any extensions, so we zero this field by
> doing "memset(&resp, 0, sizeof(resp));"
> 
> I suggest returning an error and setting the response comp_mask field.

But this is inconsistent. The comp_mask field should work the same in
both directions, so if you want to return an error then the kernel
should also never return a comp_mask that user space can't support.

All that is hard, which is why the approach for the verbs extensions
was that everyone always sets the maximum comp_mask they support, and
receivers ignore what they don't understand.

>> The notion that was established in the verbs patches is that extra
>> structure fields are ignored by old software.

> I'm not aware of any such concrete example. Could you please point
> out ?

It was established during the discussion, I guess I now need to check
that the proposed patches followed it.

> I think it's safer to return an error. Imagine that ibv_modify_qp
> was extended for some crucial field, say IB_QP_AV2. Creating a QP
> without indicating its AV (or AV2 in that case) is an invalid
> behavior. This example is a bit artificial, though some future
> extensions could have such mandatory fields.
> The user should do ibv_query_device before requesting features that
> might be unsupported.

No, you are mixing things. The comp_mask should only be used to
indicate the memory in the structure was initialized to something
valid (which might be a no-action initialization)

It should never be used to indicate that the receiver must do
something with the data.

Requesting a fictional AV2 must be done via some other means that has
a suitable failure mode, eg check the device caps before setting an
actionable value.

At least in uverbs the notion should be that comp_mask can be reset if
the soname was bumped.

Further, we shouldn't burden userspace with setting a 'correct'
comp_mask. That is a horrible ABI, at least a 3 on the 'Rusty Scale'.

The correct comp_mask should always match the fields that are
initialized by the caller. That is simple to explain and easy to audit
for correctness.

Anything else is too hard for users.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
