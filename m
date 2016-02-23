From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 0/8] Introduce vector CALC support
Date: Tue, 23 Feb 2016 09:28:50 -0600
Message-ID: <008201d16e4e$e513f590$af3be0b0$@opengridcomputing.com>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456215928-9305-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Tuesday, February 23, 2016 2:25 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Leon Romanovsky
> Subject: [PATCH rdma-next V1 0/8] Introduce vector CALC support
> 
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch set introduces vector CALC support.
> 
> This feature takes as input several vectors of equal length,
> combines them with a single operation type, producing result vectors
> which are sent to the destination.
> 
> The proposed operations are "add, and, or, xor, max, min" and "swap
> endianness".
> 
> The hardware processes the data an MTU of at a time, processing the elements
> of each segment in parallel.
> 
> This patch set depends on commit b4ff3a36d3e4 ("net/mlx5: Use offset based
> reserved field names in the IFC header file") which is part of net tree.
> 

Hey Leon,

I look through this and I don't see any user of this.  I also don't see any API for submitting these operations.  Did I miss
something?  It looks like this series just cleans up some code and adds the ability to advertise CALC.  Where's the user(s)?

Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
