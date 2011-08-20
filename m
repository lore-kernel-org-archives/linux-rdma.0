From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 29/37] add rxe_dma.c
Date: Sat, 20 Aug 2011 17:32:57 +0200
Message-ID: <CAO+b5-pUyAJnayG4T4w3Txnp7u_b51bogfkmOQGGTgSSCi_mhg@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.565188525@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.565188525-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +static u64 rxe_dma_map_single(struct ib_device *dev,
> +			      void *cpu_addr, size_t size,
> +			      enum dma_data_direction direction)
> +{
> +	BUG_ON(!valid_dma_direction(direction));
> +	return (u64) (uintptr_t) cpu_addr;
> +}

In the above function execution can continue without crashing even if
the DMA direction argument is invalid. So please use WARN_ON() instead
of BUG_ON() in the functions in source file rxe_dma.c.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
