From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx5: Add driver for Mellanox Connect-IB adapters
Date: Wed, 10 Jul 2013 14:28:45 +0300
Message-ID: <51DD456D.70205@mellanox.com>
References: <20130710105415.GA31232@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130710105415.GA31232-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/07/2013 13:54, Dan Carpenter wrote:
> ---
> Side note: Sparse should warn about endian bugs but in linux-next
> endian checking is disabled because we hit:
>
> include/uapi/linux/swab.h:71:16: error: undefined identifier '__builtin_bswap64'
> include/uapi/linux/swab.h:71:33: error: not a function <noident>
>
> do_error() in Sparse disables warning messages.  I feel like we
> shouldn't do that.
>
>          /* Shut up warnings after an error */
>          max_warnings = 0;
> ---
>
> Hello Eli Cohen,
>
> The patch e126ba97dba9: "mlx5: Add driver for Mellanox Connect-IB
> adapters" from Jul 7, 2013, has an endian related bug:
>
> drivers/net/ethernet/mellanox/mlx5/core/main.c
>     214          memset(&set_out, 0, sizeof(set_out));
>     215          set_ctx->hca_cap.uar_page_sz = cpu_to_be16(PAGE_SHIFT - 12);
>                           ^^^^^^^^^^^^^^^^^^^
> This is defined in the header as be32 but we are saving a be16 to it.
> My guess is the header is correct and the be16 is wrong.
>
>     216          set_ctx->hdr.opcode = cpu_to_be16(MLX5_CMD_OP_SET_HCA_CAP);
>     217          err = mlx5_cmd_exec(dev, set_ctx, sizeof(*set_ctx),
>     218                                   &set_out, sizeof(set_out));
>
> regards,
> dan carpenter
>

Dan, this sparse catch was reported earlier by Fengguang Wu 
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, we have a fix, will send now

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
