From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/2] Expose max_sge_rd correctly
Date: Tue, 27 Oct 2015 09:26:46 -0500
Message-ID: <000a01d110c3$82583120$87089360$@opengridcomputing.com>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445938846-9240-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Tuesday, October 27, 2015 4:41 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Steve Wise; Nicholas A. Bellinger; Or Gerlitz; Doug Ledford
> Subject: [PATCH 0/2] Expose max_sge_rd correctly
> 
> This addresses a specific mlx4 issue where the max_sge_rd
> is actually smaller than max_sge (rdma reads with max_sge
> entries completes with error).
> 
> The second patch removes the explicit work-around from the
> iser target code.
> 
> This applies on top of Christoph's device attributes modification.
> 


Looks correct to me.

Series Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
