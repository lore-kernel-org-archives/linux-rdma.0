From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 9/9] IB/srpt: convert to the generic RDMA READ/WRITE
 API
Date: Thu, 10 Mar 2016 14:08:39 -0800
Message-ID: <56E1F067.7020807@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-10-git-send-email-hch@lst.de>
 <20160308201342.GL13396@leon.nu> <20160309125941.GC31210@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160309125941.GC31210@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dledford@redhat.com, sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/09/2016 04:59 AM, Christoph Hellwig wrote:
>> You can jump to unwind label from one place only. In that stage
>> "ioctx->rw_ctxs != NULL" will always be true.
>
> There's two places actually, but it can't be NULL for both, so I
> will removed that condition.
>
> I'll update the git tree with the current review feedback, but I'll
> wait for you to finish the review before resending it.

Since it is safe to pass NULL to kfree() I think a similar comment 
applies to srpt_free_rw_ctxs() and that also from that function 
"ioctx->rw_ctxs && " can be left out.

Bart.
