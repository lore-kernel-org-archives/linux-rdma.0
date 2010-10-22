From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] [IB/QIB] Fix failure to load driver if PCI error
	reporting doesn't enable
Date: Fri, 22 Oct 2010 15:36:47 -0600
Message-ID: <20101022213647.GD30241@obsidianresearch.com>
References: <20101022204245.GC30241@obsidianresearch.com> <35AAF1E4A771E142979F27B51793A488873ABE076D@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <35AAF1E4A771E142979F27B51793A488873ABE076D-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 22, 2010 at 02:28:54PM -0700, Ralph Campbell wrote:

> I'm not sure this is the right change. I agree there are a lot of
> clean up on error bugs. pci_set_consistent_dma_mask() isn't optional
> because the chip doesn't support 32-bit PCIe addressing.

Do you think pci_enable_pcie_error_reporting is optional? My test
machine doesn't have a chipset with AER so that will always fail (or
something), the driver hasn't exploded yet ... :)

> I'll look it over and try to come up with something better.
>
> I'll submit a patch for the CONFIG_PCI_MSI not set case.

The resource leaks suck too, since you have to reboot to try again.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
