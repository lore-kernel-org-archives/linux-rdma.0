From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is disabled
Date: Tue, 17 May 2016 08:31:53 +0300
Message-ID: <CAJ3xEMjDRzRc6h1NHXp9Xp004bBm95Fgf9oaEr04vY34AahmTg@mail.gmail.com>
References: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
	<f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88@redhat.com>
	<d6b3c895-6af0-33b7-79c5-f932243e7c48@mellanox.com>
	<6a25dc81-503e-15b4-58a2-66e1cb6a16f1@redhat.com>
	<CAJ3xEMinuAUeb2EzGBwR7fxE6+cLMxJ1WQnfM1GQ03D_-kQYZA@mail.gmail.com>
	<18402022-8a88-f166-d813-10df90e16662@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <18402022-8a88-f166-d813-10df90e16662-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 17, 2016 at 4:01 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/16/2016 05:03 PM, Or Gerlitz wrote:

>> To answer your questions: YES there is a way, namely
>> RDMA_CORE_CAP_PROT_ROCE and RDMA_CORE_PORT_IBA_ROCE - under this
>> patch, when RoCE isn't supported we do create the device but not
>> advertizing these caps.

> I wasn't referring to the kernel.  I was referring to a user space
> application.  There is currently no way for a user space app to tell the
> difference between this and a full RoCE device until they try to create
> something other than a raw Eth QP and it fails.

And how a general purpose user-space app should be realizing that UD isn't
supported by the iWARP drivers and RC isn't supported by the Cisco driver?

c4iw_create_qp -->
 if (attrs->qp_type != IB_QPT_RC)
                return ERR_PTR(-EINVAL);

usnic_ib_create_qp -->
if (init_attr->qp_type != IB_QPT_UD)
                return ERR_PTR(-EINVAL);

We need to fix mlx5 to work over a port not supporting RoCE, this patch does
that, in a manner which puts it ~in par with other vendors/transports
limitation.

If you really want, we can add such -EINVAL-ing when RoCE isn't supported
when the user attempts to create IBTA QP types (UC/RD/RC/etc)


>>> OK, so you want a plain Ethernet device with QPs as a means of enabling
>>> RDMA for Ethernet, but without the full blown Verbs support, just direct
>>> data placement in memory.  That's a reasonable thing to want to do.
>>> However, I'm not sure I agree with the implementation here.  It seems
>>> very hackish.  This setup probably deserves its own type setting in the
>>> RDMA stack to differentiate it (aka, InfiniBand, OPA, RoCE, iWARP,
>>> USNIC, Ethernet + QPs).

>> Why? we should be doing things for a reason. There's no entity I know
>> of in the stack which needs to be operative and is not b/c that new
>> type you're suggesting was not defined.

> The reason is to properly support this as a valid device type.  Not full
> RDMA, but still with direct data placement in user memory.  That has
> value, I'm thinking it should be properly represented.

Again, going with you, say we add that CAP, I didn't find a single place
in the kernel IB stack to where it would be used, please suggest a use-case!

I/F code which don't have consumer is not upstreamable. BTW, AFAIR.,we have
some little code like that from the early days for some IB switch HW
drivers which
are not upstream, and whenever we get there this is PITA to change/maintain.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
