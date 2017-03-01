From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Wed, 1 Mar 2017 10:55:21 -0700
Message-ID: <20170301175521.GB14791@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301172920.GA11340-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 11:29:20AM -0600, Shiraz Saleem wrote:

> The constraint here is that the writes to SQ WQE must be globally
> visible to the PCIe device before the read of the shadow area.

I'm struggling to understand how this can make any sense..

It looks like shadow_area is in system memory:

providers/i40iw/i40iw_uverbs.c: info.cq_base = memalign(I40IW_HW_PAGE_SIZE, totalsize);
providers/i40iw/i40iw_uverbs.c: info.shadow_area = (u64 *)((u8 *)info.cq_base + (cq_pages << 12));
providers/i40iw/i40iw_uk.c:     qp->shadow_area = info->shadow_area;

Is there DMA occuring to shadow_area?

Is this trying to implement CPU atomics in shadow_area for SMP?

I'm struggling to understand what a store/load barrier should even do
when talking about DMA.

> For x86, since loads can be reordered with older stores to a
> different location, we need some sort of a storeload barrier to
> enforce the constraint and hence the mfence was chosen. The
> udma_to_device_barrier() equates to just a compiler barrier on x86
> and isn't sufficient for this purpose.

We've never had MFENCE in our set of standard barriers. If it really
is a needed operation for DMA then we will have to add a new barrier
macro for it.

However - I can't explain what that macro should be doing relative to
DMA, so I need more help.. Can you diagram a ladder chart to show the
issue?

This is the sequence at the CPU we are looking at:

udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
set_64bit_val(wqe, I40IW_BYTE_24, header);
udma_to_device_barrier();
get_64bit_val(qp->shadow_area, I40IW_BYTE_0, &temp);

What is the 2nd actor doing? Is it DMA from the PCI-E device? Is it
another SMP core?

What can wrong if it executes like this?

get_64bit_val(qp->shadow_area, I40IW_BYTE_0, &temp);
udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
set_64bit_val(wqe, I40IW_BYTE_24, header);
udma_to_device_barrier();

Is this the only barrier you are worried about?
Are the other changes OK?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
