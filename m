From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 6/7] IB/core: Add support for fd objects
Date: Wed, 29 Mar 2017 08:55:07 -0600
Message-ID: <20170329145507.GC2586@obsidianresearch.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-7-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489939145-125246-7-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 19, 2017 at 05:59:04PM +0200, Matan Barak wrote:

> +static void alloc_abort_fd_uobject(struct ib_uobject *uobj)
> +{
> +	struct ib_uobject_file *uobj_file =
> +		container_of(uobj, struct ib_uobject_file, uobj);
> +	struct file *filp = uobj->object;
> +	int id = uobj_file->uobj.id;
> +
> +	/* Unsuccessful NEW */
> +	fput(filp);
> +	put_unused_fd(id);
> +}
> +
> +static int __must_check remove_commit_fd_uobject(struct ib_uobject *uobj,
> +						 enum rdma_remove_reason why)
> +{
> +	const struct uverbs_obj_fd_type *fd_type =
> +		container_of(uobj->type, struct uverbs_obj_fd_type, type);
> +	struct ib_uobject_file *uobj_file =
> +		container_of(uobj, struct ib_uobject_file, uobj);
> +	int ret = fd_type->context_closed(uobj_file, why);
> +
> +	if (why == RDMA_REMOVE_DESTROY && ret)
> +		return ret;
> +
> +	if (why == RDMA_REMOVE_DURING_CLEANUP) {
> +		alloc_abort_fd_uobject(uobj);

Doesn't this call put_unused_fd on a fd that has actually been
installed? That isn't OK...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
