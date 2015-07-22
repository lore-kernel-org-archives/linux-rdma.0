From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 22 Jul 2015 19:56:49 +0300
Message-ID: <55AFCB51.6060002@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722165012.GC6443-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 7:50 PM, Christoph Hellwig wrote:
>> +/**
>> + * ib_map_mr_sg() - Populates MR with a dma mapped SG list
>> + * @mr:            memory region
>> + * @sg:            dma mapped scatterlist
>> + * @sg_nents:      number of entries in sg
>> + * @access:        access permissions
>
> I know moving the access flags here was my idea originally, but I seem
> convinced by your argument that it might fit in better with the posting
> helper.  Or did someone else come up with a better argument that mine
> for moving it here?

Not really. I was and still pretty indifferent about it...

>
>> +int ib_map_mr_sg(struct ib_mr *mr,
>> +		 struct scatterlist *sg,
>> +		 unsigned short sg_nents,
>> +		 unsigned int access)
>> +{
>> +	int rc;
>> +
>> +	if (!mr->device->map_mr_sg)
>> +		return -ENOSYS;
>> +
>> +	rc = mr->device->map_mr_sg(mr, sg, sg_nents);
>
> Do we really need a driver callout here?  It seems like we should
> just do the map here, and then either have a flag for the mlx5 indirect
> mapping, or if you want to keep the abstraction add the method at that
> point but make it optional, so that all the other drivers don't need the
> boilerplate code.

I commented on this bit in another reply. I think that several drivers
will want to use their own mappings. But I can change that if it's not
the case...

>
> Also it seems like this returns 0/-error.  How do callers like SRP
> see that it only did a partial mapping and it needs another MR?

Umm, I think SRP would need to iterate over the sg list and pass partial
SGs to the mapping (I can add a break; statement if we met sg_nents)

It's not perfect, but the idea was not to do backflips here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
