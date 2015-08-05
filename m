From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Wed, 5 Aug 2015 15:41:46 -0700
Message-ID: <55C2912A.50709@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150803152420.GA24193@infradead.org>
 <55BFB40F.8000500@sandisk.com> <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C2840C.5050301-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/05/2015 02:45 PM, Bart Van Assche wrote:
> On 08/05/2015 12:51 PM, Jason Gunthorpe wrote:
>> On Tue, Aug 04, 2015 at 11:41:16PM -0700, David Dillow wrote:
>>> On Tue, 2015-08-04 at 12:09 -0600, Jason Gunthorpe wrote:
>>>> On Mon, Aug 03, 2015 at 11:33:51AM -0700, Bart Van Assche wrote:
>>>>>> Bart, do you know what hardware this workaround is for?
>>>>>
>>>>> I hope the HW vendors can comment on this. Sorry but I'm not sure which HCA
>>>>> models and/or firmware versions do not support FMR mapping with a non-zero
>>>>> offset.
>>>>
>>>> Perhaps David can remember why he added this:
>>>>
>>>> commit 8f26c9ff9cd0317ad867bce972f69e0c6c2cbe3c
>>>
>>> It's originally from commit 559ce8f150d7d031c79c4d79173860f1bdfe3ce4,
>>> and the list's attempts at code archaeology failed us:
>>> http://article.gmane.org/gmane.linux.drivers.rdma/7149
>>
>> Okay.. So over time we went from a clear target specific bug described
>> 9 years ago in 559ce through chinese whispers to a general unspecific
>> fear of non-zero offset FMR?
>>
>> But nobody has described FMR failure in this way in the past 9 years
>> with any specificity?
>>
>> My random guesses would be broken mthca firmware at the start of the
>> FMR feature (long since fixed) or a wonky target that is now 10 years
>> obsolete..
>>
>> If it was an HCA bug, I strongly have to think it is fixed now. We use
>> FMR all over the place and SRP is the only area I've noticed this
>> restriction..
>>
>> If it is a target bug, then FRWR should trigger it as wel, so we are
>> already about to revert that workaround.
>>
>> I'm inclined to drop this entirely.. What do you think Bart?
>
> Even today I see memory corruption at the initiator side with FMR and
> not with FR if I leave out the alignment check. Since this only occurs
> with FMR and not with FR that excludes the target side as a possible
> cause. I will have a closer look at the srp_map_finish_fmr() function.
> Always passing 0 as the second argument of srp_map_desc() in
> srp_map_finish_fmr() is probably wrong. Before 2011 that second argument
> was the page offset of the first sg-list entry.

(replying to my own e-mail)

The patch below makes FMR registration work again for buffers that are 
not aligned on a page boundary.

Regarding the discussion in 2011 about FMR 
(http://thread.gmane.org/gmane.linux.drivers.rdma/7149): since in 2011 
nobody recalled the root cause of the issue with non-page aligned FMR my 
proposal is to drop the page alignment check and if any issues occur to 
introduce a blacklist for the SRP target devices that have trouble with 
this.

Bart.


[PATCH] IB/srp: Restore FMR offset

Since srp_map_finish_fmr() is always called with base_dma_addr aligned
on a page boundary this patch does not change any functionality. See
also patch "IB/srp: rework mapping engine to use multiple FMR entries"
(commit ID 8f26c9ff9cd0; January 2011).
---
  drivers/infiniband/ulp/srp/ib_srp.c | 5 ++++-
  1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c 
b/drivers/infiniband/ulp/srp/ib_srp.c
index 48201b3..cac444e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1272,6 +1272,8 @@ static void srp_map_desc(struct srp_map_state 
*state, dma_addr_t dma_addr,
  static int srp_map_finish_fmr(struct srp_map_state *state,
  			      struct srp_rdma_ch *ch)
  {
+	struct srp_target_port *target = ch->target;
+	struct srp_device *dev = target->srp_host->srp_dev;
  	struct ib_pool_fmr *fmr;
  	u64 io_addr = 0;

@@ -1283,7 +1285,8 @@ static int srp_map_finish_fmr(struct srp_map_state 
*state,
  	*state->next_fmr++ = fmr;
  	state->nmdesc++;

-	srp_map_desc(state, 0, state->dma_len, fmr->fmr->rkey);
+	srp_map_desc(state, state->base_dma_addr & ~dev->mr_page_mask,
+		     state->dma_len, fmr->fmr->rkey);

  	return 0;
  }
-- 
2.1.4



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
