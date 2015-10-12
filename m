From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 1/2] IB/iser: set block queue_virt_boundary
Date: Mon, 12 Oct 2015 07:34:17 +0300
Message-ID: <561B3849.6000000@dev.mellanox.co.il>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
 <1444577707-15778-2-git-send-email-sagig@mellanox.com>
 <CAJ3xEMhhFSRcMrDm--PD-ekr6hJZZXGk_3JE2iEmmHN0fi=b-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhhFSRcMrDm--PD-ekr6hJZZXGk_3JE2iEmmHN0fi=b-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What happens now when an app wants to use 1K, 2K, 3K IOs? they can
> only use 1/4, 1/2 or 3/4 of the available memory for these
> transactions?

What? I'm not sure what you are talking about. what available memory?

> and we are going to fix it with devices like mlx5 over
> the new API you're proposing, right?

Fix what?

>
> If this is the case, aren't we introducing a regression for
> applications that used this IO pattern over devices which aren't
> capable as mlx5 is (e.g mlx4), in the sense that the required memory
> footprint to address the application IO demand can be made 4X bigger?

Regression? What makes you think that the memory footprint increases?
There is no additional memory introduced by setting the queue
virt_boundary.

It's simple, like NVME prps, the RDMA page vectors need to meet:
- first byte offset
- full pages of some page_size
- last page can end before page_size

Not every SG list meets the above. Up until now we used BB. Since the
block layer is perfectly capable of handling this for us, we can lose
this bounce buffering code.

The block layer will:
- refuse merges if bios are not aligned to the virtual boundary
- split bios/requests that are not aligned to the virtual boundary
- or, bounce buffer SG_IOs that are not aligned to the virtual boundary

There is no additional memory what-so-ever.

With our arbitrary SG list support, If our device supports it, we can
remove the virt_boundary so the block layer won't have to take care of
any of the above.

>
> If the 4X assertion made here is correct

Its not.

> why not keeping the current
> BB logic to come into play for such devices? I know that without the
> BB code our driver looks much nicer and elegant, but life is sometimes
> more complex... thoughts?

Now that the block layer can absolutely guarantee to pass SG lists that
meet our alignment requirements, I don't think we need the BB logic
anymore.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
