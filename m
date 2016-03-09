From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 05/11] xprtrdma: Do not wait if ib_post_send() fails
Date: Wed, 9 Mar 2016 13:09:55 +0200
Message-ID: <56E00483.2060304@dev.mellanox.co.il>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
 <20160304162801.13590.89343.stgit@oracle120-ib.cthon.org>
 <56DF1186.3030303@dev.mellanox.co.il>
 <8696EFBA-B7DB-42AC-AB57-C656070F4ED3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8696EFBA-B7DB-42AC-AB57-C656070F4ED3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 08/03/2016 20:03, Chuck Lever wrote:
>
>> On Mar 8, 2016, at 12:53 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>
>>
>>
>> On 04/03/2016 18:28, Chuck Lever wrote:
>>> If ib_post_send() in ro_unmap_sync() fails, the WRs have not been
>>> posted, no completions will fire, and wait_for_completion() will
>>> wait forever. Skip the wait in that case.
>>>
>>> To ensure the MRs are invalid, disconnect.
>>
>> How does that help to ensure that?
>
> I should have said "To ensure the MRs are fenced,"
>
>> The first wr that failed and on will leave the
>> corresponding MRs invalid, and the others will be valid
>> upon completion.
>
> ? This is in the invalidation code, not in the fastreg
> code.

Yes, I meant linv...

> When this ib_post_send() fails, I've built a set of
> chained LOCAL_INV WRs, but they never get posted. So
> there is no WR failure here, the WRs are simply
> never posted, and they won't complete or flush.

That's the thing, some of them may have succeeded.
if ib_post_send() fails on a chain of posts, it reports
which wr failed (in the third wr pointer).

Moving the QP into error state right after with rdma_disconnect
you are not sure that none of the subset of the invalidations
that _were_ posted completed and you get the corresponding MRs
in a bogus state...

> I suppose I could reset these MRs instead (that is,
> pass them to ib_dereg_mr).

Or, just wait for a completion for those that were posted
and then all the MRs are in a consistent state.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
