From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: Re: [PATCH 7/8] net: seeq: replace kmalloc / memset(,0) with kzalloc
Date: Wed, 27 Feb 2019 16:48:00 -0800
Message-ID: <20190228004800.GA26378@bobby.localdomain>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
 <5ff7bcf7b8db8daa129703e5f7b632825f25c766.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5ff7bcf7b8db8daa129703e5f7b632825f25c766.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Eshleman <bobbyeshleman@gmail.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 26, 2019 at 10:09:54PM -0800, Robert Eshleman wrote:
> This patch reduces a call to memset(,0) by replacing
> a kmalloc call with a kzalloc call.
> 
> Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
> ---
>  drivers/net/ethernet/seeq/ether3.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
> index d1bb73bf9914..7456cf08a48f 100644
> --- a/drivers/net/ethernet/seeq/ether3.c
> +++ b/drivers/net/ethernet/seeq/ether3.c
> @@ -223,7 +223,7 @@ ether3_addr(char *addr, struct expansion_card *ec)
>  static int
>  ether3_ramtest(struct net_device *dev, unsigned char byte)
>  {
> -	unsigned char *buffer = kmalloc(RX_END, GFP_KERNEL);
> +	unsigned char *buffer = kzalloc(RX_END, GFP_KERNEL);
>  	int i,ret = 0;
>  	int max_errors = 4;
>  	int bad = -1;
> @@ -231,7 +231,6 @@ ether3_ramtest(struct net_device *dev, unsigned char byte)
>  	if (!buffer)
>  		return 1;
>  
> -	memset(buffer, byte, RX_END);

Byte is not zero, so the intent of this patch does not apply here.
Dropping this from the patch set in v2.


>  	ether3_setbuffer(dev, buffer_write, 0);
>  	ether3_writebuffer(dev, buffer, TX_END);
>  	ether3_setbuffer(dev, buffer_write, RX_START);
> -- 
> 2.20.1
> 
