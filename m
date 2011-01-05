From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband/mthca : Fix userland mapping of mthca infiniband cards in Xen dom0
Date: Wed, 05 Jan 2011 11:35:59 -0800
Message-ID: <adamxnfdty8.fsf@cisco.com>
References: <1293034260.30522.426.camel@trax>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293034260.30522.426.camel@trax> (Vivien Bernet-Rollande's
	message of "Wed, 22 Dec 2010 17:11:00 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivien Bernet-Rollande <vbr-GKN1HSsW2S7R7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org, Jeremy Fitzhardinge <jeremy-TSDbQ3PG+2Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > --- kernel-2.6.32.fc12.orig/drivers/infiniband/hw/mthca/mthca_provider.c	2010-12-16 16:39:06.901130993 +0100
 > +++ kernel-2.6.32.fc12.new/drivers/infiniband/hw/mthca/mthca_provider.c	2010-12-16 17:02:07.944127489 +0100
 > @@ -391,6 +391,8 @@ static int mthca_mmap_uar(struct ib_ucon
 >  	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 >  		return -EINVAL;
 >  
 > +	vma->vm_flags |= VM_IO;
 > +	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 >  
 >  	if (io_remap_pfn_range(vma, vma->vm_start,

This is kind of unappealing -- is there no way to make
io_remap_pfn_range do the right thing under Xen?  It seems unfortunate
to make drivers both set VM_IO and call io_remap_pfn_range.  Or maybe we
should get rid of io_remap_pfn_range() and just have drivers set VM_IO
and call remap_pfn_range() all the time?

There are quite a few drivers under drivers/infiniband/hw that call
io_remap_pfn_range() -- presumably they all need the analogous fix?

Finally as a stylistic thing I would probably prefer to see the
vm_page_prot manipulation written as

	vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));

and if this fix is really the right thing to do, this should probably be
wrapped up in a helper function; presumably every instance of

	vma->vm_page_prot = pgprot_FOO(vma->vm_page_prot)

under drivers/ would need the same fix for Xen.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
