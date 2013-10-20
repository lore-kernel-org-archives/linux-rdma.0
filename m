From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Patch v2 3/3] IB/cache: don't fill the cache with junk
Date: Sun, 20 Oct 2013 08:51:49 +0200
Message-ID: <20131020085149.6e719ad2@jpm-OptiPlex-GX620>
References: <cover.1380056994.git.dledford@redhat.com>
	<4c88e00f5211787a98fa980a4d42c5c6374ab868.1380056994.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4c88e00f5211787a98fa980a4d42c5c6374ab868.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 Sep 2013 17:16:29 -0400
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> @@ -85,13 +91,26 @@ int ib_get_cached_gid(struct ib_device *device,
>  
>  	cache = device->cache.gid_cache[port_num -
> start_port(device)]; 
> -	if (index < 0 || index >= cache->table_len)
> +	if (index < 0 || index >= cache->table_len) {
>  		ret = -EINVAL;
> -	else
> -		*gid = cache->table[index];
> +		goto out_unlock;
> +	}
>  
> -	read_unlock_irqrestore(&device->cache.lock, flags);
> +	for (i = 0; i < cache->table_len; ++i)
> +		if (cache->entry[i].index == index)
> +			break;
> +
> +

Hi Doug,

I am a bit concerned about this patch, because where before
ib_get_cached_gid just returned the GID at the given index, with your
suggested change, ib_get_cached_gid() requires a search of the new gid
table (to find the entry with the requested index value).

ib_get_cached_gid is called by cm_req_handler, for the gid at index 0.
There is no guarantee that this will be the first entry in the new
scheme.

Furthermore, ib_get_cached_gid is also called in MAD packet handling,
with the specific gid index that is required.

Thus, the savings for ib_find_cached_gid might possibly be offset by a
performance loss in ib_get_cached_gid.

A simpler optimization would be to simply keep a count of the number of
valid GIDS in the gid table -- and break off the search when the last
valid GID has been seen.  This would optimize cases where, for example,
you are searching for a GID that is not in the table, and only the
first 3 gids in the table are valid (so you would not needlessly access
125 invalid GIDs).  Clearly, such an optimization is only useful when
there are a lot of invalid gids bunched together at the end of the
table.  Still, something to think about.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
