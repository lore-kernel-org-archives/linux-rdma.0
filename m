From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Tue, 14 Apr 2015 16:23:18 +0300
Message-ID: <552D14C6.50000@mellanox.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <551347E9.5090503@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551347E9.5090503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 3/26/2015 1:42 AM, Bart Van Assche wrote:
> On 03/25/2015 02:19 PM, Somnath Kotur wrote:
>> +    if (cache->data_vec[ix].attr.ndev &&
>> +        cache->data_vec[ix].attr.ndev != old_net_dev)
>
> A few lines earlier the memory old_net_dev points at was freed. If two
> instances of this function run concurrently, what prevents that the
> old_net_dev memory has been reallocated and hence that attr.ndev ==
> old_net_dev although both pointers refer(red) to different network
> devices ?
>

write_gid is *almost* always called in a mutex. The only case it's not 
protected is in free_roce_gid_cache. free_roce_gid_cache is called only 
in the error flow of roce_gid_cache_setup_one, when no concurrent 
write_gid could be made (as the cache isn't setup yet) and in 
roce_gid_cache_cleanup_one. roce_gid_cache_client_setup_one is called in 
the error flow of roce_gid_cache_client_setup_one (where no other 
write_gid are expected for the same above reason) and in 
roce_gid_cache_client_cleanup_work_handler, where it's called after 
flush_workqueue(roce_gid_mgmt_wq). Since all write_gids are called 
through roce_gid_mgmt_wq and we set the cache to inactive mode before 
flushing the wq and freeing the cache, I think we can conclude no 
concurrent write_gid on the same cache are possible.

>> +    ACCESS_ONCE(cache->data_vec[ix].seq) = orig_seq;
>
> Invoking write_gid() is only safe if the caller serializes write_gid()
> calls. Apparently the cache->lock mutex is used for that purpose. So why
> is it necessary to use ACCESS_ONCE() here ? Why is it needed to prevent
> that the compiler coalesces this write with another write into the same
> structure ?
>

The mutex only serializes cache writes. Cache reads could be done in 
concurrent with writes and are protected by the ACCESS_ONCE.

>> +        /* Make sure the sequence number we remeber was read
>
> This looks like a typo - shouldn't the above read "remember" ?
>

Will be fixed in V4, thanks.

> BTW, the style of that comment is recommended only for networking code
> and not for IB code. Have you verified this patch with checkpatch ?
>

Of course and I've just re-run checkpatch on this patch. It doesn't 
catch this.

>> +    mutex_lock(&cache->lock);
>> +
>> +    for (ix = 0; ix < cache->sz; ix++)
>> +        if (cache->data_vec[ix].attr.ndev == ndev)
>> +            write_gid(ib_dev, port, cache, ix, &zgid, &zattr);
>> +
>> +    mutex_unlock(&cache->lock);
>> +    return 0;
>
> The traditional Linux kernel coding style is one blank line before
> mutex_lock() and after mutex_unlock() but not after mutex_lock() nor
> before mutex_unlock().
>

I didn't find this in the CodingStyle doc. Could you please quote or 
post a link?

>> +    orig_seq = ACCESS_ONCE(cache->data_vec[index].seq);
>> +    /* Make sure we read the sequence number before copying the
>> +     * gid to local storage. */
>> +    smp_rmb();
>
> Please use READ_ONCE() instead of ACCESS_ONCE() as recommended in
> <linux/compiler.h>.
>

Ok, I'll change that in V4. I see that READ_ONCE and WRITE_ONCE is 
different from ACCESS_ONCE only for aggregated data types (which isn't 
our case), but it won't hurt to change that.

>> +static void free_roce_gid_cache(struct ib_device *ib_dev, u8 port)
>> +{
>> +    int i;
>> +    struct ib_roce_gid_cache *cache =
>> +        ib_dev->cache.roce_gid_cache[port - 1];
>> +
>> +    if (!cache)
>> +        return;
>> +
>> +    for (i = 0; i < cache->sz; ++i) {
>> +        if (memcmp(&cache->data_vec[i].gid, &zgid,
>> +               sizeof(cache->data_vec[i].gid)))
>> +            write_gid(ib_dev, port, cache, i, &zgid, &zattr);
>> +    }
>  > +    kfree(cache->data_vec);
>  > +    kfree(cache);
>  > +}
>
> Overwriting data just before it is freed is not useful. Please use
> CONFIG_SLUB_DEBUG=y to debug use-after-free issues instead of such code.
>

It's mandatory as write_gid with zgid might cause the vendor driver to 
free memory it allocated for this GID entry (like in the mlx4 case).

> Bart.

Thanks for the review :)

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
