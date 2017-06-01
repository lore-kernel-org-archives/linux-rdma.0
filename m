From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] RDMA/iw_cxgb4: Avoid touch after free error in ARP
 failure handlers
Date: Thu, 01 Jun 2017 18:21:35 -0400
Message-ID: <1496355695.7171.64.camel@redhat.com>
References: <20170511114354.25046-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170511114354.25046-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-11 at 17:13 +0530, Raju Rangoju wrote:
> The patch 761e19a504af: "RDMA/iw_cxgb4: Handle return value of
> c4iw_ofld_send() in abort_arp_failure()" from May 6, 2016, leads to
> the
> following static checker warning:
>         drivers/infiniband/hw/cxgb4/cm.c:575 abort_arp_failure()
>         warn: passing freed memory 'skb'
> 
> Also fixes skb leak when l2t resolution fails
> 
> Fixes: 761e19a504afa55 (RDMA/iw_cxgb4: Handle return value of
> c4iw_ofld_send() in abort_arp_failure())
> 
> Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
