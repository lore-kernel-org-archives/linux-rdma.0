From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Mon, 13 Jun 2016 10:19:57 -0400 (EDT)
Message-ID: <946373818.41993264.1465827597452.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com> <20160613140747.GL5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160613140747.GL5408-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Monday, June 13, 2016 10:07:47 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> On Sun, Jun 12, 2016 at 11:32:53PM -0700, Bart Van Assche wrote:
> > On 06/12/2016 03:40 PM, Laurence Oberman wrote:
> > >Jun  8 10:12:52 jumpclient kernel: mlx5_core 0000:08:00.1: swiotlb buffer
> > >is full (sz: 266240 bytes)
> > >Jun  8 10:12:52 jumpclient kernel: swiotlb: coherent allocation failed for
> > >device 0000:08:00.1 size=266240
> > 
> > Hello,
> > 
> > I think the above means that the coherent memory allocation succeeded but
> > that the test dev_addr + size - 1 <= DMA_BIT_MASK(32) failed. Can someone
> > from Mellanox tell us whether or not it would be safe to set
> > coherent_dma_mask to DMA_BIT_MASK(64) for the mlx4 and mlx5 drivers?
> 
> Bart and Laurence,
> We are actually doing it For mlx5 driver.
> 
> 926 static int mlx5_pci_init(struct mlx5_core_dev *dev, struct  mlx5_priv
> *priv)
> <...>
> 961         err = set_dma_caps(pdev);
> 
> 187 static int set_dma_caps(struct pci_dev *pdev)
> <...>
> 201         err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> 202         if (err) {
> 203                 dev_warn(&pdev->dev,
> 204                          "Warning: couldn't set 64-bit consistent PCI DMA
> mask\n");
> 205                 err = pci_set_consistent_dma_mask(pdev,
> DMA_BIT_MASK(32));
> 206                 if (err) {
> 207                         dev_err(&pdev->dev,
> 208                                 "Can't set consistent PCI DMA mask,
> aborting\n");
> 209                         return err;
> 210                 }
> 211         }
> 
> 118 static inline int pci_set_consistent_dma_mask(struct pci_dev *dev,u64
> mask)
> 119 {
> 120         return dma_set_coherent_mask(&dev->dev, mask);
> 121 }
> 
> > 
> > Thanks,
> > 
> > Bart.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hi Leon,

OK I see it now

static int set_dma_caps(struct pci_dev *pdev)
{
        int err;

        err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
        if (err) {

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
