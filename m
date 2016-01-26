From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/mlx5: Add create and destroy functionality for Raw Packet
 QP
Date: Tue, 26 Jan 2016 10:48:51 +0200
Message-ID: <56A732F3.4080307@mellanox.com>
References: <20160126010846.GA13162@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160126010846.GA13162@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/1/2016 3:08 AM, Dan Carpenter wrote:
> Hello majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 0fb2ed66a14c: "IB/mlx5: Add create and destroy 
> functionality for Raw Packet QP" from Jan 14, 2016, leads to the 
> following Smatch complaint:
Thanks Dan!
I'm working on a fix and will send it soon.
> drivers/infiniband/hw/mlx5/qp.c:1629 mlx5_ib_create_qp()
> 	 error: we previously assumed 'pd' could be null (see line 1616)
>
> drivers/infiniband/hw/mlx5/qp.c
>   1615	
>   1616		if (pd) {
>                     ^^
> Check for NULL.
>
>   1617			dev = to_mdev(pd->device);
>   1618		} else {
>   1619			/* being cautious here */
>   1620			if (init_attr->qp_type != IB_QPT_XRC_TGT &&
>   1621			    init_attr->qp_type != MLX5_IB_QPT_REG_UMR) {
>   1622				pr_warn("%s: no PD for transport %s\n", __func__,
>   1623					ib_qp_type_str(init_attr->qp_type));
>   1624				return ERR_PTR(-EINVAL);
>   1625			}
>   1626			dev = to_mdev(to_mxrcd(init_attr->xrcd)->ibxrcd.device);
>   1627	
>   1628			if (init_attr->qp_type == IB_QPT_RAW_PACKET) {
>   1629				if (!pd->uobject) {
>                                      ^^^^^^^^^^^
> Patch adds new NULL dereferences.
>
>   1630					mlx5_ib_dbg(dev, "Raw Packet QP is not supported for kernel consumers\n");
>   1631					return ERR_PTR(-EINVAL);
>
> regards,
> dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
