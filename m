From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 03/37] treewide: Consolidate set_dma_ops()
 implementations
Date: Mon, 30 Jan 2017 13:58:32 +0000
Message-ID: <20170130135832.GT27312@n2100.armlinux.org.uk>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-4-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170120210437.26389-4-bart.vanassche@sandisk.com>
Sender: linux-arch-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Chris Metcalf <cmetcalf@mellanox.com>, David Woodhouse <dwmw2@infradead.org>, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2017 at 01:04:03PM -0800, Bart Van Assche wrote:
> Now that all set_dma_ops() implementations are identical (ignoring
> BUG_ON() statements), remove the architecture specific definitions
> and add a definition in <linux/dma-mapping.h>.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Chris Metcalf <cmetcalf@mellanox.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-arch@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Russell King <linux@armlinux.org.uk>

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  arch/arm/include/asm/dma-mapping.h     | 6 ------
>  arch/powerpc/include/asm/dma-mapping.h | 5 -----
>  arch/tile/include/asm/dma-mapping.h    | 5 -----
>  include/linux/dma-mapping.h            | 5 +++++
>  4 files changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 312f4d0564d6..c7432d647e53 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -31,12 +31,6 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
>  		return __generic_dma_ops(dev);
>  }
>  
> -static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
> -{
> -	BUG_ON(!dev);
> -	dev->dma_ops = ops;
> -}
> -
>  #define HAVE_ARCH_DMA_SUPPORTED 1
>  extern int dma_supported(struct device *dev, u64 mask);
>  
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
> index 59fbd4abcbf8..8275603ba4d5 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -91,11 +91,6 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
>  	return dev->dma_ops;
>  }
>  
> -static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
> -{
> -	dev->dma_ops = ops;
> -}
> -
>  /*
>   * get_dma_offset()
>   *
> diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
> index c0620697eaad..2562995a6ac9 100644
> --- a/arch/tile/include/asm/dma-mapping.h
> +++ b/arch/tile/include/asm/dma-mapping.h
> @@ -59,11 +59,6 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
>  
>  static inline void dma_mark_clean(void *addr, size_t size) {}
>  
> -static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
> -{
> -	dev->dma_ops = ops;
> -}
> -
>  static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
>  {
>  	if (!dev->dma_mask)
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index f1da68b82c63..e97f23e8b2d9 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -164,6 +164,11 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
>  
>  #ifdef CONFIG_HAS_DMA
>  #include <asm/dma-mapping.h>
> +static inline void set_dma_ops(struct device *dev,
> +			       const struct dma_map_ops *dma_ops)
> +{
> +	dev->dma_ops = dma_ops;
> +}
>  #else
>  /*
>   * Define the dma api to allow compilation but not linking of
> -- 
> 2.11.0
> 

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
