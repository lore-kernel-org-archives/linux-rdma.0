From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Mon, 7 Mar 2016 12:08:33 -0700
Message-ID: <20160307190833.GA1886@obsidianresearch.com>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457343873-14869-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 07, 2016 at 04:44:33AM -0500, Devesh Sharma wrote:

> [67140.260665]  [<ffffffff810c16a0>] ? prepare_to_wait_event+0xf0/0xf0
> [67140.268337]  [<ffffffffa04cabc3>] ? ib_dereg_mr+0x23/0x30 [ib_core]

So, ib_dereg_mr at this point:

        ret = mr->device->dereg_mr(mr);

Is running when mr->device is already freed?

> During rmmod <vendor-driver> "ib_uverbs_close()" context is
> still running, while "ib_uverbs_remove_one()" context completes and
> ends up freeing ib_dev pointer, thus causing a Kernel Panic.

Hurm..

So ib_uverbs_close is busy running in ib_uverbs_cleanup_ucontext and
then ib_uverbs_free_hw_resources is called?

At first blush it certainly looks like the locking around
ib_uverbs_cleanup_context is wrong.

> This patch fixes the race. ib_uverbs_close validates dev->ib_dev against NULL
> inside an srcu lock. If it is NULL, it waits for a completion and drops the srcu
> else continues with the normal flow.

Hum.. So this is really weird, this patch is bascially duplicating a
mutex with srcu and a completion??

What is wrong with simply this:

--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -962,9 +962,9 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
                list_del(&file->list);
                file->is_closed = 1;
        }
-       mutex_unlock(&file->device->lists_mutex);
        if (ucontext)
                ib_uverbs_cleanup_ucontext(file, ucontext);
+       mutex_unlock(&file->device->lists_mutex);
 

??

Noting that ib_uverbs_free_hw_resources holds lists_mutex while
calling ib_uverbs_cleanup_ucontext, so it should be safe, or we have
another bug?

Certainly, the above is closer to the original intent of how this was
supposed to work...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
