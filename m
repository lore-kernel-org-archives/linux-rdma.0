From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 04:33:53 -0700
Message-ID: <20160602113353.GA18494@infradead.org>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org, robert@leblancnet.us
List-Id: linux-rdma@vger.kernel.org

>  	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
>  	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
>  	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
> -	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
> +	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
>  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
>  	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
>  	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),

So now we've got three different styles to define the constants.

I'd really prefer to move all of them over to the 1ULL << offset style.
