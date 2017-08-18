From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Fixes for static checker warnings
Date: Fri, 18 Aug 2017 12:04:03 -0400
Message-ID: <1503072243.2598.18.camel@redhat.com>
References: <20170719185526.5404-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170719185526.5404-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-07-19 at 13:55 -0500, Shiraz Saleem wrote:
> Remove NULL check for cm_node->listener in i40iw_accept
> as listener is always present at this point.
> 
> Remove the check for cm_node->accept_pend and related code
> in i40iw_cm_event_connected as the cm_node in this context
> is only pertinent to active node and cm_node->accept_pend
> is always 0.
> 
> This fixes the following smatch warnings,
> 
> drivers/infiniband/hw/i40iw/i40iw_cm.c:3691 i40iw_accept()
> error: we previously assumed 'cm_node->listener' could be null
> 
> drivers/infiniband/hw/i40iw/i40iw_cm.c:4061
> i40iw_cm_event_connected()
> error: we previously assumed 'cm_node->listener' could be null
> 
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
