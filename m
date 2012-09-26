From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Wed, 26 Sep 2012 23:51:40 +0200
Message-ID: <CAJZOPZKoMorYPBqUPbmUcsw1GcXOYo8oE-u2gA6HB6sb3eo1iw@mail.gmail.com>
References: <1348634552-21047-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348634552-21047-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 26, 2012 at 6:42 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
> On an SR-IOV master device, __mlx4_init_one() calls mlx4_init_hca()
> before mlx4_multi_func_init().  However, for unlucky configurations,
> mlx4_init_hca() might call mlx4_SENSE_PORT() (via mlx4_dev_cap()), and
> that calls mlx4_cmd_imm() with MLX4_CMD_WRAPPED set.
>
> However, on a multifunction device with MLX4_CMD_WRAPPED, __mlx4_cmd()
> calls into mlx4_slave_cmd(), and that immediately tries to do
>
>         down(&priv->cmd.slave_sem);
>
> but priv->cmd.slave_sem isn't initialized until mlx4_multi_func_init()
> (which we haven't called yet).  The next thing it tries to do is access
> priv->mfunc.vhcr, but that hasn't been allocated yet.
>
> Fix this by moving the initialization of slave_sem and vhcr up into
> mlx4_cmd_init(). Also, since slave_sem is really just being used as a
> mutex, convert it into a slave_cmd_mutex.
>
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
> Jack, I needed this to get my (CX3 w/ FW 2.11.500) adapter to work in
> SR-IOV mode.  Is it possible you never tested SR-IOV on an adapter
> with ports in autosensing mode?

Roland,

What exactly did you mean by saying "for unlucky configurations"
above? what value did you use for mlx4_core's port_array_type module
param?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
