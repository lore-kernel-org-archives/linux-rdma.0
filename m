From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 13:42:29 +0200
Message-ID: <5641D825.9080008@mellanox.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110113839.GA32523@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151110113839.GA32523-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 10/11/2015 13:38, Christoph Hellwig wrote:
> On Tue, Nov 10, 2015 at 12:44:14PM +0200, Sagi Grimberg wrote:
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -238,7 +238,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
>>   	read = min_t(int, nents << PAGE_SHIFT, rs_length);
>>
>>   	frmr->direction = DMA_FROM_DEVICE;
>> -	frmr->access_flags = (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRITE);
>> +	frmr->access_flags = xprt->sc_cm_id->device->rdma_read_access_flags;
>>   	frmr->sg_nents = nents;
>
> I think you can simply drop the access_flags member and use
> rdma_read_access_flags directly later in the function.
>

I will.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
