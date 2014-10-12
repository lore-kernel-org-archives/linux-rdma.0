From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] Indirect Fast Memory registration support
Date: Sun, 12 Oct 2014 21:43:09 +0200
Message-ID: <543AD9CD.80803@mellanox.com>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412693281-6161-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, bvanassche-HInyCGIudOg@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 10/7/2014 4:47 PM, Sagi Grimberg wrote:
> This patch set introduces support for registering a scattered
> memory area in an indirect manner.
>
> Current supported fast registration support has a known limitation
> where the memory must be page aligned, meaning memory scatters must
> be in chunks of page size except the first which may be in some offset
> from the start of a page and the last which may end before the page
> boundary.
>
> This can make life hard for ULPs which may serve a scattered list without
> the above limitations. Two immediate examples are iSER and SRP that have
> some extra logic or work-arounds to handle an arbitrary scatter list of
> buffers (which is supported in the entire stack above them).

Sagi,

The proposed API looks OK to me -- it  will solve us in iSER the long 
standing real life issue
with SGs delivered by the SCSI MID layer which are unaligned for FMRs 
and FastReg MRs.

Sean, Bart - any comment on the API before Sagi sits down to code the 
iSER changes?

Or.

>
> The proposed API attempts to follow the well-known fast registration scheme
> while allowing the ULP to pass an sg vector rather than a page list (u64 vector).
> I expect ULPs to make use of the global DMA key to populate the lkey of the
> sg vector. for example for a scatter list sg of 3 elements the indirect ib_sge
> vector will look like:
> ib_sge[0]: {dma_key, sg[0]->dma_addr, sg[0]->length}
> ib_sge[1]: {dma_key, sg[1]->dma_addr, sg[1]->length}
> ib_sge[2]: {dma_key, sg[2]->dma_addr, sg[2]->length}
>
> Following this patch set I'll send out a usage for this feature in iSER.
> In the meantime, I have a working example of krping utility practicing indirect
> registration feature at: git://flatbed.openfabrics.org/~sgrimberg/krping.git
> (branch: indir_registration)
>
> Sagi Grimberg (2):
>    IB/core: Introduce Fast Indirect Memory Registration verbs API
>    IB/mlx5: Implement Fast Indirect Memory Registration Feature
>
>   drivers/infiniband/core/verbs.c      |   29 +++++++++
>   drivers/infiniband/hw/mlx5/cq.c      |    2 +
>   drivers/infiniband/hw/mlx5/main.c    |    4 +
>   drivers/infiniband/hw/mlx5/mlx5_ib.h |   20 +++++++
>   drivers/infiniband/hw/mlx5/mr.c      |   70 ++++++++++++++++++++++-
>   drivers/infiniband/hw/mlx5/qp.c      |  104 ++++++++++++++++++++++++++++++++++
>   include/rdma/ib_verbs.h              |   55 +++++++++++++++++-
>   7 files changed, 280 insertions(+), 4 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
