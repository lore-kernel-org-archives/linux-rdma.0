From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [infiniband:for-next 37/52] drivers/net/ethernet/mellanox/mlx4/mlx4.h:695:1:
 error: expected identifier or '(' before '<<' token
Date: Mon, 1 Oct 2012 02:12:35 -0700
Message-ID: <CAL1RGDXz1R467TcWMExMGF1By=daczTdQNBA6L9upDDhhe1pRA@mail.gmail.com>
References: <20121001041510.GA17304@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001041510.GA17304@localhost>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 30, 2012 at 9:15 PM, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> FYI, kernel build failed on
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
> head:   c99517cda3548a0e270d374fe97d589d38022b80
> commit: 431ee27496b84effaaff9d21f0aae7c68015deeb [37/52] mlx4_core: Stash PCI ID driver_data in mlx4_priv structure
> config: x86_64-allmodconfig
>
> All error/warnings:
>
> In file included from drivers/net/ethernet/mellanox/mlx4/alloc.c:42:0:
> drivers/net/ethernet/mellanox/mlx4/mlx4.h:695:1: error: expected identifier or '(' before '<<' token

Thanks, managed to leave a conflict marker in when I merged up to
3.6-rc7.  Should be fixed now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
