From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Wed, 1 Mar 2017 16:05:06 -0700
Message-ID: <20170301230506.GB2820@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301175521.GB14791@obsidianresearch.com>
 <20170301221420.GA18548@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301221420.GA18548-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 04:14:20PM -0600, Shiraz Saleem wrote:
> > Is there DMA occuring to shadow_area?
> 
> The shadow area contains status variables which are read by SW and 
> updated by PCI device.

So the device is DMA'ing to it, and the driver is reading DMA memory..

> > What can wrong if it executes like this?
> > 
> > get_64bit_val(qp->shadow_area, I40IW_BYTE_0, &temp);
> > udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
> > set_64bit_val(wqe, I40IW_BYTE_24, header);
> > udma_to_device_barrier();
> 
> We need strict ordering that ensures write of the WQE completes before 
> read of the shadow area.

> This ensures the value read from the shadow can be used to determine
> if a DB ring is needed. If the shadow area is read first, the
> algorithm, in certain cases, would not ring the DB when it should
> and the HW may go idle with work requests posted.

This still is not making a lot of sense to me.. I really need to see a
ladder diagram to understand your case.

Here is an example, I think what you are saying is: The HW could have
fetched valid = 0 and stopped the queue and the driver needs to
doorbell it to wake it up again. However, the driver optimizes away
the doorbell rings in certain cases based on reading a DMA result.

So here is a possible ladder diagram:

CPU                         DMA DEVICE
                            Issue READ#1 of valid bit
 Respond to READ#1
 SFENCE
 set_valid_bit
 MEFENCE
 read_tail
                            Receive READ#1 response with valid bit unset
			    Issue DMA WRITE to shadow_area indicating STOPPED
 DMA WRITE arrives

And the version where the DMA is seen:

CPU                         DMA DEVICE
                            Issue READ#1 of valid bit
 SFENCE
 Respond to READ#1
 set_valid_bit
 MEFENCE
                            Receive READ#1 response with valid bit unset
			    Issue DMA WRITE to shadow_area indicating STOPPED
 DMA WRITE arrives
 read_tail

These diagrams attempt to show that the DMA device reads the valid bit
then DMA's back to the shadow_area depending on what it read.

Given the semantics of MFENCE, both are possible, so I still don't
understand what the MFENCE is supposed to help with.

I get the feeling this approach requires MFENCE to do something it
doesn't...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
