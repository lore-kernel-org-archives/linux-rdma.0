From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/5] mlx5: Avoid that sparse complains about dubious !x &
 y expressions
Date: Thu, 8 Dec 2016 10:53:22 -0700
Message-ID: <20161208175322.GB11025@obsidianresearch.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <572c702f-589f-2d5a-9e13-45223191db85@sandisk.com>
 <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 08, 2016 at 11:26:32AM +0200, Or Gerlitz wrote:
>  /* insert a value to a struct */
>  #define MLX5_SET(typ, p, fld, v) do { \
> +       typeof( v ) _v = v; \
>         BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
>         *((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
>         cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, fld))) & \
> -                    (~__mlx5_dw_mask(typ, fld))) | (((v) &
> __mlx5_mask(typ, fld)) \
> +                    (~__mlx5_dw_mask(typ, fld))) | (((_v) &
> __mlx5_mask(typ, fld)) \
>                      << __mlx5_dw_bit_off(typ, fld))); \
>  } while (0)

Ugh, that is ugly.

This is better, it has proper type safety :|

static inline _mlx5_set(__be32 *p, u32 dw_mask,
                        u32 mask, u32 dw_off,
			unsigned int bit_off, u32 val)
{
	*(p + dw_off) = cpu_to_b32((be32_to_cpu_p(p + dw_off) &
	             ~dw_mask) | ((val & mask) << bit_off));
}

#define MLX5_SET(typ, p, fld, v) \
	_mlx5_set(p, __mlx5_dw_mask(typ, fld),
	           __mlx5_mask(typ, fld),
	           __mlx5_dw_off(typ, fld),
		   __mlx5_dw_bit_off(typ, fld), v)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
