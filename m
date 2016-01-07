From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Thu, 7 Jan 2016 11:38:38 -0600
Message-ID: <00a701d14972$3dc6c070$b9544150$@opengridcomputing.com>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452158369-2938-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Matan Barak
> Sent: Thursday, January 07, 2016 3:19 AM
> To: Doug Ledford
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz; Majd Dibbiny; Hariprasad Shenai; Matan Barak
> Subject: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
> 
> cma_validate_port wrongly assumed that Ethernet devices are RoCE
> devices and thus their ndev should be matched in the GID table.
> This broke the iWarp support. Fixing that matching the ndev only if
> we work on a RoCE port.
> 
> Fixes: abae1b71dd37 ('IB/cma: cma_validate_port should verify the port
> 		     and netdevice')
> Reported-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Tested-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
