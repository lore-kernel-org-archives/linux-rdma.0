From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 3 Mar 2016 14:08:28 +0200
Message-ID: <56D8293C.1050306@dev.mellanox.co.il>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-8-git-send-email-hch@lst.de>
 <56D81790.8090305@dev.mellanox.co.il> <20160303120209.GC20543@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160303120209.GC20543-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Christoph,
>>
>> This is a problem for mlx5 which exposes:
>>
>>          props->max_fast_reg_page_list_len = (unsigned int)-1;
>>
>> Which is obviously wrong and needs to be corrected, but this is sort of
>> an overkill to allocate max supported unconditionally.
>>
>> How about choosing a sane default of 256/512 pages for now? I don't
>> think we'll see a lot of larger transfers in iser/nvmf (which actually
>> need MRs for iWARP).
>>
>> Alternatively we can allow the caller to limit the MR size?
>
> I'm fine with a limit in the core rdma r/w code.  But why is this
> a problem for mlx5?  If it offers unlimited MR sizes it should support
> that, or report a useful value.  I don't see why fixing mlx5 should
> be a problem, and would rather see this driver bug fixed ASAP.

Already sent out a fix for mlx5. But even then, if a driver offers huge
amount of translation entries per MR doesn't mean we need to allocate
gigantic MRs for imaginary transfer sizes...

I'd be happier if this is controlled by the caller.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
