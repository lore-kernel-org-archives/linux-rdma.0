From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate
 cleanup and release
Date: Mon, 3 Aug 2015 21:10:38 -0600
Message-ID: <20150804031038.GA27627@obsidianresearch.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
 <1438607342-11964-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438607342-11964-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 03, 2015 at 04:09:01PM +0300, Matan Barak wrote:

> The release function is called after the device was put.
> Although vendor drivers aren't expected to use IB cache in their
> removal process, we postpone freeing the cache in order to avoid
> possible use-after-free errors.

It isn't so much that they are not expected, it is that they may not
have a choice. A driver cannot tear down things like tasklets and work
queues until after removal finishes, and any of those async things
could call into the core. That is why a driver audit would be so hard..

> @@ -902,9 +925,7 @@ int ib_cache_setup_one(struct ib_device *device)
>  					  (rdma_end_port(device) -
>  					   rdma_start_port(device) + 1),
>  					  GFP_KERNEL);
> -	err = gid_table_setup_one(device);
> -
> -	if (!device->cache.pkey_cache || !device->cache.gid_cache ||
> +	if (!device->cache.pkey_cache ||
>  	    !device->cache.lmc_cache) {
>  		printk(KERN_WARNING "Couldn't allocate cache "
>  		       "for %s\n", device->name);
> @@ -912,6 +933,10 @@ int ib_cache_setup_one(struct ib_device *device)
>  		goto err;
>  	}
>  
> +	err = gid_table_setup_one(device);
> +	if (err)
> +		goto err;
> +
>  	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
>  		device->cache.pkey_cache[p] = NULL;
>  		ib_cache_update(device, p + rdma_start_port(device));
> @@ -929,29 +954,46 @@ err_cache:
>  	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
>  		kfree(device->cache.pkey_cache[p]);
>  
> +	gid_table_cleanup_one(device);
> +	gid_table_release_one(device);
>  err:
>  	kfree(device->cache.pkey_cache);
> -	gid_table_cleanup_one(device);
>  	kfree(device->cache.lmc_cache);

This still seems to double kfree on error..

Pick a scheme and use it consistently, either rely on release to be
called on error via kref-put, or kfree and null, for all the kfress in
release_one.

> +	ib_cache_cleanup_one(device);
> 	ib_device_unregister_sysfs(device);

I didn't check closely, but I suspect the above order should be
swapped, and the matching swap in register. sysfs can legitimately
call into core code, but vice-versa shouldn't happen...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
