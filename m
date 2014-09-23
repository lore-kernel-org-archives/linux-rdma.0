From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/2] RDMA/ocrdma: ocrdma bug fixes
Date: Tue, 23 Sep 2014 09:59:22 +0000
Message-ID: <7959e835-4e40-495d-94be-f01efad98567@CMEXHTCAS2.ad.emulex.com>
References: <2a431e3d-4d09-49ff-a847-d9ef08ff2932@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2a431e3d-4d09-49ff-a847-d9ef08ff2932-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org)" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please include this series as well in your ongoing merge activity.

-Regards
 Devesh

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh Sharma
> Sent: Friday, August 22, 2014 4:57 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Devesh Sharma
> Subject: [PATCH 0/2] RDMA/ocrdma: ocrdma bug fixes
> 
> This series has bug fixes for 3.17
> 
> Devesh Sharma (1):
>   RDMA/ocrdma: add default gid at index 0
> 
> Selvin Xavier (1):
>   RDMA/ocrdma: get vlan tag from ib_qp_attrs
> 
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c   |    9 +++++----
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c |   10 ++++++++++
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
