From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] IB/core: replace memcpy with ether_addr_copy
Date: Thu, 24 Aug 2017 09:06:32 -0700
Message-ID: <1503590792.12569.2.camel@perches.com>
References: <1503589307-10457-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503589307-10457-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, dledford@redhat.com
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-24 at 21:11 +0530, Himanshu Jha wrote:
> Use ether_addr_copy to copy an ethernet address of size ETH_ALEN
> instead of memcpy.
[]
diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
[]
> @@ -798,7 +798,7 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
>  	if (ret)
>  		return ret;
>  
> -	memcpy(dmac, dev_addr.dst_dev_addr, ETH_ALEN);
> +	ether_addr_copy(dmac, dev_addr.dst_dev_addr);
>  	dev = dev_get_by_index(&init_net, dev_addr.bound_dev_if);
>  	if (!dev)
>  		return -ENODEV;
> @@ -831,7 +831,7 @@ int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
>  	if (ret)
>  		return ret;
>  
> -	memcpy(smac, dev_addr.src_dev_addr, ETH_ALEN);
> +	ether_addr_copy(smac, dev_addr.src_dev_addr);
>  	return ret;
>  }
>  EXPORT_SYMBOL(rdma_addr_find_smac_by_sgid);

Both dmac and smac are function arguments.
What guarantees these to be
aligned properly?
