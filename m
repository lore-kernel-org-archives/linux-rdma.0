From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Fri, 24 Mar 2017 22:11:09 -0400
Message-ID: <1490407869.2404.38.camel@redhat.com>
References: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
         <20170319092605.GS2079@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170319092605.GS2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-03-19 at 11:26 +0200, Leon Romanovsky wrote:
> On Tue, Mar 07, 2017 at 10:56:53PM +0000, Bart Van Assche wrote:
> > 
> > Avoid that the following error message is reported on the console
> > while loading an RDMA driver with I/O MMU support enabled:
> > 
> > DMAR: Allocating domain for mlx5_0 failed
> > 
> > Ensure that DMA mapping operations that use to_pci_dev() to
> > access to struct pci_dev see the correct PCI device. E.g. the s390
> > and powerpc DMA mapping operations use to_pci_dev() even with I/O
> > MMU support disabled.
> > 
> > This patch preserves the following changes of the DMA mapping
> > updates
> > patch series:
> > - Introduction of dma_virt_ops.
> > - Removal of ib_device.dma_ops.
> > - Removal of struct ib_dma_mapping_ops.
> > - Removal of an if-statement from each ib_dma_*() operation.
> > - IB HW drivers no longer set dma_device directly.
> > 
> > Reported-by: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")
> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  drivers/infiniband/core/device.c | 26 ++++++++++++++++++++------
> >  include/rdma/ib_verbs.h          | 30 +++++++++++++++++-----------
> > --
> >  2 files changed, 37 insertions(+), 19 deletions(-)
> > 
> 
> Hi Doug,
> 
> Can you please forward this patch to Linus? The IB/core is broken
> without this patch.
> 

It's been applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
