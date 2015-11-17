From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 03/10] IB/iser: Don't register memory for all
 immediatedata writes
Date: Tue, 17 Nov 2015 09:47:09 +0200
Message-ID: <564ADB7D.20806@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
> @@ -250,7 +250,7 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
>   	struct scatterlist *sg = mem->sg;
>   
>   	reg->sge.lkey = device->pd->local_dma_lkey;
> -	reg->rkey = device->mr->rkey;
> +	reg->rkey = device->mr ? device->mr->rkey : 0;
>   	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
>   	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
>   

what's the role of this hunk? why it belongs here? you are testing 
device->mr but this is
something global and has nothing to do specially with specific IOs for 
which this patch
aims to act
