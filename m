From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 32/37] add rxe_net.h
Date: Sun, 7 Aug 2011 10:51:11 +0200
Message-ID: <CAO+b5-pj+YgOHfJuXMFXnM71mk0ngeXgi3N_bkVy_k4AxwuK=g@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.715886208@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.715886208-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +/*
> + * this should be defined in .../include/linux/if_ether.h
> + */
> +#define ETH_P_RXE			(0x8915)
> +
> +/*
> + * this should be defined in .../include/linux/netfilter.h
> + * to a specific value
> + */
> +#define NFPROTO_RXE			(0)
> +
> +/*
> + * these should be defined in .../include/linux/netfilter_rxe.h
> + */
> +#define NF_RXE_IN			(0)
> +#define NF_RXE_OUT			(1)

Please update the cited header files instead of adding these symbols here.

> +/* Should probably move to something other than an array...these can be big */
> +#define RXE_MAX_IF_INDEX	(384)

Has it been considered to change net_info[] from an array into a
linked list ? As far as I can see none of the net_info[] accesses are
in the fast path and the number of entries used in the (sparse)
net_info[] array is small. Such a change would allow to eliminate the
RXE_MAX_IF_INDEX artificial limit.

> +struct rxe_net_info {
> +	struct rxe_dev		*rxe;
> +	u8			port;
> +	struct net_device	*ndev;
> +	int			status;
> +};

Is there a reason why status and port are in struct rxe_net_info
instead of struct rxe_dev ? Moving these two fields would allow
several code simplifications IMHO.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
