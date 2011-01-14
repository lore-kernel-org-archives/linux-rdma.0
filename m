From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch (was: [PATCH
 1/1 (resend)] mthca: Modify to support embedded PowerPC platforms)
Date: Fri, 14 Jan 2011 10:27:21 -0700
Message-ID: <20110114172721.GB16535@obsidianresearch.com>
References: <ig5vl1$j0$1@dough.gmane.org>
 <adafwt06puj.fsf@cisco.com>
 <4D2D5FAD.6030508@cadence.com>
 <adahbde57r7.fsf_-_@cisco.com>
 <20110114130903.GA29706@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110114130903.GA29706@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 14, 2011 at 03:09:03PM +0200, Eli Cohen wrote:

> CX devices are 64 bit devices with respect to the PCI bus. As far as I
> know, a 64 bit PCI device memory space, could be placed anywhere in
> that space regardless of the CPU architecture. So I think it would
> be

Linux limits the addresses of PCI devices to phys_addr_t, so if your
device is placed outside phys_addr_t by the BIOS then it will be
discarded during discovery. Thus phys_addr_t/resource_size_t is
appropriate for storing BAR addresses from PCI devices.

> Regardless of whether what I say above is correct or not, wouldn't it
> be nicer to to define pfn as either u64 or phys_addr_t and avoid the
> casting?

Good point, the pfn must be stored as phys_addr_t too, otherwise you
only support a 44 bit physical address space before truncatation
occures.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
