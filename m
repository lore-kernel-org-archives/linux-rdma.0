From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with pd->local_dma_lkey
Date: Tue, 28 Jul 2015 16:58:29 -0400
Message-ID: <mp8qgu$nt0$1@ger.gmane.org>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com> <mp85i7$6hc$1@ger.gmane.org> <20150728182356.GA1712@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

"Jason Gunthorpe" 
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote in 
message news:20150728182356.GA1712-ePGOBjL8dl3ta4EC/59zMK2raWmgRF17@public.gmane.org

> On Tue, Jul 28, 2015 at 11:01:12AM -0400, J.L. Burr wrote:
>
>> We use ib_get_dma_mr with IB_ACCESS_REMOTE_* flags in an embedded
>> device environment (in a custom out-of-tree device driver).  Not to
>> allow remote access to CPU memory but to allow remote access to PCIe
>> device memory (the IB card makes peer accesses directly to other
>> PCIe devices).
>
> Why can't you create a proper MR that only exposes the PCI device's
> BAR?

On the embedded side, the QPs and MRs are all in kernel space.  That's 
because the PCIe device BARs are huge (2**39 is the typical size, but it 
can be as large as 2**47).  This is much too large to map into the 
embedded processor's address space.

In an earlier implementation, I modified ib_reg_phys_mr so that it would 
return a no-translation MR and could also specify the physical address 
range I wanted it to define.  But I haven't used that in a long time. 
Plus you guys are removing ib_reg_phys_mr anyway! :-)

My current scheme, with ib_get_dma_mr, results in a MR which maps the 
entire 64-bit physical space (which isn't ideal; would indeed be better 
if the MR was limited to a single PCIe device BAR space) but does have 
the advantage (to me) of not requiring any modifications to Linux, the 
kernel IB stack, or IB hardware drivers.

I'm admittedly (way) out of date.  Our embedded system is running CentOS 
6.6 so the kernel level (2.6.32) is ancient by upstream standards.

Is there some way now (in upstream kernels) to create a MR with an 
arbitrary (and large) physical address range?  That would be great!  I 
didn't see a way to do that when I started on this journey (about 4 
years ago).

Thanks.

John





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
