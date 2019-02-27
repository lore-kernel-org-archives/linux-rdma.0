From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/8] tlan: use pci_zalloc instead of pci_alloc
Date: Tue, 26 Feb 2019 22:22:06 -0800
Message-ID: <ce11feb21863662cf2ad96f0f7b69f0edcabfcf7.camel@perches.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
         <51125a3daac49f7b5bb360a422663aee26e6776b.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51125a3daac49f7b5bb360a422663aee26e6776b.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Eshleman <bobbyeshleman@gmail.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Samuel Chessman <chessman@tux.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2019-02-26 at 22:09 -0800, Robert Eshleman wrote:
> This patch replaces a pci_alloc_consistent and memset(,0) call
> with a single call to pci_zalloc_consistent.
[]
> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
[]
> @@ -845,17 +845,16 @@ static int tlan_init(struct net_device *dev)
>  
>  	dma_size = (TLAN_NUM_RX_LISTS + TLAN_NUM_TX_LISTS)
>  		* (sizeof(struct tlan_list));
> -	priv->dma_storage = pci_alloc_consistent(priv->pci_dev,
> -						 dma_size,
> -						 &priv->dma_storage_dma);
> +	priv->dma_storage = pci_zalloc_consistent(priv->pci_dev,
> +						  dma_size,
> +						  &priv->dma_storage_dma);
>  	priv->dma_size = dma_size;
>  
> -	if (priv->dma_storage == NULL) {
> +	if (!priv->dma_storage) {
>  		pr_err("Could not allocate lists and buffers for %s\n",
>  		       dev->name);

unrelated trivia:

This pr_err (and likely others in this file)
could be replace by netdev_err
