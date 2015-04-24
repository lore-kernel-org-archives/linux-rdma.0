From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v6 02/26] IB/Verbs: Implement raw management helpers
Date: Fri, 24 Apr 2015 15:15:54 +0000
Message-ID: <DB4PR05MB0863D872E5C4F95C4E01145FB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
 <1429878230-11749-3-git-send-email-yun.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429878230-11749-3-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> 
> Add raw helpers:
> 	rdma_tech_ib
> 	rdma_tech_iboe
> 	rdma_tech_iwarp
> 	rdma_ib_or_iboe (transition, clean up later) To help us detect which
> technology the port supported.
> 

Replace "rdma_tech_*" with "rdma_protocol_*".

> Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
> d54f91e..a12e876 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1748,6 +1748,31 @@ int ib_query_port(struct ib_device *device,  enum
> rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
>  					       u8 port_num);
> 
> +static inline int rdma_tech_ib(struct ib_device *device, u8 port_num) {
> +	return device->query_transport(device, port_num)
> +			== RDMA_TRANSPORT_IB;
> +}
> +
> +static inline int rdma_tech_iboe(struct ib_device *device, u8 port_num)
> +{
> +	return device->query_transport(device, port_num)
> +			== RDMA_TRANSPORT_IBOE;

Remove RDMA_TRANSPORT_IBOE.
In the current code, the test should be: (IB transport && Ethernet link layer).

We can later consider each provider declaring the transports directly.

> +}
> +
> +static inline int rdma_tech_iwarp(struct ib_device *device, u8
> +port_num) {
> +	return device->query_transport(device, port_num)
> +			== RDMA_TRANSPORT_IWARP;
> +}
> +
> +static inline int rdma_ib_or_iboe(struct ib_device *device, u8
> +port_num) {
> +	enum rdma_transport_type tp = device->query_transport(device,
> +port_num);
> +
> +	return (tp == RDMA_TRANSPORT_IB || tp ==
> RDMA_TRANSPORT_IBOE); }

Remove RDMA_TRANSPORT_IBOE.
Just test against RDMA_TRANSPORT_IB.

> +
>  int ib_query_gid(struct ib_device *device,
>  		 u8 port_num, int index, union ib_gid *gid);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
