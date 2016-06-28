From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/core: Make rdma_rw_ctx_init() initialize all used
 fields
Date: Tue, 28 Jun 2016 15:04:48 +0200
Message-ID: <a5ce1e23-e04e-029c-d698-5aa07e88bbaa@sandisk.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com>
 <91e53f7b-fdb6-bd66-ada6-982c641c2048@sandisk.com>
 <20160628115105.GA28113@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160628115105.GA28113-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/28/2016 01:51 PM, Christoph Hellwig wrote:
> On Tue, Jun 28, 2016 at 01:25:15PM +0200, Bart Van Assche wrote:
>> -		if (i + 1 < ctx->nr_ops)
>> -			rdma_wr->wr.next = &ctx->map.wrs[i + 1].wr;
>> +		rdma_wr->wr.next = i + 1 < ctx->nr_ops ?
>> +			&ctx->map.wrs[i + 1].wr : NULL;
>
> I think the rdma_rw_ctx_wrs should take care of this as well.

I agree that it is possible to let rdma_rw_ctx_wrs() initialize wr.next 
of the last WR. But if we chose that approach then drivers that call 
rdma_rw_ctx_init() but not rdma_rw_ctx_wrs(), e.g. ib_isert, can end up 
with a last wr.next field that has not been initialized. Hence my 
preference for performing that initialization in rdma_rw_init_mr_wrs() 
and rdma_rw_init_map_wrs().

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
