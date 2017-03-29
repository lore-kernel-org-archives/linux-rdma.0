From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] IB/core: Change completion channel to
 use the reworked objects schema
Date: Wed, 29 Mar 2017 08:53:44 -0600
Message-ID: <20170329145344.GB2586@obsidianresearch.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-8-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489939145-125246-8-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 19, 2017 at 05:59:05PM +0200, Matan Barak wrote:
> +static struct ib_uverbs_completion_event_file *
> +ib_uverbs_lookup_comp_file(int fd, struct ib_ucontext *context)
> +{
> +	struct ib_uobject *uobj = uobj_get_read(uobj_get_type(comp_channel),
> +						fd, context);
> +	struct ib_uobject_file *uobj_file;
> +
> +	if (IS_ERR(uobj))
> +		return (void *)uobj;
> +
> +	uobj_file = container_of(uobj, struct ib_uobject_file, uobj);
> +
> +	uverbs_uobject_get(&uobj_file->uobj);
> +	uobj_put_read(uobj);

That looks odd, isn't uobj == uobj_file->uobj ? 

> +	kref_init(&ev_file->ref);
> +	filp = anon_inode_getfile("[infinibandevent]", &uverbs_async_event_fops,
>  				  ev_file, O_RDONLY);

It seems weird this name occures twice:

> +const struct uverbs_obj_fd_type uverbs_type_attrs_comp_channel = {
> +	.type = UVERBS_TYPE_ALLOC_FD(sizeof(struct ib_uverbs_completion_event_file), 0),
> +	.context_closed = uverbs_hot_unplug_completion_event_file,
> +	.fops = &uverbs_event_fops,
> +	.name = "[infinibandevent]",
> +	.flags = O_RDONLY,
> +};

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
