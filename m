From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ewg] Mellanox target workaround in SRP
Date: Mon, 10 Jan 2011 14:02:43 -0500
Message-ID: <1294686163.3038.12.camel@obelisk.thedillows.org>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>
	 <adaipy09h0i.fsf@cisco.com>
	 <1294510396.7914.82.camel@obelisk.thedillows.org>
	 <4D2B4E13.6070903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D2B4E13.6070903-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-01-10 at 10:21 -0800, Vu Pham wrote:
> David Dillow wrote:
> > On Fri, 2011-01-07 at 20:05 -0800, Roland Dreier wrote:
> >> looking at the patch, I would guess that the corruption occurred when
> >> the target got an IO request that started at a non-page-aligned address
> >> but that spanned more than one page.
[snip]
> > Here's hoping someone from Mellanox can shed some light.
> 
> 
> I think that the patch is specific for srp initiator using Mellanox
> FMR. It tried to avoid indirect desc with Mellanox FMR having
> first-byte-offset != 0.
> Since the low level implementation of mlx4/mthca_map_phys_fmr() did
> not create + setup MPT for FMR with first_byte_offset != 0. The
> corruption can happen with any target.

Thanks for taking a look Vu -- but I'm not sure that is the problem,
either. The SRP FMR mapping code is careful to mask the SG address with
the FMR page mask, so we should never ask the HCA to map a page with the
first_byte_offset != 0. Instead, we tell the target to request an IO
virtual address appropriately offset into the first page of the FMR.

Or perhaps I misunderstood you, and it's the non-zero first byte offset
in the RDMA command on the wire that is the issue, and not the FMR setup
in the initiator? And it only affects FMR-mapped memory, not the
kernel's MR?

Thanks again,
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
