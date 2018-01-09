From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 0/6] Add DC transport support to mlx5
Date: Mon, 8 Jan 2018 19:49:52 -0700
Message-ID: <20180109024952.GA6305@ziepe.ca>
References: <20180102141933.24353-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102141933.24353-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 02, 2018 at 04:19:27PM +0200, Leon Romanovsky wrote:
> Changelog:
>  v1 -> v2:
>   * Renamed functions to better describe functionality.
>   * Improve set_mlx5_qp function implementation.
>  v0 -> v1:
>   * Updated "net/mlx5: Add DCT command interface" patch to
>     declare variables in reversed Christmas tree order.
> 
> >From Moni,
> 
> Following the discussion [1] on the mailing list regarding
> "Custom/proprietary QP type support", the following patchset
> implements the direct connected QP types functionality over posted RFC.
> 
> The dynamically connected (DC) transport service provides a datagram-like
> model that allows a DC QP to target multiple remote processes in multiple
> remote nodes.
> 
> As far as reachability is concerned, the DC model is somewhat similar to
> the unreliable datagram (UD) model in the sense that each WR submitted to
> the DC SQ carries the information that identifies the remote destination.
> 
> The new QP type - IB_QPT_DRIVER is introduced to represent all type of QPs
> that are driver specific, like the proposed DC QP. Such minimal change
> to the IB/core allows reuse of existing verbs functions to control those
> new QPs with already existing functions.
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg57598.html
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>   tags/rdma-next-2018-01-02-1

Applied to for-next

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
