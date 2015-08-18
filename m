From: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB/core: Allow setting create flags in QP
 init attribute
Date: Tue, 18 Aug 2015 13:45:22 +0300
Message-ID: <CAKHjkjmZh61vD+mm6DSNTwVmZ+j7k=xmjNkiMT0RJg9TqGS2cw@mail.gmail.com>
References: <1439741133-30145-1-git-send-email-eranbe@mellanox.com>
	<1439741133-30145-3-git-send-email-eranbe@mellanox.com>
	<20150817164740.GA2350@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150817164740.GA2350-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 17, 2015 at 7:47 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Aug 16, 2015 at 07:05:28PM +0300, Eran Ben Elisha wrote:
>
>> -     if (attr.create_flags) {
>> +     if (attr.create_flags & ~IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
>>               ret = -EINVAL;
>>               goto err_put;
>
> Shouldn't EINVAL still happen if the driver doesn't support this
> feature?
>
> Jason

I expect the same behavior as if ib_create_qp was called with
IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK in the create_flags.
This is not a new flag, and driver should fail the command if not supported.

Eran.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
