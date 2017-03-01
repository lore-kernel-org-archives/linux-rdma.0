From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Wed, 1 Mar 2017 16:14:20 -0600
Message-ID: <20170301221420.GA18548@ssaleem-MOBL4.amr.corp.intel.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301175521.GB14791@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301175521.GB14791-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 10:55:21AM -0700, Jason Gunthorpe wrote:
> On Wed, Mar 01, 2017 at 11:29:20AM -0600, Shiraz Saleem wrote:
> 
> 
> Is there DMA occuring to shadow_area?

The shadow area contains status variables which are read by SW and 
updated by PCI device.

> 
> Is this trying to implement CPU atomics in shadow_area for SMP?

No.

> What can wrong if it executes like this?
> 
> get_64bit_val(qp->shadow_area, I40IW_BYTE_0, &temp);
> udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
> set_64bit_val(wqe, I40IW_BYTE_24, header);
> udma_to_device_barrier();

We need strict ordering that ensures write of the WQE completes before 
read of the shadow area. This ensures the value read from the shadow can 
be used to determine if a DB ring is needed. If the shadow area is read first, 
the algorithm, in certain cases, would not ring the DB when it should and the 
HW may go idle with work requests posted.

> Is this the only barrier you are worried about?
> Are the other changes OK?

This is of most concern. The other changes look ok. Being reviewed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
