From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Thu, 26 Mar 2015 14:05:18 +0000
Message-ID: <7F44EA5110810A40B7DAFB605C41975D58F8EBD2@CMEXMB1.ad.emulex.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <551347E9.5090503@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551347E9.5090503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matan/Moni,
                    Could either of you please respond to both of Bart's queries?

Thanks
Somnath

> -----Original Message-----
> From: Bart Van Assche [mailto:bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]
> Sent: Thursday, March 26, 2015 5:13 AM
> To: Somnath Kotur; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> Subject: Re: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
> 
> On 03/25/2015 02:19 PM, Somnath Kotur wrote:
> > +	if (cache->data_vec[ix].attr.ndev &&
> > +	    cache->data_vec[ix].attr.ndev != old_net_dev)
> 
> A few lines earlier the memory old_net_dev points at was freed. If two
> instances of this function run concurrently, what prevents that the
> old_net_dev memory has been reallocated and hence that attr.ndev ==
> old_net_dev although both pointers refer(red) to different network devices
> ?
> 
> > +	ACCESS_ONCE(cache->data_vec[ix].seq) = orig_seq;
> 
> Invoking write_gid() is only safe if the caller serializes write_gid() calls.
> Apparently the cache->lock mutex is used for that purpose. So why is it
> necessary to use ACCESS_ONCE() here ? Why is it needed to prevent that
> the compiler coalesces this write with another write into the same structure
> ?
> 
> > +		/* Make sure the sequence number we remeber was read
> 
> This looks like a typo - shouldn't the above read "remember" ?
> 
> BTW, the style of that comment is recommended only for networking code
> and not for IB code. Have you verified this patch with checkpatch ?
> 
> > +	mutex_lock(&cache->lock);
> > +
> > +	for (ix = 0; ix < cache->sz; ix++)
> > +		if (cache->data_vec[ix].attr.ndev == ndev)
> > +			write_gid(ib_dev, port, cache, ix, &zgid, &zattr);
> > +
> > +	mutex_unlock(&cache->lock);
> > +	return 0;
> 
> The traditional Linux kernel coding style is one blank line before
> mutex_lock() and after mutex_unlock() but not after mutex_lock() nor
> before mutex_unlock().
> 
> > +	orig_seq = ACCESS_ONCE(cache->data_vec[index].seq);
> > +	/* Make sure we read the sequence number before copying the
> > +	 * gid to local storage. */
> > +	smp_rmb();
> 
> Please use READ_ONCE() instead of ACCESS_ONCE() as recommended in
> <linux/compiler.h>.
> 
> > +static void free_roce_gid_cache(struct ib_device *ib_dev, u8 port) {
> > +	int i;
> > +	struct ib_roce_gid_cache *cache =
> > +		ib_dev->cache.roce_gid_cache[port - 1];
> > +
> > +	if (!cache)
> > +		return;
> > +
> > +	for (i = 0; i < cache->sz; ++i) {
> > +		if (memcmp(&cache->data_vec[i].gid, &zgid,
> > +			   sizeof(cache->data_vec[i].gid)))
> > +		    write_gid(ib_dev, port, cache, i, &zgid, &zattr);
> > +	}
>  > +	kfree(cache->data_vec);
>  > +	kfree(cache);
>  > +}
> 
> Overwriting data just before it is freed is not useful. Please use
> CONFIG_SLUB_DEBUG=y to debug use-after-free issues instead of such
> code.
> 
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
