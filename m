From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/12] IB/srpt: convert to the generic RDMA READ/WRITE
	API
Date: Thu, 14 Apr 2016 15:32:55 +0200
Message-ID: <20160414133255.GA22523@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-11-git-send-email-hch@lst.de> <570E96B5.5030002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570E96B5.5030002@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, dledford@redhat.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 13, 2016 at 11:57:57AM -0700, Bart Van Assche wrote:
> On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
>>   static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
>> -			     struct srp_cmd *srp_cmd,
>> -			     enum dma_data_direction *dir, u64 *data_len)
>> +		struct srp_cmd *srp_cmd, enum dma_data_direction *dir,
>> +		struct scatterlist **sg, unsigned *sg_cnt, u64 *data_len)
>>   {
> [ ... ]
>>
>> -		db = idb->desc_list;
>> -		memcpy(ioctx->rbufs, db, ioctx->n_rbuf * sizeof(*db));
>>   		*data_len = be32_to_cpu(idb->len);
>> +		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
>> +				sg, sg_cnt);
>> +	} else {
>> +		*data_len = 0;
>> +		return 0;
>>   	}
>> -out:
>> -	return ret;
>>   }
>
> srpt_get_desc_tbl() only has one caller. Have you considered to move 
> srpt_alloc_rw_ctxs() from this function to the caller of 
> srpt_get_desc_tbl()?

I looked into a couple options.  srpt_alloc_rw_ctxs needs the
pointer to the srp_direct_buf array, and the number of buffers, so we'd
need two more output arguments to srpt_get_desc_tbl, so it didn't
seem worthwhile to me.  If you want me to make the change anyway, I can
update the patch.
