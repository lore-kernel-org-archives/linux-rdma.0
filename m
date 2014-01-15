From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 07/14] IB/mlx5: Make sure doorbell record is
 visible before doorbell
Date: Wed, 15 Jan 2014 08:47:47 +0200
Message-ID: <20140115064747.GA31664@mtldesk30>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
 <1389714323-20130-8-git-send-email-eli@mellanox.com>
 <1389717393.1585.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389717393.1585.66.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> In linux-next, as of next-20140114, I'm seeing the write memory barrier
> before "qp->db.db[MLX5_SND_DBR] = cpu_to_be32(qp->sq.cur_post);"
> It was introduced by commit e126ba97dba9e:
> 
> out:
>         if (likely(nreq)) {
>                 qp->sq.head += nreq;
> 
>                 /* Make sure that descriptors are written before
>                  * updating doorbell record and ringing the doorbell
>                  */
>                 wmb();
> 
>                 qp->db.db[MLX5_SND_DBR] = cpu_to_be32(qp->sq.cur_post);
> 
>                 if (bf->need_lock)
>                         spin_lock(&bf->lock);
> 
> So this add a second wmb().
> Is it really necessary ?
> 

Yes both are required. The first one makes sure that the descriptors
are visible before update of the doorbell record, and the newly added
one is required to ensure the doorbell record is visible before the
hardware is notified.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
