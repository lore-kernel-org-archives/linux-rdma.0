From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/core: Add support for fd objects
Date: Wed, 11 Jan 2017 16:58:01 -0700
Message-ID: <20170111235801.GC31682@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484132033-3346-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 12:53:49PM +0200, Matan Barak wrote:

> This commit adds the necessary mechanism to support FD based objects
> like their IDR counterparts. FD objects release need to be synchronized
> with context release. Since FDs could outlives their context, we use
> a kref on this lock. We initialize the lock and the kref in downstream
> patches. This is acceptable, as we don't use this infrastructure until
> a later point in this series.

This seems unnecessarily complicated. Just hold the kref on the
ucontext in the fd. There isn't a problem with a dummy version of that
struct hanging around..

> +static struct ib_uobject *uverbs_get_uobject_from_fd(const struct uverbs_type_alloc_action *type_alloc,
> +						     struct ib_ucontext *ucontext,
> +						     enum uverbs_idr_access access,
> +						     unsigned int fd)
> +{
> +	if (access == UVERBS_ACCESS_NEW) {
> +		int _fd;

Something has gone terribly wrong if you need _ to disambiguate with a
function argument...
> +	} else if (access == UVERBS_ACCESS_READ) {
> +		struct file *f = fget(fd);
> +		struct ib_uobject *uobject;
> +
> +		if (!f)
> +			return ERR_PTR(-EBADF);
> +
> +		uobject = uverbs_priv_fd_to_uobject(f->private_data);
> +		if (f->f_op != type_alloc->fd.fops ||
> +		    !uobject->context) {

I think the if should be split, if fops isn't correct then do not even
call uverbs_priv_fd_to_uobject.

> +void uverbs_cleanup_fd(void *private_data)
> +{
> +	struct ib_uobject *uobject = uverbs_priv_fd_to_uobject(private_data);
> +
> +	kfree(uobject);
> +}

Woah, this is not OK at this point in the series. There is really too
much stuff bundled into patch 7 to make proper sense of this.

I don't like this design. Do not implicitly prepend ib_uobject to
structures. Require the users to include the struct as is common in
linux.

Do not drop the kref out of ib_uobject, that should be the master
kref, drop the kref out of ib_uverbs_event_file instead.

> +static inline void *uverbs_fd_uobj_to_priv(struct ib_uobject *uobj)
> +{
> +	return uobj + 1;
> +}

Which means stuff like this can go away..

> -	int			id;		/* index into kernel idr */
> +	int			id;		/* index into kernel idr/fd */

Why do we need to store the fd number at all? We can *never* use it in
the kernel except as the argument to fdinstall. For that reason we
should never store it.

Can you move the fdallocate into finalize? At the very least 0 the
value after fdinstall so people don't get the wrong idea down the
road.

>  	int				order;
>  	size_t				obj_size;
>  	free_type			free_fn;
> +	struct {
> +		const struct file_operations	*fops;
> +		const char			*name;

Maybe name should be common

This idea also seems reasonable to me in general, but again, I'd
rather see it more completely implemented in this patch instead of
deferring so much stuff in to the giant #7 patch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
