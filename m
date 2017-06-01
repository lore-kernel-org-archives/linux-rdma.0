From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] i40iw: MPA connection establishment flow fixes
Date: Thu, 01 Jun 2017 18:11:32 -0400
Message-ID: <1496355092.7171.59.camel@redhat.com>
References: <20170505170517.10372-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170505170517.10372-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-05-05 at 12:05 -0500, Henry Orosco wrote:
> The following patch series contains fixes related to
> the MPA connection establishment flow.
> 
> Tatyana Nikolova (2):
>   i40iw: Don't set 0-length FULPDU RTR indication control flag
>   i40iw: ACK MPA Reject frame
> 
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
