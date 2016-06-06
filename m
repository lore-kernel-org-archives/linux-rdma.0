From: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Subject: Re: [RFC v3 44/45] dma-mapping: Remove dma_get_attr
Date: Mon, 6 Jun 2016 08:45:12 +0200
Message-ID: <20160606064512.GB7998@samfundet.no>
References: <1464881987-13203-1-git-send-email-k.kozlowski@samsung.com>
 <1464881987-13203-45-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1464881987-13203-45-git-send-email-k.kozlowski@samsung.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Stefano Stabellini <sstabellini@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Haavard Skinnemoen <hskinnemoen@gmail.com>, Steven Miao <realmz6@gmail.com>, Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>, Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jesper.nilsson@axis.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Geert
List-Id: linux-rdma@vger.kernel.org

Around Thu 02 Jun 2016 17:39:46 +0200 or thereabout, Krzysztof Kozlowski wrote:
> After switching DMA attributes to unsigned long it is easier to just
> compare the bits.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  Documentation/DMA-API.txt                      |  4 +--
>  arch/arc/mm/dma.c                              |  4 +--
>  arch/arm/mm/dma-mapping.c                      | 36 ++++++++++++--------------
>  arch/arm/xen/mm.c                              |  4 +--
>  arch/arm64/mm/dma-mapping.c                    | 10 +++----
>  arch/avr32/mm/dma-coherent.c                   |  4 +--

For the AVR32 related change

Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>

>  arch/ia64/sn/pci/pci_dma.c                     | 10 ++-----
>  arch/metag/kernel/dma.c                        |  2 +-
>  arch/mips/mm/dma-default.c                     |  6 ++---
>  arch/openrisc/kernel/dma.c                     |  4 +--
>  arch/parisc/kernel/pci-dma.c                   |  2 +-
>  arch/powerpc/platforms/cell/iommu.c            | 10 +++----
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c    |  2 +-
>  drivers/iommu/dma-iommu.c                      |  2 +-
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
>  include/linux/dma-mapping.h                    | 13 ----------
>  16 files changed, 46 insertions(+), 69 deletions(-)

<snipp non-AVR32>

> diff --git a/arch/avr32/mm/dma-coherent.c b/arch/avr32/mm/dma-coherent.c
> index fc51f4421933..58610d0df7ed 100644
> --- a/arch/avr32/mm/dma-coherent.c
> +++ b/arch/avr32/mm/dma-coherent.c
> @@ -109,7 +109,7 @@ static void *avr32_dma_alloc(struct device *dev, size_t size,
>  		return NULL;
>  	phys = page_to_phys(page);
>  
> -	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
> +	if (attrs & DMA_ATTR_WRITE_COMBINE) {
>  		/* Now, map the page into P3 with write-combining turned on */
>  		*handle = phys;
>  		return __ioremap(phys, size, _PAGE_BUFFER);
> @@ -123,7 +123,7 @@ static void avr32_dma_free(struct device *dev, size_t size,
>  {
>  	struct page *page;
>  
> -	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
> +	if (attrs & DMA_ATTR_WRITE_COMBINE) {
>  		iounmap(cpu_addr);
>  
>  		page = phys_to_page(handle);

<snipp non-AVR32>

-- 
mvh
Hans-Christian Noren Egtvedt
