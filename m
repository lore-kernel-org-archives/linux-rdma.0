From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Sat, 12 Mar 2016 13:45:02 -0700
Message-ID: <20160312204502.GA8346@obsidianresearch.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457795927-16634-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 12, 2016 at 10:18:47AM -0500, Devesh Sharma wrote:
> CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I'm still pretty convinced this is wrong... But even still:

> @@ -954,6 +955,17 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
>  	struct ib_uverbs_file *file = filp->private_data;
>  	struct ib_uverbs_device *dev = file->device;
>  	struct ib_ucontext *ucontext = NULL;
> +	struct ib_device *ib_dev;
> +	int srcu_key;
> +
> +	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
> +	ib_dev = srcu_dereference(dev->ib_dev,
> +				  &dev->disassociate_srcu);
> +	if (!ib_dev) {
> +		srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
> +		wait_for_completion(&file->fcomp);
> +		goto out;

This jumps over this:

>  	if (file->async_file)
>  		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);

Which doesn't seem right.

As I've said, I'm not sure how this is any different from using
lists_mutex. The wait_for_completion will still block and deadlock if
ib_uverbs_close is entered during the disassociate flow.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
