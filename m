From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [infiniband:for-next 769/772]
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c:894:7-14: WARNING opportunity
 for memdup_user
Date: Mon, 8 Jul 2013 18:58:27 +0800
Message-ID: <20130708105827.GA5963@localhost>
References: <20130708094047.GC2985@localhost>
 <51DA8D32.2090504@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51DA8D32.2090504-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 08, 2013 at 12:58:10PM +0300, Or Gerlitz wrote:
> On 08/07/2013 12:40, Fengguang Wu wrote:
> >Hi Eli,
> >
> >FYI, there are coccinelle warnings in
> >
> >tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
> >head:   1af1abad19f6a40d8822cb7a35736e9e102fade6
> >commit: 809d3a921f9047bf575488f410ed12b365fe5cd7 [769/772] mlx5: Add driver for Mellanox Connect-IB adapters
> >
> >>>drivers/net/ethernet/mellanox/mlx5/core/cmd.c:894:7-14: WARNING opportunity for memdup_user
> >--
> >>>drivers/infiniband/hw/mlx5/mr.c:445:2-3: Unneeded semicolon
> >>>drivers/infiniband/hw/mlx5/mr.c:167:2-3: Unneeded semicolon
> >--
> >>>drivers/net/ethernet/mellanox/mlx5/core/cmd.c:98:11-19: WARNING opportunity for simple_open, see also structure on line 938
> >>>drivers/net/ethernet/mellanox/mlx5/core/cmd.c:98:11-19: WARNING opportunity for simple_open, see also structure on line 718
> >>>drivers/net/ethernet/mellanox/mlx5/core/cmd.c:98:11-19: WARNING opportunity for simple_open, see also structure on line 1006
> >--
> >>>drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:145:11-19: WARNING opportunity for simple_open, see also structure on line 470
> >>>drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:145:11-19: WARNING opportunity for simple_open, see also structure on line 203
> >--
> >>>drivers/infiniband/hw/mlx5/mr.c:52:11-20: WARNING opportunity for simple_open, see also structure on line 289
> >>>drivers/infiniband/hw/mlx5/mr.c:52:11-20: WARNING opportunity for simple_open, see also structure on line 227
> >Please consider folding the attached diff with suitable fixups :-)
> 
> Hi Roland,
> 
> Eli is still OOO, I have reviewed the four patches and they are OK,
> please roll into the initial version

Roland, you may need to replace some " " with "\t" in the patches.

Thanks,
Fengguang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
