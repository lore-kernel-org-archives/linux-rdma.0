From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v3 1/7] RDMA/restrack: Add general infrastructure to track RDMA resources
Date: Thu, 11 Jan 2018 13:39:08 -0600
Message-ID: <016f01d38b13$d8d6c670$8a845350$@opengridcomputing.com>
References: <20180111153132.11143-1-leon@kernel.org> <20180111153132.11143-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111153132.11143-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The RDMA subsystem has very strict set of objects to work on it,
> but it completely lacks tracking facilities and no visibility of
> resource utilization.
> 
> The following patch adds such infrastructure to keep track of RDMA
> resources to help with debugging of user space applications. The primary
> user of this infrastructure is RDMA nldev netlink (following patches),
> but it is not limited too.
> 
> At this stage, the main three objects (PD, CQ and QP) are added,
> and more will be added later.
> 
> There are four new functions in use by RDMA/core:
>  * rdma_restrack_init(...)   - initializes restrack database
>  * rdma_restrack_clean(...)  - cleans restrack database
>  * rdma_restrack_add(...)    - adds object to be tracked
>  * rdma_restrack_del(...)    - removes object from tracking
> 
> 3 functions and one iterator visible to kernel users:
>  * rdma_restrack_count(...) - returns number of allocated objects of
> 			      specific type
>  * rdma_restrack_lock(...)  - Lock primitive to protect access to list
> 			      of resources
>  * rdma_restrack_unlock(...)- Unlock primitive to protect access to list
> 			      of resources
>  * for_each_res_safe(...)   - iterates over all relevant objects in
>    the restrack database.
> 
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
