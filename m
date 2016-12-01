From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] ibverbs: Allow vendor data response in
 create_ah command
Date: Thu, 1 Dec 2016 18:30:05 +0200
Message-ID: <c9eb6ee8-e3ca-a540-82f5-0b3580b00c78@dev.mellanox.co.il>
References: <1480602353-8600-1-git-send-email-yishaih@mellanox.com>
 <1480602353-8600-2-git-send-email-yishaih@mellanox.com>
 <20161201160058.GA22216@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161201160058.GA22216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/1/2016 6:00 PM, Jason Gunthorpe wrote:
> On Thu, Dec 01, 2016 at 04:25:52PM +0200, Yishai Hadas wrote:
>> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Let caller pass response buffer and response size to ibv_cmd_create_ah
>> to enable kernel driver to return some private vendor data.
>>
>> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>  libibverbs/cmd.c                | 11 ++++++-----
>>  libibverbs/driver.h             |  4 +++-
>>  providers/hfi1verbs/verbs.c     |  4 +++-
>>  providers/ipathverbs/verbs.c    |  4 +++-
>>  providers/ocrdma/ocrdma_verbs.c |  4 +++-
>>  providers/rxe/rxe.c             |  4 +++-
>>  6 files changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
>> index 06a017b..eaf7164 100644
>> +++ b/libibverbs/cmd.c
>> @@ -1492,12 +1492,13 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
>>  }
>>
>>  int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
>> -		      struct ibv_ah_attr *attr)
>> +		      struct ibv_ah_attr *attr,
>> +		      struct ibv_create_ah_resp *resp,
>> +		      size_t resp_size)
>
> NAK without changing the name of this function..
>
> We need to decide if we want to have comapt for ibv_cmd_ driver facing
> entry points, or discard that idea now that we only have one tree.
>

The idea was that moving to one tree can drop the need to maintain 2 
different symbols, all vendors around where changed to use the new 
command. As this API is not used directly by an applications I don't see 
a real need for 2 APIs.

I don't believe that we should support legacy provider library *not* 
from this tree to run with libibverbs *from* that tree, all expect to 
come in one package.

Maybe let Doug and other people comment on as well.

> In this case it would be easy to provide two symbol versions for this
> change so maybe that is what you should do..

It can be done, however as pointed above it seems redundant, going in 
that approach won't give us the chance to enjoy from the consolidate 
rdma user space in those areas.
.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
