From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 03/12] IB/hfi1: Fix an Oops on pci device force remove
Date: Mon, 17 Oct 2016 10:07:31 -0600
Message-ID: <20161017160731.GA5679@obsidianresearch.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
 <20161017111918.7934.72325.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017111918.7934.72325.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 17, 2016 at 04:19:19AM -0700, Dennis Dalessandro wrote:
> @@ -183,6 +183,7 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
>  		fd->rec_cpu_num = -1; /* no cpu affinity by default */
>  		fd->mm = current->mm;
>  		atomic_inc(&fd->mm->mm_count);
> +		atomic_inc(&dd->user_refcount);

This doesn't look like enough locking on acquire.. What prevents the
driver from already having been unloaded at this point?

> +static void wait_for_clients(struct hfi1_devdata *dd)
> +{
> +	/*
> +	 * Remove the device init value and wait for active
> +	 * users to finish if there are any.
> +	 */
> +	if (atomic_sub_return(1, &dd->user_refcount))
> +		wait_for_completion(&dd->user_comp);
> +}

Shouldn't this be a while loop to avoid races?

.. and shouldn't the inc 'latch off' once the removal process starts?

I think you need to study how kernfs_drain is implemented and
basically copy that approach, including the locking.

FWIW, it is much easier and probably long term better to arrange
things so the FD can remain open but just return ENODEV to all calls.
Eg the srcu based approach in uverbs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
