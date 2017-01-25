From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Wed, 25 Jan 2017 14:42:30 +0200
Message-ID: <20170125124229.GA14757@srabinov-linux.uk.oracle.com>
References: <1483954699-17826-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170111085358.GX7218@mtr-leonro.local>
 <1485293674.43764.86.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485293674.43764.86.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 24, 2017 at 04:34:34PM -0500, Doug Ledford wrote:
> On Wed, 2017-01-11 at 10:53 +0200, Leon Romanovsky wrote:
> > On Mon, Jan 09, 2017 at 04:38:19AM -0500, Shamir Rabinovitch wrote:
> > > 
> > > [1383664.318513] mlx4_core 0006:01:00.1: HCA minimum page size:1
> > > [1383664.318515] mlx4_core 0006:01:00.1: UAR size:4096 != kernel
> > > PAGE_SIZE of
> > > 8192
> > > [1383664.318517] mlx4_core 0006:01:00.1: Failed to obtain slave
> > > caps
> > > 
> > > Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > 
> > > ---
> > 
> > Doug,
> > To be clear, NAK.
> > It is custom kernel with out-of-tree patches and very specific FW.
> 
> As you wish.

Just as FYI, the only reason I can't run upstream vanilla kernel on
SPARC T7-2 (where issue is seen) is that there is series of patches that
fix PCI related issues for this HW that is not fully upstream yet.

Once it is upstream, we will be able to see the issue on upstream
vanilla kernel.

Other drivers do work well with 64-bit coherent DMA addresses and the
PCI fixes so I still suspect this issue is limited to only CX3 HW and
not some wide IOMMU / PCI issue.

Can Mellanox confirm that the CX3 HW & firmware can handle DMA addresses
such as below ?

is_read in_param c00000020253a000 out_param c000000403d4e000
is_read in_param c000000202b42000 out_param c000000403d4e000
is_read in_param c000000202b42000 out_param c00000020253a000 

ixgbe easily work with such DMA addresses:

ixgbe: ixgbe dma_alloc_coherent: retruned virtual addr:
0xfff8001f81f48000 , dma_addr 0xc000000480112000
ixgbe: ixgbe dma_alloc_coherent: retruned virtual addr:
0xfff8001f8bdbe000 , dma_addr 0xc000000480114000
ixgbe: ixgbe dma_alloc_coherent: retruned virtual addr:
0xfff8001f8beac000 , dma_addr 0xc000000480116000 

BR, Shamir

> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>    
> Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
