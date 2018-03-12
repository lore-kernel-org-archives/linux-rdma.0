From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] net/mlx4_en: Fix a memory leak in case of error in
 'mlx4_en_init_netdev()'
Date: Mon, 12 Mar 2018 20:32:07 +0100
Message-ID: <9cd5ab7d-15c1-7ebf-1bf1-3fcd79525fa8@wanadoo.fr>
References: <20180311224529.4427-1-christophe.jaillet@wanadoo.fr>
 <a61ed690-7df1-7292-4074-3f7d66c0b490@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a61ed690-7df1-7292-4074-3f7d66c0b490@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Le 12/03/2018 à 09:42, Tariq Toukan a écrit :
 >
 >
 > On 12/03/2018 12:45 AM, Christophe JAILLET wrote:
 >> If 'kzalloc' fails, we must free some memory before returning.
 >>
 >> Fixes: 67f8b1dcb9ee ("net/mlx4_en: Refactor the XDP forwarding rings
 >> scheme")
 >> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
 >> ---
 >>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 2 +-
 >>   1 file changed, 1 insertion(+), 1 deletion(-)
 >>
 >> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
 >> b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
 >> index 8fc51bc29003..f9db018e858f 100644
 >> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
 >> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
 >> @@ -3327,7 +3327,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev
 >> *mdev, int port,
 >>           if (!priv->tx_cq[t]) {
 >>               kfree(priv->tx_ring[t]);
 >>               err = -ENOMEM;
 >> -            goto out;
 >> +            goto err_free_tx;
 >>           }
 >>       }
 >>       priv->rx_ring_num = prof->rx_ring_num;
 >>
 >
 > Hi Christophe, thanks for spotting this.
 >
 > However, I think these err_free_tx label and loop are redundant.
 > Both tx_ring/tx_cq flows should just goto out, as resources are freed
 > later in mlx4_en_destroy_netdev() -> mlx4_en_free_resources().
 >

Hi,

I do not agree with you and I think that the patch is relevant.

If 'mlx4_en_init_netdev' fails, the only caller, 'mlx4_en_activate()', 
will set:
	mdev->pndev[i] = NULL
(see 
https://elixir.bootlin.com/linux/v4.16-rc5/source/drivers/net/ethernet/mellanox/mlx4/en_main.c#L254)

and 'mlx4_en_destroy_netdev()' is not called in this case.
(see 
https://elixir.bootlin.com/linux/v4.16-rc5/source/drivers/net/ethernet/mellanox/mlx4/en_main.c#L232)

My understanding is that 'mlx4_en_destroy_netdev()' will free resources 
in the normal case but that resources should be freed at allocation time 
if it does not fully succeed.

Best regards,
CJ

---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
