From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] iser: Set block queue_virt_boundary and remove bounce
 buffering code
Date: Sun, 11 Oct 2015 10:22:37 +0300
Message-ID: <561A0E3D.20402@dev.mellanox.co.il>
References: <CAJ3xEMj5kYYK0bxUcGrtm9M8HkQPk=9M0ERkbNBV2516oXKMMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj5kYYK0bxUcGrtm9M8HkQPk=9M0ERkbNBV2516oXKMMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2015 10:33 PM, Or Gerlitz wrote:
> On Sat, Oct 10, 2015 at 3:27 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> The block layer reliably enforces no SG lists with gaps
>> to a 4k virtual boundary so we can completely remove the
>> entire bounce buffering logic.
>
> Hi Sagi,

Hey Or,

>
> (Very) nice cleanup -- so what's the actual deal here? is that as long
> as we plant a slave alloc callback into out scsi host template which
> further invokes  a
> blk_queue_virt_boundary(sdev->request_queue, ~MASK_4K) call, we're
> 100% safe/sure what all SGs we get meet the alignment criteria?

Correct, the nvme driver has the same alignment constraints for its PRPs
and uses the queue virt_boundary to have the block layer enforce the
SG alignment. Recently a patch set that resolves some issues with front
merges, integrity payload and SG_IO was included by Jens (IIRC you were
CC'd on this patch set).

See commits:
4634845 block: Copy a user iovec if it includes gaps
87a816d block: Refuse adding appending a gapped integrity page to a bio
7f39add block: Refuse request/bio merges with gaps in the integrity
5e7c427 block: Check for gaps on front and back merges

So now the block layer reliably enforces the alignment constraints and
we can stop doing bounce buffering in iser.

>
> Since this is such a critical aspect in our design, I think it would
> be good to copy on this commit Martin or Jens.

I can copy Martin and Jens although I don't know how much they care
about iser.

> Also change the patch
> title to have IB/iser: which complies with the way we prefix iser
> commits.

I will.

Thanks!
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
