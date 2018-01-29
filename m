From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Merge status of IB/IPoIB: Add multi-queue TSS and RSS support
Date: Mon, 29 Jan 2018 11:10:28 -0700
Message-ID: <20180129181028.GD23714@ziepe.ca>
References: <1517225860.4291.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517225860.4291.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 29, 2018 at 12:37:40PM +0100, Benjamin Drung wrote:
> Hello,
> 
> can someone tell me why MQ TSS/RSS is present in MLNX OFED, but not in
> mainlined yet? I've found some nearly four years old patch sets
> regarding that topic, but no real reason for not merging them:
> https://www.spinics.net/lists/linux-rdma/msg14940.html
> 
> I'd like to push this forward in order to align features of mainline
> with MLNX OFED.

Kernel features like this have been superseded by rdma_netdev for
ipoib - eg mlx5 implements all offloads through this API.

RSS was merged to userspace with a different API, see
 ibv_create_rwq_ind_table.3
 ibv_create_wq.3
 ibv_modify_wq.3

And TSS was merged to userspace with a different API, see
IBV_QP_CREATE_SOURCE_QPN.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
