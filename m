From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Remove dead code from alloc_cached_mr()
Date: Tue, 28 Jul 2015 01:22:09 +0300
Message-ID: <20150727222209.GA24150@mtldesk30>
References: <1438033403-13129-1-git-send-email-roland@kernel.org>
 <DB4PR05MB4488F2A60FCD345F59A9542C58E0@DB4PR05MB448.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB4PR05MB4488F2A60FCD345F59A9542C58E0-xsq7jzH2t6kaHWsdJSteB2u6+pknBqLbXA4E9RH9d+qIuWR1G4zioA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Acked-by: Eli Cohen  <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> 
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> 
> The only place that assigns mr inside the loop already does a break.
> So "if (mr)" will never be true here since the function initializes mr to NULL at the top.  We can just drop the extra if and break here.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
