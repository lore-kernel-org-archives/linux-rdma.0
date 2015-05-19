From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/cma: Resolve AF_IB UDP support
Date: Tue, 19 May 2015 00:24:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDCBAC@ORSMSX109.amr.corp.intel.com>
References: <AMSPR05MB4552E08900C6BCAC4FC106CA9C40@AMSPR05MB455.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AMSPR05MB4552E08900C6BCAC4FC106CA9C40-Vl31pUvGNwHn4lDZKhRW0Wu6+pknBqLbXA4E9RH9d+qIuWR1G4zioA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Finlay <Matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch format went wonky.

> -----Original Message-----
> From: Matthew Finlay [mailto:Matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org]
> Sent: Monday, May 18, 2015 3:14 PM
> To: Doug Ledford; Hefty, Sean
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] IB/cma: Resolve AF_IB UDP support
> 
> Support for using UD and AF_IB is currently broken.  The
> IB_CM_SIDR_REQ_RECEIVED
> message is not handled properly in cma_save_net_info() and we end up
> falling
> into code that will try and process the request as ipv4/ipv6, which will
> end
> up failing.
> 
> The resolution is to add a check for the SIDR_REQ and call
> cma_save_ib_info()
> with a NULL path record.  Change cma_save_ib_info() to copy the src sib
> info
> from the listen_id when the path record is NULL.
> 
> Reported-by: Hari Shankar <Hari.Shankar-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> drivers/infiniband/core/cma.c | 32 +++++++++++++++++++++-----------
> 1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 06441a4..38ffe09 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -845,18 +845,26 @@ static void cma_save_ib_info(struct rdma_cm_id *id,
> struct rdma_cm_id *listen_id
>  listen_ib = (struct sockaddr_ib *) &listen_id->route.addr.src_addr;
>  ib = (struct sockaddr_ib *) &id->route.addr.src_addr;
>  ib->sib_family = listen_ib->sib_family;
> -ib->sib_pkey = path->pkey;
> -ib->sib_flowinfo = path->flow_label;
> -memcpy(&ib->sib_addr, &path->sgid, 16);
> +if (path) {
> +ib->sib_pkey = path->pkey;
> +ib->sib_flowinfo = path->flow_label;
> +memcpy(&ib->sib_addr, &path->sgid, 16);
> +} else {
> +ib->sib_pkey = listen_ib->sib_pkey;
> +ib->sib_flowinfo = listen_ib->sib_flowinfo;
> +ib->sib_addr = listen_ib->sib_addr;
> +}
>  ib->sib_sid = listen_ib->sib_sid;
>  ib->sib_sid_mask = cpu_to_be64(0xffffffffffffffffULL);
>  ib->sib_scope_id = listen_ib->sib_scope_id;
> 
> -ib = (struct sockaddr_ib *) &id->route.addr.dst_addr;
> -ib->sib_family = listen_ib->sib_family;
> -ib->sib_pkey = path->pkey;
> -ib->sib_flowinfo = path->flow_label;
> -memcpy(&ib->sib_addr, &path->dgid, 16);
> +if (path) {
> +ib = (struct sockaddr_ib *) &id->route.addr.dst_addr;
> +ib->sib_family = listen_ib->sib_family;
> +ib->sib_pkey = path->pkey;
> +ib->sib_flowinfo = path->flow_label;
> +memcpy(&ib->sib_addr, &path->dgid, 16);
> +}
>  }
> 
>  static __be16 ss_get_port(const struct sockaddr_storage *ss)
> @@ -905,9 +913,11 @@ static int cma_save_net_info(struct rdma_cm_id *id,
> struct rdma_cm_id *listen_id
>  {
>  struct cma_hdr *hdr;
> 
> -if ((listen_id->route.addr.src_addr.ss_family == AF_IB) &&
> -    (ib_event->event == IB_CM_REQ_RECEIVED)) {
> -cma_save_ib_info(id, listen_id, ib_event->param.req_rcvd.primary_path);
> +if (listen_id->route.addr.src_addr.ss_family == AF_IB) {
> +if (ib_event->event == IB_CM_REQ_RECEIVED)
> +cma_save_ib_info(id, listen_id, ib_event->param.req_rcvd.primary_path);
> +else if (ib_event->event == IB_CM_SIDR_REQ_RECEIVED)
> +cma_save_ib_info(id, listen_id, NULL);
>  return 0;
>  }
> 
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
