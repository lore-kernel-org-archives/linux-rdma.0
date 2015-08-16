From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 7/8] IB/srp: Register the indirect data buffer descriptor
Date: Sun, 16 Aug 2015 09:56:34 -0700
Message-ID: <55D0C0C2.8020908@sandisk.com>
References: <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org> <55BFB40F.8000500@sandisk.com>
 <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
 <55C2912A.50709@sandisk.com> <20150806001006.GD2483@obsidianresearch.com>
 <55C2A7FE.7020904@sandisk.com> <20150806043642.GA14153@obsidianresearch.com>
 <55C93C61.9010508@sandisk.com> <55C93D21.1090102@sandisk.com>
 <55D06F56.4060005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D06F56.4060005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/16/15 04:09, Sagi Grimberg wrote:
> On 8/11/2015 3:09 AM, Bart Van Assche wrote:
>> +/*
>> + * Register the indirect data buffer descriptor with the HCA.
>> + *
>> + * Note: since the indirect data buffer descriptor has been allocated with
>> + * kmalloc() it is guaranteed that this buffer is a physically contiguous
>> + * memory buffer.
>> + */
>
> kdoc style?

If I have to repost this patch series I will convert this comment into 
kernel-doc style.

>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
>> index 60a33c1..255b0e5 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.h
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
>> @@ -288,6 +288,10 @@ struct srp_map_state {
>>    			struct srp_fr_desc **next;
>>    			struct srp_fr_desc **end;
>>    		} fr;
>> +		struct {
>> +			void		   **next;
>> +			void		   **end;
>> +		} gen;
>
> What does 'gen' stands for?

In this context "gen" stands for "generic". This patch introduces some 
code that needs to access the "next" and "end" pointers and that is used 
both for FMR and FR.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
