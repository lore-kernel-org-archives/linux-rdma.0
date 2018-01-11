From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v3 6/7] RDMA/nldev: Provide global resource utilization
Date: Thu, 11 Jan 2018 13:41:51 -0600
Message-ID: <017901d38b14$3a6746d0$af35d470$@opengridcomputing.com>
References: <20180111153132.11143-1-leon@kernel.org> <20180111153132.11143-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111153132.11143-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Export through netlink interface, the global device utilization
> for the rdmatool as the main user of RDMA nldev interface.
> 
> Provide both dumpit and doit callbacks.
> 
> As an example of possible output from rdmatool for system with 5
> Mellanox's card
> 
> $ rdma res
> 1: mlx5_0: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
> 2: mlx5_1: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
> 3: mlx5_2: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
> 4: mlx5_3: curr/max: qp 2/262144 cq 3/16777216 pd 2/16777216
> 5: mlx5_4: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
> 
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
