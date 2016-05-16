From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is disabled
Date: Tue, 17 May 2016 00:03:24 +0300
Message-ID: <CAJ3xEMinuAUeb2EzGBwR7fxE6+cLMxJ1WQnfM1GQ03D_-kQYZA@mail.gmail.com>
References: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
	<f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88@redhat.com>
	<d6b3c895-6af0-33b7-79c5-f932243e7c48@mellanox.com>
	<6a25dc81-503e-15b4-58a2-66e1cb6a16f1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6a25dc81-503e-15b4-58a2-66e1cb6a16f1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 7:46 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/16/2016 12:31 PM, Matan Barak (External) wrote:
>> On 16/05/2016 18:14, Doug Ledford wrote:
>>> On 05/15/2016 08:57 AM, Or Gerlitz wrote:

>>>> On some environments, such as certain SRIOV VF configurations, RoCE is
>>>> not supported for an Ethernet port. Currently, the driver will not
>>>> open IB device on that port.
>>>> This is problematic, since we do want user-space RAW Ethernet
>>>> (RAW_PACKET QPs) functionality to remain in place. For that end,
>>>> enhance the relevant
>>>> driver flows such that we do create a device instance in that case.

>>> So this device is still going to present itself as a uverbs# device and
>>> libibverbs is still going to try and access it, but when it comes time
>>> for user applications to try and use it they will simply fail all QP
>>> types except for RAW?  Is there no way to distinguish between a device
>>> with RoCE enabled and without?

Doug,

To answer your questions: YES there is a way, namely
RDMA_CORE_CAP_PROT_ROCE and RDMA_CORE_PORT_IBA_ROCE - under this
patch, when RoCE isn't supported we do create the device but not
advertizing these caps.

> OK, so you want a plain Ethernet device with QPs as a means of enabling
> RDMA for Ethernet, but without the full blown Verbs support, just direct
> data placement in memory.  That's a reasonable thing to want to do.
> However, I'm not sure I agree with the implementation here.  It seems
> very hackish.  This setup probably deserves its own type setting in the
> RDMA stack to differentiate it (aka, InfiniBand, OPA, RoCE, iWARP,
> USNIC, Ethernet + QPs).

Why? we should be doing things for a reason. There's no entity I know
of in the stack which needs to be operative and is not b/c that new
type you're suggesting was not defined.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
