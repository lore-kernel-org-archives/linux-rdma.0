From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx5: Add driver for Mellanox Connect-IB adapters
Date: Mon, 15 Jul 2013 17:29:15 +0300
Message-ID: <51E4073B.9080500@mellanox.com>
References: <20130710105538.GB31232@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130710105538.GB31232-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/07/2013 13:55, Dan Carpenter wrote:
> Hello Eli Cohen,
>
> The patch e126ba97dba9: "mlx5: Add driver for Mellanox Connect-IB
> adapters" from Jul 7, 2013, leads to the following Smatch warning:
> "drivers/net/ethernet/mellanox/mlx5/core/cmd.c:822
> mlx5_alloc_cmd_msg()
> 	 warn: use 'flags' here instead of GFP_XXX?"
>
>     811  static struct mlx5_cmd_msg *mlx5_alloc_cmd_msg(struct mlx5_core_dev *dev,
>     812                                                 gfp_t flags, int size)
>                                                         ^^^^^^^^^^^
>
>     813  {
>     814          struct mlx5_cmd_mailbox *tmp, *head = NULL;
>     815          struct mlx5_cmd_prot_block *block;
>     816          struct mlx5_cmd_msg *msg;
>     817          int blen;
>     818          int err;
>     819          int n;
>     820          int i;
>     821
>     822          msg = kzalloc(sizeof(*msg), GFP_KERNEL);
>                                              ^^^^^^^^^^
>     823          if (!msg)
>     824                  return ERR_PTR(-ENOMEM);
>     825
>     826          blen = size - min_t(int, sizeof(msg->first.data), size);
>     827          n = (blen + MLX5_CMD_DATA_BLOCK_SIZE - 1) / MLX5_CMD_DATA_BLOCK_SIZE;
>     828
>     829          for (i = 0; i < n; i++) {
>     830                  tmp = alloc_cmd_box(dev, flags);
>                                                   ^^^^^
> There is a kmalloc() in alloc_cmd_box() that uses flags as well as a
> pci_pool_alloc() that uses it.
>
>     831                  if (IS_ERR(tmp)) {
>     832                          mlx5_core_warn(dev, "failed allocating block\n");
>
>

Hi,

I think Eli has some problems with his email account for mailing lists, 
so sorry for the delay. Once this is fixed, he should
be addressing your email.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
