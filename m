From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/2] IB/core: Align casting method of
 ib_device_cap_flags enumerations to ULL
Date: Mon, 6 Jun 2016 10:04:13 -0700
Message-ID: <20160606170413.GB28622@infradead.org>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
 <1465230880-25953-3-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465230880-25953-3-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: robert@leblancnet.us, matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 07:34:40PM +0300, Max Gurtovoy wrote:
> Replace u64 casting to ULL.
> 
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> ---
>  include/rdma/ib_verbs.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index c97357b..7e440d4 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -219,8 +219,8 @@ enum ib_device_cap_flags {
>  	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
>  	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
>  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
> -	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
> -	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
> +	IB_DEVICE_VIRTUAL_FUNCTION		= (1ULL << 33),
> +	IB_DEVICE_RAW_SCATTER_FCS		= (1ULL << 34),

Looks good, but can you also convert the whole enum to this
style?
