From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Fri, 11 Mar 2016 10:22:58 +0100
Message-ID: <20160311092258.GD28498@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com> <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de> <56E21EBB.6060205@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E21EBB.6060205@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 10, 2016 at 05:26:19PM -0800, Bart Van Assche wrote:
> On 03/09/2016 07:54 AM, Christoph Hellwig wrote:
>> +		if (i + 1 != ctx->nr_ops)
>> +			rdma_wr->wr.next = &ctx->map.wrs[i + 1].wr;
>
> Not that this really matters, but my own preference is to write such a 
> comparison as i + 1 < ctx->nr_ops.

Sure, not problem.

>> @@ -787,6 +799,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>>
>>   	atomic_inc(&pd->usecnt);
>>   	atomic_inc(&qp_init_attr->send_cq->usecnt);
>> +
>> +	if (qp_init_attr->cap.max_rdma_ctxs) {
>> +		ret = rdma_rw_init_mrs(qp, qp_init_attr);
>> +		if (ret) {
>> +			pr_err("failed to init MR pool ret= %d\n", ret);
>> +			ib_destroy_qp(qp);
>> +			qp = ERR_PTR(ret);
>> +		}
>> +	}
>
> ib_destroy_qp() can fail and if it fails it does not decrement pd->usecnt. 
> Does this have to be handled or reported in some way?

There is no way to handle this properly, and we really should remove
the return value better sooner than later in the destroy_qp API [1].

[1] and various other verbs APIs that return errors on the destroy APIs,
    whoever created these was on crack apparently.
