From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Mon, 2 Sep 2013 22:16:36 -0600
Message-ID: <20130903041636.GA3875@obsidianresearch.com>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>
 <1377694075-29287-4-git-send-email-matanb@mellanox.com>
 <20130828162050.GA31381@obsidianresearch.com>
 <52230648.5000302@mellanox.com>
 <20130901222304.GB3422@obsidianresearch.com>
 <522459AE.9070107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <522459AE.9070107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 02, 2013 at 12:26:06PM +0300, Matan Barak wrote:

> >The correct comp_mask should always match the fields that are
> >initialized by the caller. That is simple to explain and easy to audit
> >for correctness.

> I agree, but the request could be rejected if an unsupported
> comp_mask field was given. The user should query the device

No, that is the exact opposite of what I said.

You are trying to make comp_mask indicate if the command should use
the data, I only want the comp_mask to indicate that the data has been
initialized (all new members must have a no-action value), they are
completely different things.

We already have commands that don't touch every member of an input
structure depending on context. eg commands acting on a UD QP don't
touch fields that are used only by RC QPs.

> capabilities, see if the feature he wants is supported and set the
> fields accordingly. It's simple, it's like every other stack and
> it's robust.

It is certainly not robust. You are relying on userspace to set the
correct value for the kernel version being used, and there is no way
for developers to test this because the latest kernel will accept all
values in comp_mask.

That is horrible. Our carefully designed ABI compatability is worth
nothing in practice if commands return EINVAL on old kerenls!

Old and new kernels must behave consistently.

The way to handle comp_mask is to have new kernels *VALIDATE* and old
kernels ignore. New kernels will require a *no action* value in all
situations where the feature is not supported (eg an older HCA,
feature not enabled, feature not present in device caps, etc).

This way the new kernel runtime tests the input, in a manner that is
consistent with the handling of old kernels (old kernel treat
unsupported members as no-action). Testing your app on a new
kernel, with a HCA that does not support the feature is sufficent to
show that it will work on past kernels that do not support the
feature.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
