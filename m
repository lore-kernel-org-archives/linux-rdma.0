From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH for-next 03/10] IB/iser: Don't register memory for all
 immediatedata writes
Date: Mon, 23 Nov 2015 11:13:43 -0700
Message-ID: <20151123181343.GB32085@obsidianresearch.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-4-git-send-email-sagig@mellanox.com>
 <564ADB7D.20806@mellanox.com>
 <564AF653.6060401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564AF653.6060401@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 17, 2015 at 11:41:39AM +0200, Sagi Grimberg wrote:
> 
> >On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
> >>+++ b/drivers/infiniband/ulp/iser/iser_memory.c
> >>@@ -250,7 +250,7 @@ iser_reg_dma(struct iser_device *device, struct
> >>iser_data_buf *mem,
> >>      struct scatterlist *sg = mem->sg;
> >>      reg->sge.lkey = device->pd->local_dma_lkey;
> >>-    reg->rkey = device->mr->rkey;
> >>+    reg->rkey = device->mr ? device->mr->rkey : 0;
> >>      reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
> >>      reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
> >
> >what's the role of this hunk? why it belongs here? you are testing
> >device->mr but this is
> >something global and has nothing to do specially with specific IOs for
> >which this patch
> >aims to act
> 
> It's because device->mr might not be allocated at all if
> always_register=Y, however in this case for all-immediatedata writes
> I don't need memory registration and I can use pd->local_dma_lkey.

I'm with Or on this, this is really goofy looking.

This routine probably should not be setting the rkey at all, it makes
no sense to have a routine that returns a lkey and a rkey. Those are
always different flows.

Once that is fixed then the above if can be hoisted to the actual
calling code that needs an rkey, at the point where it does something
different when !iser_always_reg is true..

Jason
