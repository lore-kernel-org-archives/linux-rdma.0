From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v2 3/3] IB/cache: don't fill the cache with junk
Date: Mon, 21 Oct 2013 00:12:54 -0400
Message-ID: <5264A9C6.6000807@redhat.com>
References: <cover.1380056994.git.dledford@redhat.com>	<4c88e00f5211787a98fa980a4d42c5c6374ab868.1380056994.git.dledford@redhat.com> <20131020085149.6e719ad2@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131020085149.6e719ad2@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/20/2013 02:51 AM, Jack Morgenstein wrote:
> On Tue, 24 Sep 2013 17:16:29 -0400
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> @@ -85,13 +91,26 @@ int ib_get_cached_gid(struct ib_device *device,
>>
>>   	cache = device->cache.gid_cache[port_num -
>> start_port(device)];
>> -	if (index < 0 || index >= cache->table_len)
>> +	if (index < 0 || index >= cache->table_len) {
>>   		ret = -EINVAL;
>> -	else
>> -		*gid = cache->table[index];
>> +		goto out_unlock;
>> +	}
>>
>> -	read_unlock_irqrestore(&device->cache.lock, flags);
>> +	for (i = 0; i < cache->table_len; ++i)
>> +		if (cache->entry[i].index == index)
>> +			break;
>> +
>> +
>
> Hi Doug,
>
> I am a bit concerned about this patch, because where before
> ib_get_cached_gid just returned the GID at the given index, with your
> suggested change, ib_get_cached_gid() requires a search of the new gid
> table (to find the entry with the requested index value).

Yes, I agree.  That was a consideration in things.

> ib_get_cached_gid is called by cm_req_handler, for the gid at index 0.
> There is no guarantee that this will be the first entry in the new
> scheme.

If it's valid, then yes it is.  Only if GID index 0 is invalid will it 
not be the first entry (and then it won't be an entry at all).  This is 
due to how the update of the gid table works (it scans each entry, 
starting at 0 and going to table length, and puts them into a table in 
ascending order).

Which points out that a valid optimization not present in this patch 
would be to break if the current table index is > than the requested index.

I had also thought about doing a bitmap for the valid entries. 
Realistically, most machines only have 1 or 2 ports of IB devices.  For 
common devices, the maximum pkey table length is 128 entries.  So, 2 
ports at 128 entries per port is a pretty miserly 256 bytes of memory. 
We could just allocate a full table and use a bitmap to represent the 
valid entries, and then in the find_cached* cases use the bitmap to 
limit our search.  That would allow us to go back to O(1) for get_cached*.

> Furthermore, ib_get_cached_gid is also called in MAD packet handling,
> with the specific gid index that is required.
>
> Thus, the savings for ib_find_cached_gid might possibly be offset by a
> performance loss in ib_get_cached_gid.

Doubtful.  Given that the common case is trading a single lookup 
increase to a 3 to 5 GID long chain search versus searching 128 entries 
of which 123 to 125 are invalid down to a similar 3 to 5 long chain 
search, the obvious big gain is getting rid of that 123 to 125 wasted 
memcmp's.  And ib_find_cached_gid is used in cma_acquire_dev(), which in 
turn is called by cma_req_handler, iw_conn_req_handler, addr_handler, 
and rdma_bind_addr.  So it sees plenty of use as well.

Now, one thing I haven't tested yet and wish to, is a situation when we 
have lots of SRIOV devices and a GID table on the PF that is highly 
populated.  In that case, further refinement will likely be necessary. 
If so, that will be my next patch, but I'll leave these patches to stand 
as they do now.

> A simpler optimization would be to simply keep a count of the number of
> valid GIDS in the gid table -- and break off the search when the last
> valid GID has been seen.

My understanding, according to the PKey change flow patches that Or 
posted, is that the GID table can have invalid entries prior to valid 
entries, and so that optimization would break.

>  This would optimize cases where, for example,
> you are searching for a GID that is not in the table, and only the
> first 3 gids in the table are valid (so you would not needlessly access
> 125 invalid GIDs).  Clearly, such an optimization is only useful when
> there are a lot of invalid gids bunched together at the end of the
> table.  Still, something to think about.

As you point out, it only works if all the invalid entries are at the 
end, and we can't guarantee that.

I think I like my suggestion better: go back to having a full table, but 
use a bitmap to indicate valid entries and then use the bitmap to limit 
our comparisons in the find_cached* functions, and put the get_* 
funtions back to being O(1).  But I would still do that incrementally 
from here I think.

But I'm not totally convinced of that either.  The exact sitiation I 
listed above, lots of GIDs on an SRIOV PF, makes me concerned that we 
can get back to a horrible situation in the find_cached* functions once 
we actually have lots of valid entries.  It makes me think we need 
something better than just a linear search of all valid entries when you 
take SRIOV into account.  Whether hash chains or ranges or something to 
make the lots of valid GIDs case faster, I suspect something needs to be 
done, but because things simply aren't in common use yet we don't know it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
