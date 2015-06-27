From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Sat, 27 Jun 2015 12:33:04 +0300
Message-ID: <558E6DD0.90104@mellanox.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
 <20150625182505.GA15337@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com>
 <005a01d0af75$70c9eb60$525dc220$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9D96@ORSMSX109.amr.corp.intel.com>
 <20150625191220.GA15726@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF9DF9@ORSMSX109.amr.corp.intel.com>
 <006901d0af7c$be6c04a0$3b440de0$@opengridcomputing.com>
 <20150625192934.GB15726@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625192934.GB15726-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Roi Dayan' <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 10:29 PM, Jason Gunthorpe wrote:
> On Thu, Jun 25, 2015 at 02:25:49PM -0500, Steve Wise wrote:
>
>> To stage the changes we could introduce a new function that returns
>> the needed ib_access_flags value given the desired opcodes.  Then
>> have a series that changes all the existing ULPs to make use of this
>> new function.
>
> I wouldn't be afraid to add a new create_mr entry point that does the
> right thing, we can unexport/delete the old one when all kernel users
> are gone. Trivially the core can just have a default that translates
> based on iwarp/!iwarp for now.
>

Note that we have ib_create_mr() that receives an easily extensible
ib_mr_init_attr (similar to qp creation). I think this is a good
opportunity to unite all the create routines to ib_create_mr.

ib_get_dma_mr will become:
ib_mr_init_attr.type = IB_MR_DMA;
ib_mr_init_attr.mr_access_flags = mr_access_flags;
ib_create_mr(pd, &ib_mr_init_attr);

ib_alloc_fast_reg_mr will become:
ib_mr_init_attr.type = IB_MR_FAST_REG;
ib_create_mr(pd, &ib_mr_init_attr);

ib_reg_phys_mr (if we don't want to kill it by now) will become:
ib_mr_init_attr.type = IB_MR_REG_PHYS;
ib_mr_init_attr.arr = phys_buf_array;
ib_mr_init_attr.max_reg_descriptors = num_phys_buf;
ib_mr_init_attr.mr_access_flags = mr_access_flags;
ib_mr_init_attr.iova_start = iova_start;
ib_create_mr(pd, &ib_mr_init_attr);

The core layer will spread these in the different driver routines
(although it would be nice if the drivers can have a single MR craetion
routine that can handle all MR types (including fail if unsupported).

Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
