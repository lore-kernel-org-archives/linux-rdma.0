From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v1 for-next 00/16] Bug fixes for ocrdma driver
Date: Mon, 23 Jun 2014 16:23:47 +0000
Message-ID: <0ba40047-f7b9-41be-82c2-489d34a3eee3@CMEXHTCAS1.ad.emulex.com>
References: <48668505-7613-4782-9fb8-14e3702f6051@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48668505-7613-4782-9fb8-14e3702f6051-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Please consider this series to be merged to the next pull request to Linus. This contains some critical bug fixes for ocrdma, and we don't want to miss
this pull cycle.

-Best Regards
 Devesh
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Selvin Xavier
> Sent: Tuesday, June 10, 2014 7:32 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Selvin Xavier
> Subject: [PATCH v1 for-next 00/16] Bug fixes for ocrdma driver
> 
> This patch series contains few bug fixes for ocrdma driver
> 
> Changes in v1:
>  Proper change logs are added as per Or's suggestion  Updating the ocrdma
> driver version string
> 
> Please apply to for-next tree
> 
> Devesh Sharma (5):
>   RDMA/ocrdma: Avoid posting DPP requests for RDMA READ
>   be2net: issue shutdown event to ocrdma driver
>   RDMA/ocrdma: Handle shutdown event from be2net driver
>   RDMA/ocrdma: Remove hardcoding of the max DPP QPs supported
>   RDMA/ocrdma: Delete AH table if ocrdma_init_hw fails after AH table
>     creation
> 
> Mitesh Ahuja (3):
>   RDMA/ocrdma: Allow only SEND opcode in case of UD QPs
>   RDMA/ocrdma: Do proper cleanup evenif FW is in error state
>   RDMA/ocrdma: Return proper value for max_mr_size
> 
> Selvin Xavier (8):
>   RDMA/ocrdma: Query and initalize the PFC SL
>   RDMA/ocrdma: Adding hca_type and fixing fw_version string in device
>     atrributes
>   RDMA/ocrdma: Avoid reporting wrong completions in case of error CQEs
>   RDMA/ocrdma : Add missing adapter mailbox opcodes
>   RDMA/ocrdma: Increase the size of STAG array in dev structure to 16K
>   RDMA/ocrdma: Initialize the GID table while registering the device
>   RDMA/ocrdma: Fixing a sparse warning
>   RDMA/ocrdma: Update the ocrdma module version string
> 
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |   26 ++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |    2 +
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  197
> ++++++++++++++++++++++++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |    2 +
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   83 +++++++++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  148 ++++++++++++++++----
> -
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   34 ++++-
>  drivers/net/ethernet/emulex/benet/be.h      |    1 +
>  drivers/net/ethernet/emulex/benet/be_main.c |    1 +
>  drivers/net/ethernet/emulex/benet/be_roce.c |   18 ++-
>  drivers/net/ethernet/emulex/benet/be_roce.h |    3 +-
>  11 files changed, 466 insertions(+), 49 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
