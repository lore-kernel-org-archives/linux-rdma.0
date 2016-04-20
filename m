From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/mlx5: Add UARs write-combining and non-cached mapping
Date: Wed, 20 Apr 2016 17:51:38 +0300
Message-ID: <CAJ3xEMhSr2sDTyH6kHVprBUj1WNKKk6fEQKer6ngLX7AZ0DPjQ@mail.gmail.com>
References: <1460903581-6788-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903581-6788-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 17, 2016 at 5:33 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> +static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
> +                   struct vm_area_struct *vma, struct mlx5_uuar_info *uuari)
> +{
> +       int err;
> +       unsigned long idx;
> +       phys_addr_t pfn, pa;
> +       pgprot_t prot;
> +
> +       switch (cmd) {
> +       case MLX5_IB_MMAP_WC_PAGE:
> +/* Some architerctures don't support WC memory */

architerctures --> architectures

please fix
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
