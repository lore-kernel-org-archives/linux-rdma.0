From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Wed, 5 Aug 2015 12:21:17 -0600
Message-ID: <20150805182117.GA15583@obsidianresearch.com>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
 <1438697008-26209-7-git-send-email-yishaih@mellanox.com>
 <20150804220903.GE10934@obsidianresearch.com>
 <55C22739.5060808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C22739.5060808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 05, 2015 at 06:09:45PM +0300, Yishai Hadas wrote:
> >>+static void ucma_close_id(struct work_struct *work)
> >>+{
> >>+	struct ucma_context *ctx =  container_of(work, struct ucma_context, close_work);
> >>+
> >>+	/* Fence to ensure that ctx->closing was seen by all
> >>+	 * ucma_get_ctx running
> >>+	 */
> >>+	mutex_lock(&mut);
> >>+	mutex_unlock(&mut);
> >
> >Uh, no. That isn't how to use mutex's.
> 
> That locking scheme is used in some other places in the kernel when a
> barrier/fence is needed, see below some examples of that usage and my
> comment around the usage.

'I saw it used someplace else' isn't much of an argument.. Maybe those
places are sane, this isn't so much..

> If you still don't agree we can go ahead and merge the first 5 patches that
> doesn't depend on that last patch and handle/discuss this patch later.

I have no real problem with that, it would be nice to have an answer
to the uverbs vs ucma removal ordering question and the basic issue of
if we even want to do this so async before merging the driver patch
that enables it..

> The first 4 you already review and acked the fifth is in mlx4_ib and has no
> comments to fix so far - some months in the list.

Personally, I'm not looking much at drivers..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
