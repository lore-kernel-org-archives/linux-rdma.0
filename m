From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 6/8] IB/srp: Introduce srp_device.use_fmr
Date: Sun, 16 Aug 2015 08:57:28 -0700
Message-ID: <55D0B2E8.4040704@sandisk.com>
References: <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org> <55BFB40F.8000500@sandisk.com>
 <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
 <55C2912A.50709@sandisk.com> <20150806001006.GD2483@obsidianresearch.com>
 <55C2A7FE.7020904@sandisk.com> <20150806043642.GA14153@obsidianresearch.com>
 <55C93C61.9010508@sandisk.com> <55C93D0C.7060000@sandisk.com>
 <55D06E05.5060209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D06E05.5060209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/16/15 04:03, Sagi Grimberg wrote:
> On 8/11/2015 3:08 AM, Bart Van Assche wrote:
>> @@ -1354,8 +1357,7 @@ static int srp_finish_mapping(struct srp_map_state *state,
>>    		srp_map_desc(state, state->base_dma_addr, state->dma_len,
>>    			     target->rkey);
>>    	else
>> -		ret = target->srp_host->srp_dev->use_fast_reg ?
>> -			srp_map_finish_fr(state, ch) :
>> +		ret = dev->use_fast_reg ? srp_map_finish_fr(state, ch) :
>>    			srp_map_finish_fmr(state, ch);
>
> Is this related to the patch?

This change could have been split out as a separate patch. If I have to 
repost this patch series I will convert this change into a separate patch.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
