From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send
 limit
Date: Wed, 27 Jul 2016 08:24:32 -0700
Message-ID: <8604bcdc-3ab4-28df-0eff-b1c0b6865c71@sandisk.com>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
 <c71ece34-36e2-86da-5032-2fc946ff0073@sandisk.com>
 <20160727124217.GJ4628@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727124217.GJ4628-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/27/2016 05:42 AM, Leon Romanovsky wrote:
> On Thu, Jul 21, 2016 at 01:03:30PM -0700, Bart Van Assche wrote:
>>  static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
>>  {
>>  	/* arbitrary limit to avoid allocating gigantic resources */
>> @@ -186,7 +179,8 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
>>  		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
>>  {
>>  	struct ib_device *dev = qp->pd->device;
>> -	u32 max_sge = rdma_rw_max_sge(dev, dir);
>> +	u32 max_sge = dir == DMA_TO_DEVICE ? qp->max_write_sge :
>> +		      qp->max_read_sge;
>
> Bart,
> I'm sure that I missed something.
>
> Can "dir" be DMA_BIDIRECTIONAL?
> If yes, mxa_sge will be min(max_write_sge, max_read_sge).

Hello Leon,

The RDMA R/W API is intended for target drivers. None of the upstream 
target drivers (ib_isert, ib_srpt, nvmet) that use the RDMA R/W API 
support bidi commands today. And even if such support would be added, 
these target drivers should perform RDMA READs and WRITEs in two phases. 
So I do not expect that "dir" will ever be equal to DMA_BIDIRECTIONAL in 
the above code.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
