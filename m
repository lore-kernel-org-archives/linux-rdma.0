From: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Subject: Re: [RFC v3 07/45] avr32: dma-mapping: Use unsigned long for
 dma_attrs
Date: Mon, 6 Jun 2016 08:43:57 +0200
Message-ID: <20160606064357.GA7998@samfundet.no>
References: <1464881987-13203-1-git-send-email-k.kozlowski@samsung.com>
 <1464881987-13203-8-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1464881987-13203-8-git-send-email-k.kozlowski@samsung.com>
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

Around Thu 02 Jun 2016 17:39:09 +0200 or thereabout, Krzysztof Kozlowski wrote:
> Split out subsystem specific changes for easier reviews. This will be
> squashed with main commit.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/mm/dma-coherent.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/avr32/mm/dma-coherent.c b/arch/avr32/mm/dma-coherent.c
> index 92cf1fb2b3e6..fc51f4421933 100644
> --- a/arch/avr32/mm/dma-coherent.c
> +++ b/arch/avr32/mm/dma-coherent.c
> @@ -99,7 +99,7 @@ static void __dma_free(struct device *dev, size_t size,
>  }
>  
>  static void *avr32_dma_alloc(struct device *dev, size_t size,
> -		dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
> +		dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
>  {
>  	struct page *page;
>  	dma_addr_t phys;
> @@ -119,7 +119,7 @@ static void *avr32_dma_alloc(struct device *dev, size_t size,
>  }
>  
>  static void avr32_dma_free(struct device *dev, size_t size,
> -		void *cpu_addr, dma_addr_t handle, struct dma_attrs *attrs)
> +		void *cpu_addr, dma_addr_t handle, unsigned long attrs)
>  {
>  	struct page *page;
>  
> @@ -142,7 +142,7 @@ static void avr32_dma_free(struct device *dev, size_t size,
>  
>  static dma_addr_t avr32_dma_map_page(struct device *dev, struct page *page,
>  		unsigned long offset, size_t size,
> -		enum dma_data_direction direction, struct dma_attrs *attrs)
> +		enum dma_data_direction direction, unsigned long attrs)
>  {
>  	void *cpu_addr = page_address(page) + offset;
>  
> @@ -152,7 +152,7 @@ static dma_addr_t avr32_dma_map_page(struct device *dev, struct page *page,
>  
>  static int avr32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
>  		int nents, enum dma_data_direction direction,
> -		struct dma_attrs *attrs)
> +		unsigned long attrs)
>  {
>  	int i;
>  	struct scatterlist *sg;
-- 
mvh
Hans-Christian Noren Egtvedt
