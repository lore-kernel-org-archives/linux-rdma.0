From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] iser: Set block queue_virt_boundary and remove bounce
 buffering code
Date: Sat, 10 Oct 2015 22:33:57 +0300
Message-ID: <CAJ3xEMj5kYYK0bxUcGrtm9M8HkQPk=9M0ERkbNBV2516oXKMMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 10, 2015 at 3:27 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> The block layer reliably enforces no SG lists with gaps
> to a 4k virtual boundary so we can completely remove the
> entire bounce buffering logic.

Hi Sagi,

(Very) nice cleanup -- so what's the actual deal here? is that as long
as we plant a slave alloc callback into out scsi host template which
further invokes  a
blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K) call, we're
100% safe/sure what all SGs we get meet the alignment criteria?

Since this is such a critical aspect in our design, I think it would
be good to copy on this commit Martin or Jens. Also change the patch
title to have IB/iser: which complies with the way we prefix iser
commits.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
