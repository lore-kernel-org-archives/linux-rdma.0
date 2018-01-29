From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Change RDMA_RXE kconfig to use select
Date: Mon, 29 Jan 2018 12:59:49 -0700
Message-ID: <20180129195949.GA7599@ziepe.ca>
References: <20180126211833.GA26670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180126211833.GA26670-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 26, 2018 at 02:18:33PM -0700, Jason Gunthorpe wrote:
> NET_UDP_TUNNEL is not user selectable, so it should be used as a select
> in kconfig.
> 
> CRYPTO_CRC32 is a required library for RDMA_RXE so it should active
> automatically, as most other CRYPTO_ users do.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/sw/rxe/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
