From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: IB/ocrdma: Remove unneeded conversions to bool
Date: Wed, 13 Dec 2017 11:20:52 -0700
Message-ID: <20171213182052.GG5984@ziepe.ca>
References: <20171205191553.21770-1-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171205191553.21770-1-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 05, 2017 at 01:15:53PM -0600, Andrew F. Davis wrote:
> Found with scripts/coccinelle/misc/boolconv.cocci.
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied to -next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
