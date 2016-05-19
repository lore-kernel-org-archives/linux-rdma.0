From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 09/10] IB/hfi1: Do not free hfi1 cdev parent structure
 early
Date: Thu, 19 May 2016 12:31:00 -0600
Message-ID: <20160519183100.GC26130@obsidianresearch.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
 <20160519122642.22041.66203.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160519122642.22041.66203.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 05:26:44AM -0700, Dennis Dalessandro wrote:
>  static int hfi1_file_open(struct inode *inode, struct file *fp)
>  {
> +	struct hfi1_devdata *dd = container_of(inode->i_cdev,
> +					       struct hfi1_devdata,
> +					       user_cdev);
> +
> +	/* Just take a ref now. Not all opens result in a context assign */
> +	kobject_get(&dd->kobj);

Eh?

If dd->kobj is passed as the parent to hfi1_cdev_init then cdev core
will do this for you, just confusing to duplicate it here??

> @@ -1007,6 +1009,15 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
>  	rvt_dealloc_device(&dd->verbs_dev.rdi);

Hurm. How are you synchronizing pci device removal with ioctls on the
cdev?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
