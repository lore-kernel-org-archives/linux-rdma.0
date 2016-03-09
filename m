From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/11] xprtrdma: Do not wait if ib_post_send() fails
Date: Wed, 9 Mar 2016 16:40:11 -0500
Message-ID: <56E0983B.2000102@Netapp.com>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
 <20160304162801.13590.89343.stgit@oracle120-ib.cthon.org>
 <56DF1186.3030303@dev.mellanox.co.il>
 <8696EFBA-B7DB-42AC-AB57-C656070F4ED3@oracle.com>
 <56E00483.2060304@dev.mellanox.co.il>
 <6B59B087-9CFA-458B-8848-B08B8E14E2C7@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6B59B087-9CFA-458B-8848-B08B8E14E2C7-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/09/2016 03:47 PM, Chuck Lever wrote:
> 
>> On Mar 9, 2016, at 6:09 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>
>>
>>
>> On 08/03/2016 20:03, Chuck Lever wrote:
>>>
>>>> On Mar 8, 2016, at 12:53 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>>>
>>>>
>>>>
>>>> On 04/03/2016 18:28, Chuck Lever wrote:
>>>>> If ib_post_send() in ro_unmap_sync() fails, the WRs have not been
>>>>> posted, no completions will fire, and wait_for_completion() will
>>>>> wait forever. Skip the wait in that case.
>>>>>
>>>>> To ensure the MRs are invalid, disconnect.
>>>>
>>>> How does that help to ensure that?
>>>
>>> I should have said "To ensure the MRs are fenced,"
>>>
>>>> The first wr that failed and on will leave the
>>>> corresponding MRs invalid, and the others will be valid
>>>> upon completion.
>>>
>>> ? This is in the invalidation code, not in the fastreg
>>> code.
>>
>> Yes, I meant linv...
>>
>>> When this ib_post_send() fails, I've built a set of
>>> chained LOCAL_INV WRs, but they never get posted. So
>>> there is no WR failure here, the WRs are simply
>>> never posted, and they won't complete or flush.
>>
>> That's the thing, some of them may have succeeded.
>> if ib_post_send() fails on a chain of posts, it reports
>> which wr failed (in the third wr pointer).
> 
> I see.
> 
> 
>> Moving the QP into error state right after with rdma_disconnect
>> you are not sure that none of the subset of the invalidations
>> that _were_ posted completed and you get the corresponding MRs
>> in a bogus state...
> 
> Moving the QP to error state and then draining the CQs means
> that all LOCAL_INV WRs that managed to get posted will get
> completed or flushed. That's already handled today.
> 
> It's the WRs that didn't get posted that I'm worried about
> in this patch.
> 
> Are there RDMA consumers in the kernel that use that third
> argument to recover when LOCAL_INV WRs cannot be posted?
> 
> 
>>> I suppose I could reset these MRs instead (that is,
>>> pass them to ib_dereg_mr).
>>
>> Or, just wait for a completion for those that were posted
>> and then all the MRs are in a consistent state.
> 
> When a LOCAL_INV completes with IB_WC_SUCCESS, the associated
> MR is in a known state (ie, invalid).
> 
> The WRs that flush mean the associated MRs are not in a known
> state. Sometimes the MR state is different than the hardware
> state, for example. Trying to do anything with one of these
> inconsistent MRs results in IB_WC_BIND_MW_ERR until the thing
> is deregistered.
> 
> The xprtrdma completion handlers mark the MR associated with
> a flushed LOCAL_INV WR "stale". They all have to be reset with
> ib_dereg_mr to guarantee they are usable again. Have a look at
> __frwr_recovery_worker().
> 
> And, xprtrdma waits for only the last LOCAL_INV in the chain to
> complete. If that one isn't posted, then fr_done is never woken
> up. In that case, frwr_op_unmap_sync() would wait forever.
> 
> If I understand you I think the correct solution is for
> frwr_op_unmap_sync() to regroup and reset the MRs associated
> with the LOCAL_INV WRs that were never posted, using the same
> mechanism as __frwr_recovery_worker() .
> 
> It's already 4.5-rc7, a little late for a significant rework
> of this patch, so maybe I should drop it?

Git doesn't have any conflicts if I drop the patch from my tree, and I was still able to compile.  Let me know if you want me to drop the patch from my tree, so you don't have to resend an entire series!

Thanks,
Anna

> 
> 
> --
> Chuck Lever
> 
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
