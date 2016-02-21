From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/8] IB/{core,ulp} Support above 32 possible
 device capability flags
Date: Sun, 21 Feb 2016 09:39:33 +0200
Message-ID: <56C969B5.5080802@mellanox.com>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
 <1455954465-15141-6-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455954465-15141-6-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/02/2016 09:47, Leon Romanovsky wrote:
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1762,7 +1762,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
>  
>  int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
>  {
> -	priv->hca_caps = hca->attrs.device_cap_flags;
> +	priv->hca_caps = (int)hca->attrs.device_cap_flags;

Won't it be better to increase the size of priv->hca_caps? Someone in the 
future will probably attempt to check one of the new device caps through
this field and will be surprised to see it is only partial.

>  
>  	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
>  		priv->dev->hw_features = NETIF_F_SG |
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 284b00c..2ff1fd1 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -273,7 +273,7 @@ struct ib_device_attr {
>  	u32			hw_ver;
>  	int			max_qp;
>  	int			max_qp_wr;
> -	int			device_cap_flags;
> +	u64			device_cap_flags;
>  	int			max_sge;
>  	int			max_sge_rd;
>  	int			max_cq;
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
