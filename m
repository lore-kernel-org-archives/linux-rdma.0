From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Mon, 13 Jun 2016 11:22:19 -0400 (EDT)
Message-ID: <887623939.42004497.1465831339845.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com> <20160613140747.GL5408@leon.nu> <946373818.41993264.1465827597452.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <946373818.41993264.1465827597452.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Monday, June 13, 2016 10:19:57 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> 
> 
> ----- Original Message -----
> > From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman"
> > <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Monday, June 13, 2016 10:07:47 AM
> > Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
> > swiotlb_alloc_coherent()
> > 
> > On Sun, Jun 12, 2016 at 11:32:53PM -0700, Bart Van Assche wrote:
> > > On 06/12/2016 03:40 PM, Laurence Oberman wrote:
> > > >Jun  8 10:12:52 jumpclient kernel: mlx5_core 0000:08:00.1: swiotlb
> > > >buffer
> > > >is full (sz: 266240 bytes)
> > > >Jun  8 10:12:52 jumpclient kernel: swiotlb: coherent allocation failed
> > > >for
> > > >device 0000:08:00.1 size=266240
> > > 
> > > Hello,
> > > 
> > > I think the above means that the coherent memory allocation succeeded but
> > > that the test dev_addr + size - 1 <= DMA_BIT_MASK(32) failed. Can someone
> > > from Mellanox tell us whether or not it would be safe to set
> > > coherent_dma_mask to DMA_BIT_MASK(64) for the mlx4 and mlx5 drivers?
> > 
> > Bart and Laurence,
> > We are actually doing it For mlx5 driver.
> > 
> > 926 static int mlx5_pci_init(struct mlx5_core_dev *dev, struct  mlx5_priv
> > *priv)
> > <...>
> > 961         err = set_dma_caps(pdev);
> > 
> > 187 static int set_dma_caps(struct pci_dev *pdev)
> > <...>
> > 201         err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> > 202         if (err) {
> > 203                 dev_warn(&pdev->dev,
> > 204                          "Warning: couldn't set 64-bit consistent PCI
> > DMA
> > mask\n");
> > 205                 err = pci_set_consistent_dma_mask(pdev,
> > DMA_BIT_MASK(32));
> > 206                 if (err) {
> > 207                         dev_err(&pdev->dev,
> > 208                                 "Can't set consistent PCI DMA mask,
> > aborting\n");
> > 209                         return err;
> > 210                 }
> > 211         }
> > 
> > 118 static inline int pci_set_consistent_dma_mask(struct pci_dev *dev,u64
> > mask)
> > 119 {
> > 120         return dma_set_coherent_mask(&dev->dev, mask);
> > 121 }
> > 
> > > 
> > > Thanks,
> > > 
> > > Bart.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Hi Leon,
> 
> OK I see it now
> 
> static int set_dma_caps(struct pci_dev *pdev)
> {
>         int err;
> 
>         err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>         if (err) {
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Replying to my own email.
Leon, what is the implication of the mapping failure.
Its only in the reconnect stack when I am restarting controllers with the messaging and stack dump masked I still see the failure but it seems transparent in that all the paths come back.

[ 1595.167812] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1595.379133] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1595.460627] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1598.121096] scsi host1: reconnect attempt 3 failed (-48)
[ 1608.187869] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1615.911705] scsi host1: reconnect attempt 4 failed (-12)
[ 1641.446017] scsi host1: ib_srp: Got failed path rec status -110
[ 1641.482947] scsi host1: ib_srp: Path record query failed
[ 1641.513454] scsi host1: reconnect attempt 5 failed (-110)
[ 1662.330883] scsi host1: ib_srp: Got failed path rec status -110
[ 1662.361224] scsi host1: ib_srp: Path record query failed
[ 1662.390768] scsi host1: reconnect attempt 6 failed (-110)
[ 1683.892311] scsi host1: ib_srp: Got failed path rec status -110
[ 1683.922653] scsi host1: ib_srp: Path record query failed
[ 1683.952717] scsi host1: reconnect attempt 7 failed (-110)
SM port is up

Entering MASTER state

[ 1705.254048] scsi host1:   REJ reason 0x8
[ 1705.274869] scsi host1: reconnect attempt 8 failed (-104)
[ 1723.264914] scsi host1:   REJ reason 0x8
[ 1723.285193] scsi host1: reconnect attempt 9 failed (-104)
[ 1743.658091] scsi host1:   REJ reason 0x8
[ 1743.678562] scsi host1: reconnect attempt 10 failed (-104)
[ 1761.911512] scsi host1:   REJ reason 0x8
[ 1761.932006] scsi host1: reconnect attempt 11 failed (-104)
[ 1782.209020] scsi host1: ib_srp: reconnect succeeded

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
