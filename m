From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Tue, 8 Mar 2016 16:33:53 +0200
Message-ID: <56DEE2D1.60300@dev.mellanox.co.il>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com>
 <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/8/2016 12:54 PM, Devesh Sharma wrote:
>> What is wrong with simply this:
>>
>> --- a/drivers/infiniband/core/uverbs_main.c
>> +++ b/drivers/infiniband/core/uverbs_main.c
>> @@ -962,9 +962,9 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
>>                  list_del(&file->list);
>>                  file->is_closed = 1;
>>          }
>> -       mutex_unlock(&file->device->lists_mutex);
>>          if (ucontext)
>>                  ib_uverbs_cleanup_ucontext(file, ucontext);
>> +       mutex_unlock(&file->device->lists_mutex);
>>
>>
>> ??
>
> There is following comment about list_mutex in uverbs_main.c around
> line number 1200:
> /* We must release the mutex before going ahead and calling
>   * disassociate_ucontext. disassociate_ucontext might end up
>   * indirectly calling uverbs_close, for example due to freeing
>   * the resources (e.g mmput).
>   */
>

Correct.

In addition it's very *bad/incorrect* to call ib_uverbs_cleanup_ucontext 
under the list mutex as it will prevent parallel cleanups of different 
contexts, this may end up with softlock ups as cleanup may involve FW 
commands and may take time.

The correct solution is as I described in my comments to V2, need V3 
with the fixes.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
