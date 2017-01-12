From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 4/7] IB/core: Add generic ucontext
 initialization and teardown
Date: Wed, 11 Jan 2017 17:09:31 -0700
Message-ID: <20170112000931.GD31682@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-5-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484132033-3346-5-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 12:53:50PM +0200, Matan Barak wrote:
> When a ucontext is created, we need to initialize the list of objects.
> This list consists of every user object that is associated with
> this ucontext. The possible elements in this list are either a file
> descriptor or an object which is represented by an IDR.
> Every such an object, has a release function (which is called upon
> object destruction) and a number associated to its release order.

Please use standard names. As discussed my last message, every
uobject should have a kref, and the 'release' function is *only* the
function that gets called on last-put.

The purpose of this destruction and ordering is to destroy *device*
resources *only*. It has nothing to do with ordering kref puts.

> +static unsigned int get_max_type_orders(const struct uverbs_root *root)
> +{
> +	unsigned int i;
> +	unsigned int max = 0;
> +
> +	for (i = 0; i < root->num_groups; i++) {
> +		unsigned int j;
> +		const struct uverbs_type_group *types = root->type_groups[i];
> +
> +		for (j = 0; j < types->num_types; j++) {
> +			/*
> +			 * Either this type isn't supported by this ib_device
> +			 * (as the group is an array of pointers to types
> +			 * indexed by the type) or this type is supported, but
> +			 * we can't instantiate objects from this type
> +			 * (e.g. you can't instantiate objects of
> +			 * UVERBS_DEVICE).
> +			 */
> +			if (!types->types[j] || !types->types[j]->alloc)
> +				continue;
> +			if (types->types[j]->alloc->order > max)
> +				max = types->types[j]->alloc->order;
> +		}
> +	}

This seems like an inefficient algorithm, just use something like this
for destroy:

cur_order = 0
    while (!list_empty(&ucontext->uobjects)) {
        next_order = MAX;
	list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
				 list) {
             if (object->type->order == cur_order) {
	       ..
	     } else
                   next_order = min(object->type->order, next_order);
        }
	cur_order = next_order;
    }

> +void uverbs_release_ucontext(struct ib_ucontext *ucontext)
> +{
> +	/*
> +	 * Since FD objects could outlive their context, we use a kref'ed
> +	 * lock. This lock is referenced when a context and FD objects are
> +	 * created. This lock protects concurrent context release from FD
> +	 * objects release. Therefore, we need to put this lock object in
> +	 * the context and every FD object release.
> +	 */
> +	kref_put(&ucontext->uobjects_lock->ref, release_uobjects_list_lock);
> +}

A function called release that doesn't do release?

> +struct uverbs_type {
> +	const struct uverbs_type_alloc_action   *alloc;
> +};
> +
> +struct uverbs_type_group {
> +	size_t					num_types;
> +	const struct uverbs_type		**types;
> +};
> +
> +struct uverbs_root {
> +	const struct uverbs_type_group		**type_groups;
> +	size_t					num_groups;
> +};

None of this is necessary at this point in the series, as I said in an
earlier patch just create a single sensible meta-class type and store
the order in there.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
