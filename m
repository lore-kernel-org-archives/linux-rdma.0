From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma: fix out of bounds access to local buffer
Date: Mon, 01 May 2017 16:57:09 -0400
Message-ID: <1493672229.3041.189.camel@redhat.com>
References: <20170501064116.3900-1-dev@michaelmera.com>
         <20170501085736.GW14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170501085736.GW14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-05-01 at 11:57 +0300, Leon Romanovsky wrote:
> On Mon, May 01, 2017 at 03:41:16PM +0900, Michael Mera wrote:
> > 
> > In write to debugfs file 'resource_stats' the local buffer
> > 'tmp_str' is
> > written at index 'count-1' where 'count' is the size of the write,
> > so
> > potentially 0.
> > 
> > This patch filters odd values for the write size/position to avoid
> > this
> > type of problem.
> > 
> > Signed-off-by: Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
