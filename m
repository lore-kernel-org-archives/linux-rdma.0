From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] Add missing neigh_release, fix ntuple calculation for IPv6
Date: Thu, 25 Sep 2014 12:23:42 -0500
Message-ID: <008201cfd8e5$742361e0$5c6a25a0$@opengridcomputing.com>
References: <1411511023-14101-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411511023-14101-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Roland, any chance these bug fixes can make 3.17?

Steve.
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hariprasad Shenai
> Sent: Tuesday, September 23, 2014 5:24 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
> Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; Hariprasad Shenai
> Subject: [PATCH 0/3] Add missing neigh_release, fix ntuple calculation for IPv6
> 
> This patch series adds missing neigh release in find_route function and also
> takes IPv6 into consideration in best_mtu and set_emss function. It also fixes
> ntuple calculation for IPv6 for T5 adapter.
> 
> The patches series is created against 'infiniband' tree.
> And includes patches on iw_cxgb4 driver.
> 
> We have included all the maintainers of respective drivers. Kindly review the
> change and let us know in case of any review comments.
> 
> Thanks
> 
> Hariprasad Shenai (3):
>   RDMA/cxgb4: Take IPv6 into account for best_mtu and set_emss
>   RDMA/cxgb4: Add missing neigh_release in find_route
>   RDMA/cxgb4: Fix ntuple calculation for ipv6 and remove duplicate line
> 
>  drivers/infiniband/hw/cxgb4/cm.c |   32 ++++++++++++++++++++------------
>  1 files changed, 20 insertions(+), 12 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
