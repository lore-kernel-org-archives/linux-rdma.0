From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 09/31] IB/core: Make sure that PSN does not
 overflow
Date: Wed, 27 Dec 2017 15:44:11 -0700
Message-ID: <20171227224411.GA2156@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-10-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-10-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:56PM +0200, Leon Romanovsky wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The rq/sq->psn is 24 bits as defined in the IB spec,therefore we mask
> out the 8 most significant bits to avoid overflow in modify qp.
> 
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  drivers/infiniband/core/verbs.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Applied to -next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
