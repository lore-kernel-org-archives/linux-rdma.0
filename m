From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Wed, 9 Mar 2016 18:48:08 +0200
Message-ID: <56E053C8.8050008@dev.mellanox.co.il>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com>
 <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
 <20160308175334.GB10805@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308175334.GB10805-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/8/2016 7:53 PM, Jason Gunthorpe wrote:
> On Tue, Mar 08, 2016 at 04:24:51PM +0530, Devesh Sharma wrote:
>
>>> +++ b/drivers/infiniband/core/uverbs_main.c
>>> @@ -962,9 +962,9 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
>>>                  list_del(&file->list);
>>>                  file->is_closed = 1;
>>>          }
>>> -       mutex_unlock(&file->device->lists_mutex);
>>>          if (ucontext)
>>>                  ib_uverbs_cleanup_ucontext(file, ucontext);
>>> +       mutex_unlock(&file->device->lists_mutex);
>>>
>>>
>>> ??
>>
>> There is following comment about list_mutex in uverbs_main.c around
>> line number 1200:
>> /* We must release the mutex before going ahead and calling
>>   * disassociate_ucontext. disassociate_ucontext might end up
>>   * indirectly calling uverbs_close, for example due to freeing
>>   * the resources (e.g mmput).
>>   */
>
> Okay, now I remember this discussion, and being unhappy about this
> during review.
>
> However, this comment is talking about disassociate_ucontext, the bug
> is with ib_uverbs_cleanup_ucontext. We can't re-entre uverbs_close
> while we are already in uverbs_close, so that doesn't explain why it
> cannot be in the mutex.
>
> So, Yishai, what is the problem with the above lock placement?
>
> The only issue you raised was with multi-file close concurrency, and
> that is trivially solved with another mutex.
>
> I'd rather see another mutex added then this ugly add-hoc
> srcu/completion thing.

The srcu with NULL checking by itself can prevent the race, no need for 
the "completion" mechanism. ib_uverbs_free_hw_resources uses 
synchronize_srcu just after that ib_dev was set to NULL as part of 
ib_uverbs_remove_one.

The reason for the extra "completion" that I suggested comes to make 
sure that when an application returns from its close API the underlying 
resources were really freed, this is open in current code even if the 
race *wasn't* hit.

As we need to enable parallel closing it seems to be the preferred way 
to go.

Devesh, can you send V3 with above suggestion to help people reviewing 
it ? if you have some other solution with mutex that addressed above 
points please come it to the list for a review.






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
