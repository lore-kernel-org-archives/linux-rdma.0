From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 for-next 07/14] IB/core: GID attribute should be
 returned from verbs API and cache API
Date: Tue, 19 May 2015 12:06:49 -0600
Message-ID: <20150519180649.GC18675@obsidianresearch.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
 <1432045637-9090-8-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432045637-9090-8-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 05:27:10PM +0300, Matan Barak wrote:

> +#define __IB_ONLY

What is this?

> +/**
> + * ib_cache_use_roce_gid_table - Returns whether the device uses roce gid table
> + * @device: The device to query
> + * @port_num: The port number of the device to query.
> + *
> + * ib_cache_use_roce_gid_table() returns 0 if this port uses the roce_gid_table
> + * to store GIDs and error otherwise.
> + */
> +int ib_cache_use_roce_gid_table(struct ib_device *device, u8 port_num);

This needs to be in the same place and format as the new items from
Michael's patch set. In fact this whole thing will need to be rebased
ontop of it.

>  /**
>   * ib_find_cached_gid - Returns the port number and GID table index where
>   *   a specified GID value occurs.
>   * @device: The device to query.
>   * @gid: The GID value to search for.
> + * @gid_type: The GID type to search for.
> + * @net: In RoCE, the namespace of the device.
> + * @if_index: In RoCE, the if_index of the device. Zero means ignore.
>   * @port_num: The port number of the device where the GID value was found.
>   * @index: The index into the cached GID table where the GID was found.  This
>   *   parameter may be NULL.
> @@ -66,10 +82,36 @@ int ib_get_cached_gid(struct ib_device    *device,
>   */
>  int ib_find_cached_gid(struct ib_device *device,
>  		       union ib_gid	*gid,
> +		       enum ib_gid_type gid_type,
> +		       struct net	  *net,
> +		       int		   if_index,
>  		       u8               *port_num,
>  		       u16              *index);

Why are we adding net namespace stuff here? We don't even have a
proposal for roce net namespaces. Same comment for all net adds.

This patch is similarly muddled with the gid_type, we don't have
rocev2 in this series, so why do we have gid_type being introduced
*at all*?

I'm not certain you should be changing these existing APIs like this,
it doesn't make alot of sense to change a signature then go around to
all callers and not make any use of the additional parameters.

Adding a roce specific call might make more sense, I'm assuming it is
rarely needed?

>  int ib_query_gid(struct ib_device *device,
> -		 u8 port_num, int index, union ib_gid *gid);
> +		 u8 port_num, int index, union ib_gid *gid,
> +		 struct ib_gid_attr *attr);
>  
>  int ib_query_pkey(struct ib_device *device,
>  		  u8 port_num, u16 index, u16 *pkey);
> @@ -1819,7 +1821,8 @@ int ib_modify_port(struct ib_device *device,
>  		   struct ib_port_modify *port_modify);
>  
>  int ib_find_gid(struct ib_device *device, union ib_gid *gid,
> -		u8 *port_num, u16 *index);
> +		enum ib_gid_type gid_type, struct net *net,
> +		int if_index, u8 *port_num, u16 *index);

None of this makes sense unless the device is roce, again, it probably
should have a roce specific call.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
