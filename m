From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Add source address binding to iSER
Date: Fri, 2 Jun 2017 14:29:13 -0600
Message-ID: <CAANLjFpOLiB_87mLAS3TJbJMo7Hh033_PnpTyDCuCMjaHa2Y=g@mail.gmail.com>
References: <CAANLjFqUh4rhDKrv9gWQEuPiYUkZJTrpWtgw7kEBayZkRmetfA@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="94eb2c191f66b99c9b0551000175"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBG4VY7EQKGQEBA5CNFQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CAANLjFqUh4rhDKrv9gWQEuPiYUkZJTrpWtgw7kEBayZkRmetfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--94eb2c191f66b99c9b0551000175
Content-Type: text/plain; charset="UTF-8"

Attaching patches in case they are mangled.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Fri, Jun 2, 2017 at 1:13 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> First off, I've never done anything this complicated, please be gentle.
>
> Second, I know this will need to be broken up, but I'm not clear if
> each commit should be able to compile. It seems having a commit for
> each driver would make sense, but it won't compile cleanly without the
> others. How do I go about that?
>
> Third, this required a change to the kernel API(?) and I'm not sure
> the best way to to make that change backwards compatible.
>
> Forth, I'm getting an error on login. I don't think the kernel is even
> trying the login. Maybe I can get a pointer to help me get this
> resolved.
>
> # usr/iscsiadm -m iface -I iser3
> # BEGIN RECORD 2.0-874
> iface.iscsi_ifacename = iser3
> iface.net_ifacename = <empty>
> iface.ipaddress = fd00::14
> ...
> # usr/iscsiadm -m iface -I iser4
> # BEGIN RECORD 2.0-874
> iface.iscsi_ifacename = iser4
> iface.net_ifacename = <empty>
> iface.ipaddress = fd00::114
> ...
> # usr/iscsiadm -m discovery -t st -p fd00::13 -I iser3 -I iser4
> [fd00::13]:3260,1 iqn.2016-12.com.betterservers
> [fd00::13]:3260,1 iqn.2016-12.com.betterservers
> # usr/iscsiadm -m node -T iqn.2016-12.com.betterservers -p [fd00::13]:3260 -l
> Logging in to [iface: iser3, target: iqn.2016-12.com.betterservers,
> portal: fd00::13,3260] (multiple)
> Logging in to [iface: iser4, target: iqn.2016-12.com.betterservers,
> portal: fd00::13,3260] (multiple)
> iscsiadm: Could not login to [iface: iser3, target:
> iqn.2016-12.com.betterservers, portal: fd00::13,3260].
> iscsiadm: initiator reported error (12 - iSCSI driver not found.
> Please make sure it is loaded, and retry the operation)
> iscsiadm: Could not login to [iface: iser4, target:
> iqn.2016-12.com.betterservers, portal: fd00::13,3260].
> iscsiadm: initiator reported error (12 - iSCSI driver not found.
> Please make sure it is loaded, and retry the operation)
> iscsiadm: Could not log into all portals
>
> Patch to open-iscsi
> ----------------------------
> diff --git a/usr/netlink.c b/usr/netlink.c
> index 1a0bf80..c474375 100644
> --- a/usr/netlink.c
> +++ b/usr/netlink.c
> @@ -848,10 +848,13 @@ krecv_pdu_end(struct iscsi_conn *conn)
>  int
>  ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
>  {
> -        int rc, addrlen;
> +        int rc, addrlen = sizeof(struct sockaddr_storage);
>          struct iscsi_uevent *ev;
> -        struct sockaddr *dst_addr = (struct sockaddr *)&conn->saddr;
> +        struct sockaddr_storage *dst_addr = (struct sockaddr_storage
> *)&conn->saddr;
>          struct iovec iov[2];
> +        struct iscsi_session *tmp_session = (struct iscsi_session
> *)conn->session;
> +        node_rec_t *tmp_rec = (node_rec_t *)&tmp_session->nrec;
> +        iface_rec_t *tmp_iface = (iface_rec_t *)&tmp_rec->iface;
>
>          log_debug(7, "in %s", __FUNCTION__);
>
> @@ -868,19 +871,16 @@ ktransport_ep_connect(iscsi_conn_t *conn, int
> non_blocking)
>                  ev->u.ep_connect.non_blocking = non_blocking;
>          }
>
> -        if (dst_addr->sa_family == PF_INET)
> -                addrlen = sizeof(struct sockaddr_in);
> -        else if (dst_addr->sa_family == PF_INET6)
> -                addrlen = sizeof(struct sockaddr_in6);
> -        else {
> +        if (dst_addr->ss_family != AF_INET && dst_addr->ss_family !=
> AF_INET6) {
>                  log_error("%s unknown addr family %d",
> -                         __FUNCTION__, dst_addr->sa_family);
> +                         __FUNCTION__, dst_addr->ss_family);
>                  return -EINVAL;
>          }
>          memcpy(setparam_buf + sizeof(*ev), dst_addr, addrlen);
> +        iface_copy(setparam_buf + sizeof(*ev) + addrlen, tmp_iface);
>
>          iov[1].iov_base = ev;
> -        iov[1].iov_len = sizeof(*ev) + addrlen;
> +        iov[1].iov_len = sizeof(*ev) + addrlen + sizeof(iface_rec_t);
>          rc = __kipc_call(iov, 2);
>          if (rc < 0)
>                  return rc;
>
> Patch to kernel
> ----------------------
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
> b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 5a887ef..7ba5ed9 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -59,6 +59,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> +#include <linux/inet.h>
>
>  #include <net/sock.h>
>
> @@ -808,12 +809,16 @@ static int iscsi_iser_get_ep_param(struct
> iscsi_endpoint *ep,
>   *         if fails.
>   */
>  static struct iscsi_endpoint *
> -iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
> -                      int non_blocking)
> +iscsi_iser_ep_connect(struct Scsi_Host *shost, struct
> sockaddr_storage *dst_addr,
> +                      int non_blocking, struct iface_rec *iface)
>  {
>          int err;
>          struct iser_conn *iser_conn;
>          struct iscsi_endpoint *ep;
> +        struct sockaddr_storage src_addr;
> +        struct sockaddr_in *tmp_addr;
> +        struct sockaddr_in6 *tmp_addr6;
> +        memset(&src_addr, 0, sizeof(src_addr));
>
>          ep = iscsi_create_endpoint(0);
>          if (!ep)
> @@ -828,8 +833,28 @@ static int iscsi_iser_get_ep_param(struct
> iscsi_endpoint *ep,
>          ep->dd_data = iser_conn;
>          iser_conn->ep = ep;
>          iser_conn_init(iser_conn);
> -
> -        err = iser_connect(iser_conn, NULL, dst_addr, non_blocking);
> +        if (iface && iface->ipaddress[0]) {
> +                if (strchr(iface->ipaddress, ':')) {
> +                        tmp_addr6 = (struct sockaddr_in6 *)&src_addr;
> +                        tmp_addr6->sin6_family = AF_INET6;
> +                        if(!in6_pton(iface->ipaddress, -1,
> +                                 tmp_addr6->sin6_addr.s6_addr,
> +                                 -1, NULL)) {
> +                                err = -EINVAL;
> +                                goto failure;
> +                        }
> +                } else {
> +                        tmp_addr = (struct sockaddr_in *)&src_addr;
> +                        tmp_addr->sin_family = AF_INET;
> +                        if (!in4_pton(iface->ipaddress, -1,
> +                                 (u8 *)&tmp_addr->sin_addr.s_addr,
> +                                 -1, NULL)) {
> +                                err = -EINVAL;
> +                                goto failure;
> +                        }
> +                }
> +        }
> +        err = iser_connect(iser_conn, &src_addr, dst_addr, non_blocking);
>          if (err)
>                  goto failure;
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h
> b/drivers/infiniband/ulp/iser/iscsi_iser.h
> index c1ae4ae..1eda6ff 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
> @@ -628,8 +628,8 @@ void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
>                           enum iser_data_dir dir);
>
>  int  iser_connect(struct iser_conn *iser_conn,
> -                  struct sockaddr *src_addr,
> -                  struct sockaddr *dst_addr,
> +                  struct sockaddr_storage *src_addr,
> +                  struct sockaddr_storage *dst_addr,
>                    int non_blocking);
>
>  void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c
> b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 12ed62c..361d5e4 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -35,6 +35,7 @@
>  #include <linux/mm.h>
>  #include <linux/scatterlist.h>
>  #include <linux/kfifo.h>
> +#include <linux/if.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
>
> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c
> b/drivers/infiniband/ulp/iser/iser_memory.c
> index 9c3e9ab..c9d95b9 100644
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
> @@ -36,6 +36,7 @@
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
>  #include <linux/scatterlist.h>
> +#include <linux/if.h>
>
>  #include "iscsi_iser.h"
>  static
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c
> b/drivers/infiniband/ulp/iser/iser_verbs.c
> index c538a38..0a43009 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -35,6 +35,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> +#include <linux/if.h>
>
>  #include "iscsi_iser.h"
>
> @@ -941,8 +942,8 @@ void iser_conn_init(struct iser_conn *iser_conn)
>   * sleeps until the connection is established or rejected
>   */
>  int iser_connect(struct iser_conn   *iser_conn,
> -                 struct sockaddr    *src_addr,
> -                 struct sockaddr    *dst_addr,
> +                 struct sockaddr_storage *src_addr,
> +                 struct sockaddr_storage *dst_addr,
>                   int                 non_blocking)
>  {
>          struct ib_conn *ib_conn = &iser_conn->ib_conn;
> @@ -968,7 +969,8 @@ int iser_connect(struct iser_conn   *iser_conn,
>                  goto id_failure;
>          }
>
> -        err = rdma_resolve_addr(ib_conn->cma_id, src_addr, dst_addr, 1000);
> +        err = rdma_resolve_addr(ib_conn->cma_id, (struct sockaddr *)src_addr,
> +                                       (struct sockaddr *)dst_addr, 1000);
>          if (err) {
>                  iser_err("rdma_resolve_addr failed: %d\n", err);
>                  goto addr_failure;
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index a79a5e7..6617f2a 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -13,6 +13,7 @@
>   */
>
>  #include <scsi/iscsi_proto.h>
> +#include <linux/if.h>
>
>  #include "be_main.h"
>  #include "be.h"
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 97dca46..90adf20 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -12,6 +12,7 @@
>   *
>   */
>
> +#include <linux/if.h>
>  #include <scsi/libiscsi.h>
>  #include <scsi/scsi_transport_iscsi.h>
>  #include <scsi/scsi_transport.h>
> @@ -1161,8 +1162,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
>   * This routines first asks chip to create a connection and then
> allocates an EP
>   */
>  struct iscsi_endpoint *
> -beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
> -                   int non_blocking)
> +beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
> +                   int non_blocking, struct iface_rec *iface)
>  {
>          struct beiscsi_hba *phba;
>          struct beiscsi_endpoint *beiscsi_ep;
> @@ -1198,7 +1199,8 @@ struct iscsi_endpoint *
>          beiscsi_ep = ep->dd_data;
>          beiscsi_ep->phba = phba;
>          beiscsi_ep->openiscsi_ep = ep;
> -        ret = beiscsi_open_conn(ep, NULL, dst_addr, non_blocking);
> +        ret = beiscsi_open_conn(ep, NULL, (struct sockaddr *)dst_addr,
> +                                       non_blocking);
>          if (ret) {
>                  beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
>                              "BS_%d : Failed in beiscsi_open_conn\n");
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
> index b9d459a..68616f8 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.h
> +++ b/drivers/scsi/be2iscsi/be_iscsi.h
> @@ -68,8 +68,9 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
>  int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn);
>
>  struct iscsi_endpoint *beiscsi_ep_connect(struct Scsi_Host *shost,
> -                                          struct sockaddr *dst_addr,
> -                                          int non_blocking);
> +                                          struct sockaddr_storage *dst_addr,
> +                                          int non_blocking,
> +                                          struct iface_rec *iface);
>
>  int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index f862332..aab7772 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -25,6 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/bsg-lib.h>
>  #include <linux/irq_poll.h>
> +#include <linux/if.h>
>
>  #include <scsi/libiscsi.h>
>  #include <scsi/scsi_bsg_iscsi.h>
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index c737753..926afa4 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -13,6 +13,7 @@
>   */
>
>  #include <linux/bsg-lib.h>
> +#include <linux/if.h>
>  #include <scsi/scsi_transport_iscsi.h>
>  #include <scsi/scsi_bsg_iscsi.h>
>  #include "be_mgmt.h"
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 42921db..ce87ce2 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -15,6 +15,7 @@
>   */
>
>  #include <linux/gfp.h>
> +#include <linux/if.h>
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/libiscsi.h>
>  #include "bnx2i.h"
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index f32a66f..5151063 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -16,8 +16,10 @@
>   */
>
>  #include <linux/slab.h>
> +#include <linux/if.h>
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/libiscsi.h>
> +#include <scsi/scsi_transport_iscsi.h>
>  #include "bnx2i.h"
>
>  struct scsi_transport_template *bnx2i_scsi_xport_template;
> @@ -1771,8 +1773,9 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
>   *        sending down option-2 request to complete TCP 3-way handshake
>   */
>  static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
> -                                               struct sockaddr *dst_addr,
> -                                               int non_blocking)
> +                                               struct
> sockaddr_storage *dst_addr,
> +                                               int non_blocking,
> +                                               struct iface_rec *iface)
>  {
>          u32 iscsi_cid = BNX2I_CID_RESERVED;
>          struct sockaddr_in *desti = (struct sockaddr_in *) dst_addr;
> @@ -1792,7 +1795,7 @@ static struct iscsi_endpoint
> *bnx2i_ep_connect(struct Scsi_Host *shost,
>                   * check if the given destination can be reached through
>                   * a iscsi capable NetXtreme2 device
>                   */
> -                hba = bnx2i_check_route(dst_addr);
> +                hba = bnx2i_check_route((struct sockaddr *)dst_addr);
>
>          if (!hba) {
>                  rc = -EINVAL;
> @@ -1887,11 +1890,11 @@ static struct iscsi_endpoint
> *bnx2i_ep_connect(struct Scsi_Host *shost,
>          clear_bit(SK_TCP_TIMESTAMP, &bnx2i_ep->cm_sk->tcp_flags);
>
>          memset(&saddr, 0, sizeof(saddr));
> -        if (dst_addr->sa_family == AF_INET) {
> +        if (dst_addr->ss_family == AF_INET) {
>                  desti = (struct sockaddr_in *) dst_addr;
>                  saddr.remote.v4 = *desti;
>                  saddr.local.v4.sin_family = desti->sin_family;
> -        } else if (dst_addr->sa_family == AF_INET6) {
> +        } else if (dst_addr->ss_family == AF_INET6) {
>                  desti6 = (struct sockaddr_in6 *) dst_addr;
>                  saddr.remote.v6 = *desti6;
>                  saddr.local.v6.sin6_family = desti6->sin6_family;
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index bd7d39e..62f6230 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -2499,8 +2499,9 @@ int cxgbi_get_host_param(struct Scsi_Host
> *shost, enum iscsi_host_param param,
>  EXPORT_SYMBOL_GPL(cxgbi_get_host_param);
>
>  struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
> -                                        struct sockaddr *dst_addr,
> -                                        int non_blocking)
> +                                        struct sockaddr_storage *dst_addr,
> +                                        int non_blocking,
> +                                        struct iface_rec *iface)
>  {
>          struct iscsi_endpoint *ep;
>          struct cxgbi_endpoint *cep;
> @@ -2520,15 +2521,15 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct
> Scsi_Host *shost,
>                  }
>          }
>
> -        if (dst_addr->sa_family == AF_INET) {
> -                csk = cxgbi_check_route(dst_addr);
> +        if (dst_addr->ss_family == AF_INET) {
> +                csk = cxgbi_check_route((struct sockaddr *)dst_addr);
>  #if IS_ENABLED(CONFIG_IPV6)
> -        } else if (dst_addr->sa_family == AF_INET6) {
> -                csk = cxgbi_check_route6(dst_addr);
> +        } else if (dst_addr->ss_family == AF_INET6) {
> +                csk = cxgbi_check_route6((struct sockaddr *)dst_addr);
>  #endif
>          } else {
>                  pr_info("address family 0x%x NOT supported.\n",
> -                        dst_addr->sa_family);
> +                        dst_addr->ss_family);
>                  err = -EAFNOSUPPORT;
>                  return (struct iscsi_endpoint *)ERR_PTR(err);
>          }
> diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
> index 18e0ea8..e2e0c4d 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.h
> +++ b/drivers/scsi/cxgbi/libcxgbi.h
> @@ -596,7 +596,7 @@ int cxgbi_set_host_param(struct Scsi_Host *,
>                          enum iscsi_host_param, char *, int);
>  int cxgbi_get_host_param(struct Scsi_Host *, enum iscsi_host_param, char *);
>  struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *,
> -                        struct sockaddr *, int);
> +                        struct sockaddr_storage *, int, struct iface_rec *);
>  int cxgbi_ep_poll(struct iscsi_endpoint *, int);
>  void cxgbi_ep_disconnect(struct iscsi_endpoint *);
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 64c6fa5..4fccb58 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -119,8 +119,9 @@ static int qla4xxx_get_iface_param(struct
> iscsi_iface *iface,
>                                     int param, char *buf);
>  static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
>  static struct iscsi_endpoint *qla4xxx_ep_connect(struct Scsi_Host *shost,
> -                                                 struct sockaddr *dst_addr,
> -                                                 int non_blocking);
> +                                                 struct
> sockaddr_storage *dst_addr,
> +                                                 int non_blocking,
> +                                                 struct iface_rec *iface);
>  static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
>  static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep);
>  static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
> @@ -1656,8 +1657,8 @@ static int qla4xxx_get_iface_param(struct
> iscsi_iface *iface,
>  }
>
>  static struct iscsi_endpoint *
> -qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
> -                   int non_blocking)
> +qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
> +                   int non_blocking, struct iface_rec *iface)
>  {
>          int ret;
>          struct iscsi_endpoint *ep;
> @@ -1681,12 +1682,12 @@ static int qla4xxx_get_iface_param(struct
> iscsi_iface *iface,
>
>          qla_ep = ep->dd_data;
>          memset(qla_ep, 0, sizeof(struct qla_endpoint));
> -        if (dst_addr->sa_family == AF_INET) {
> +        if (dst_addr->ss_family == AF_INET) {
>                  memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct
> sockaddr_in));
>                  addr = (struct sockaddr_in *)&qla_ep->dst_addr;
>                  DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
>                                    (char *)&addr->sin_addr));
> -        } else if (dst_addr->sa_family == AF_INET6) {
> +        } else if (dst_addr->ss_family == AF_INET6) {
>                  memcpy(&qla_ep->dst_addr, dst_addr,
>                         sizeof(struct sockaddr_in6));
>                  addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
> @@ -6569,7 +6570,7 @@ static struct iscsi_endpoint
> *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
>                  addr->sin_port = htons(le16_to_cpu(fw_ddb_entry->port));
>          }
>
> -        ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
> +        ep = qla4xxx_ep_connect(ha->host, dst_addr, 0, NULL);
>          vfree(dst_addr);
>          return ep;
>  }
> diff --git a/drivers/scsi/scsi_transport_iscsi.c
> b/drivers/scsi/scsi_transport_iscsi.c
> index a424eae..64157a1 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -34,6 +34,7 @@
>  #include <scsi/iscsi_if.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_bsg_iscsi.h>
> +#include <linux/inet.h>
>
>  #define ISCSI_TRANSPORT_VERSION "2.0-870"
>
> @@ -2794,7 +2795,8 @@ static int iscsi_if_ep_connect(struct
> iscsi_transport *transport,
>                                 struct iscsi_uevent *ev, int msg_type)
>  {
>          struct iscsi_endpoint *ep;
> -        struct sockaddr *dst_addr;
> +        struct sockaddr_storage *dst_addr;
> +        struct iface_rec *iface;
>          struct Scsi_Host *shost = NULL;
>          int non_blocking, err = 0;
>
> @@ -2813,8 +2815,9 @@ static int iscsi_if_ep_connect(struct
> iscsi_transport *transport,
>          } else
>                  non_blocking = ev->u.ep_connect.non_blocking;
>
> -        dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
> -        ep = transport->ep_connect(shost, dst_addr, non_blocking);
> +        dst_addr = (struct sockaddr_storage *)((char*)ev + sizeof(*ev));
> +        iface = (struct iface_rec *)((char*)ev + sizeof(*ev) +
> sizeof(*dst_addr));
> +        ep = transport->ep_connect(shost, dst_addr, non_blocking, iface);
>          if (IS_ERR(ep)) {
>                  err = PTR_ERR(ep);
>                  goto release_host;
> diff --git a/include/scsi/scsi_transport_iscsi.h
> b/include/scsi/scsi_transport_iscsi.h
> index 6183d20..c146e90 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -37,6 +37,7 @@
>  struct iscsi_conn;
>  struct iscsi_task;
>  struct sockaddr;
> +struct iface_rec;
>  struct iscsi_iface;
>  struct bsg_job;
>  struct iscsi_bus_flash_session;
> @@ -132,8 +133,9 @@ struct iscsi_transport {
>
>          void (*session_recovery_timedout) (struct iscsi_cls_session *session);
>          struct iscsi_endpoint *(*ep_connect) (struct Scsi_Host *shost,
> -                                              struct sockaddr *dst_addr,
> -                                              int non_blocking);
> +                                              struct sockaddr_storage
> *dst_addr,
> +                                              int non_blocking,
> +                                              struct iface_rec *iface);
>          int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
>          void (*ep_disconnect) (struct iscsi_endpoint *ep);
>          int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
> @@ -291,6 +293,100 @@ struct iscsi_endpoint {
>          struct iscsi_cls_conn *conn;
>  };
>
> +/* max len of interface */
> +#define ISCSI_MAX_IFACE_LEN        65
> +#define NI_MAXHOST 1025
> +#define ISCSI_HWADDRESS_BUF_SIZE 18
> +#define ISCSI_TRANSPORT_NAME_MAXLEN 16
> +#define ISCSI_MAX_STR_LEN 80
> +
> +struct iface_rec {
> +        struct list_head        list;
> +        /* iscsi iface record name */
> +        char                        name[ISCSI_MAX_IFACE_LEN];
> +        uint32_t                iface_num;
> +        /* network layer iface name (eth0) */
> +        char                        netdev[IFNAMSIZ];
> +        char                        ipaddress[NI_MAXHOST];
> +        char                        subnet_mask[NI_MAXHOST];
> +        char                        gateway[NI_MAXHOST];
> +        char                        bootproto[ISCSI_MAX_STR_LEN];
> +        char                        ipv6_linklocal[NI_MAXHOST];
> +        char                        ipv6_router[NI_MAXHOST];
> +        char                        ipv6_autocfg[NI_MAXHOST];
> +        char                        linklocal_autocfg[NI_MAXHOST];
> +        char                        router_autocfg[NI_MAXHOST];
> +        uint16_t                vlan_id;
> +        uint8_t                        vlan_priority;
> +        char                        vlan_state[ISCSI_MAX_STR_LEN];
> +        char                        state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
> +                                                           * 1 = enable */
> +        uint16_t                mtu;
> +        uint16_t                port;
> +        char                        delayed_ack[ISCSI_MAX_STR_LEN];
> +        char                        nagle[ISCSI_MAX_STR_LEN];
> +        char                        tcp_wsf_state[ISCSI_MAX_STR_LEN];
> +        uint8_t                        tcp_wsf;
> +        uint8_t                        tcp_timer_scale;
> +        char                        tcp_timestamp[ISCSI_MAX_STR_LEN];
> +        char                        dhcp_dns[ISCSI_MAX_STR_LEN];
> +        char                        dhcp_slp_da[ISCSI_MAX_STR_LEN];
> +        char                        tos_state[ISCSI_MAX_STR_LEN];
> +        uint8_t                        tos;
> +        char                        gratuitous_arp[ISCSI_MAX_STR_LEN];
> +        char
> dhcp_alt_client_id_state[ISCSI_MAX_STR_LEN];
> +        char                        dhcp_alt_client_id[ISCSI_MAX_STR_LEN];
> +        char
> dhcp_req_vendor_id_state[ISCSI_MAX_STR_LEN];
> +        char                        dhcp_vendor_id_state[ISCSI_MAX_STR_LEN];
> +        char                        dhcp_vendor_id[ISCSI_MAX_STR_LEN];
> +        char                        dhcp_learn_iqn[ISCSI_MAX_STR_LEN];
> +        char                        fragmentation[ISCSI_MAX_STR_LEN];
> +        char                        incoming_forwarding[ISCSI_MAX_STR_LEN];
> +        uint8_t                        ttl;
> +        char                        gratuitous_neighbor_adv[ISCSI_MAX_STR_LEN];
> +        char                        redirect[ISCSI_MAX_STR_LEN];
> +        char                        mld[ISCSI_MAX_STR_LEN];
> +        uint32_t                flow_label;
> +        uint32_t                traffic_class;
> +        uint8_t                        hop_limit;
> +        uint32_t                nd_reachable_tmo;
> +        uint32_t                nd_rexmit_time;
> +        uint32_t                nd_stale_tmo;
> +        uint8_t                        dup_addr_detect_cnt;
> +        uint32_t                router_adv_link_mtu;
> +        uint16_t                def_task_mgmt_tmo;
> +        char                        header_digest[ISCSI_MAX_STR_LEN];
> +        char                        data_digest[ISCSI_MAX_STR_LEN];
> +        char                        immediate_data[ISCSI_MAX_STR_LEN];
> +        char                        initial_r2t[ISCSI_MAX_STR_LEN];
> +        char                        data_seq_inorder[ISCSI_MAX_STR_LEN];
> +        char                        data_pdu_inorder[ISCSI_MAX_STR_LEN];
> +        uint8_t                        erl;
> +        uint32_t                max_recv_dlength;
> +        uint32_t                first_burst_len;
> +        uint16_t                max_out_r2t;
> +        uint32_t                max_burst_len;
> +        char                        chap_auth[ISCSI_MAX_STR_LEN];
> +        char                        bidi_chap[ISCSI_MAX_STR_LEN];
> +        char                        strict_login_comp[ISCSI_MAX_STR_LEN];
> +        char                        discovery_auth[ISCSI_MAX_STR_LEN];
> +        char                        discovery_logout[ISCSI_MAX_STR_LEN];
> +        char                        port_state[ISCSI_MAX_STR_LEN];
> +        char                        port_speed[ISCSI_MAX_STR_LEN];
> +        /*
> +         * TODO: we may have to make this bigger and interconnect
> +         * specific for infiniband
> +         */
> +        char                        hwaddress[ISCSI_HWADDRESS_BUF_SIZE];
> +        char
> transport_name[ISCSI_TRANSPORT_NAME_MAXLEN];
> +        /*
> +         * This is only used for boot now, but the iser guys
> +         * can use this for their virtualization idea.
> +         */
> +        char                        alias[TARGET_NAME_MAXLEN + 1];
> +        char                        iname[TARGET_NAME_MAXLEN + 1];
> +};
> +
>  struct iscsi_iface {
>          struct device dev;
>          struct iscsi_transport *transport;
>
> Thank you,
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

--94eb2c191f66b99c9b0551000175
Content-Type: text/x-patch; charset="US-ASCII"; name="iser_binding.patch"
Content-Disposition: attachment; filename="iser_binding.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j3gaykfa0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2NzaV9pc2VyLmMgYi9k
cml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNjc2lfaXNlci5jCmluZGV4IDVhODg3ZWYuLjdi
YTVlZDkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2NzaV9pc2Vy
LmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VyL2lzY3NpX2lzZXIuYwpAQCAtNTks
NiArNTksNyBAQAogI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+CiAjaW5jbHVkZSA8bGludXgvc2xh
Yi5oPgogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUgPGxpbnV4L2luZXQuaD4K
IAogI2luY2x1ZGUgPG5ldC9zb2NrLmg+CiAKQEAgLTgwOCwxMiArODA5LDE2IEBAIHN0YXRpYyBp
bnQgaXNjc2lfaXNlcl9nZXRfZXBfcGFyYW0oc3RydWN0IGlzY3NpX2VuZHBvaW50ICplcCwKICAq
ICAgICAgICAgaWYgZmFpbHMuCiAgKi8KIHN0YXRpYyBzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKgot
aXNjc2lfaXNlcl9lcF9jb25uZWN0KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBzdHJ1Y3Qgc29j
a2FkZHIgKmRzdF9hZGRyLAotCQkgICAgICBpbnQgbm9uX2Jsb2NraW5nKQoraXNjc2lfaXNlcl9l
cF9jb25uZWN0KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFn
ZSAqZHN0X2FkZHIsCisJCSAgICAgIGludCBub25fYmxvY2tpbmcsIHN0cnVjdCBpZmFjZV9yZWMg
KmlmYWNlKQogewogCWludCBlcnI7CiAJc3RydWN0IGlzZXJfY29ubiAqaXNlcl9jb25uOwogCXN0
cnVjdCBpc2NzaV9lbmRwb2ludCAqZXA7CisJc3RydWN0IHNvY2thZGRyX3N0b3JhZ2Ugc3JjX2Fk
ZHI7CisJc3RydWN0IHNvY2thZGRyX2luICp0bXBfYWRkcjsKKwlzdHJ1Y3Qgc29ja2FkZHJfaW42
ICp0bXBfYWRkcjY7CisJbWVtc2V0KCZzcmNfYWRkciwgMCwgc2l6ZW9mKHNyY19hZGRyKSk7CiAK
IAllcCA9IGlzY3NpX2NyZWF0ZV9lbmRwb2ludCgwKTsKIAlpZiAoIWVwKQpAQCAtODI4LDggKzgz
MywyOCBAQCBzdGF0aWMgaW50IGlzY3NpX2lzZXJfZ2V0X2VwX3BhcmFtKHN0cnVjdCBpc2NzaV9l
bmRwb2ludCAqZXAsCiAJZXAtPmRkX2RhdGEgPSBpc2VyX2Nvbm47CiAJaXNlcl9jb25uLT5lcCA9
IGVwOwogCWlzZXJfY29ubl9pbml0KGlzZXJfY29ubik7Ci0KLQllcnIgPSBpc2VyX2Nvbm5lY3Qo
aXNlcl9jb25uLCBOVUxMLCBkc3RfYWRkciwgbm9uX2Jsb2NraW5nKTsKKwlpZiAoaWZhY2UgJiYg
aWZhY2UtPmlwYWRkcmVzc1swXSkgeworCQlpZiAoc3RyY2hyKGlmYWNlLT5pcGFkZHJlc3MsICc6
JykpIHsKKwkJCXRtcF9hZGRyNiA9IChzdHJ1Y3Qgc29ja2FkZHJfaW42ICopJnNyY19hZGRyOwor
CQkJdG1wX2FkZHI2LT5zaW42X2ZhbWlseSA9IEFGX0lORVQ2OworCQkJaWYoIWluNl9wdG9uKGlm
YWNlLT5pcGFkZHJlc3MsIC0xLAorCQkJCSB0bXBfYWRkcjYtPnNpbjZfYWRkci5zNl9hZGRyLAor
CQkJCSAtMSwgTlVMTCkpIHsKKwkJCQllcnIgPSAtRUlOVkFMOworCQkJCWdvdG8gZmFpbHVyZTsK
KwkJCX0KKwkJfSBlbHNlIHsKKwkJCXRtcF9hZGRyID0gKHN0cnVjdCBzb2NrYWRkcl9pbiAqKSZz
cmNfYWRkcjsKKwkJCXRtcF9hZGRyLT5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKKwkJCWlmICghaW40
X3B0b24oaWZhY2UtPmlwYWRkcmVzcywgLTEsCisJCQkJICh1OCAqKSZ0bXBfYWRkci0+c2luX2Fk
ZHIuc19hZGRyLAorCQkJCSAtMSwgTlVMTCkpIHsKKwkJCQllcnIgPSAtRUlOVkFMOworCQkJCWdv
dG8gZmFpbHVyZTsKKwkJCX0KKwkJfQorCX0KKwllcnIgPSBpc2VyX2Nvbm5lY3QoaXNlcl9jb25u
LCAmc3JjX2FkZHIsIGRzdF9hZGRyLCBub25fYmxvY2tpbmcpOwogCWlmIChlcnIpCiAJCWdvdG8g
ZmFpbHVyZTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VyL2lzY3Np
X2lzZXIuaCBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2NzaV9pc2VyLmgKaW5kZXgg
YzFhZTRhZS4uMWVkYTZmZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2Vy
L2lzY3NpX2lzZXIuaAorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNjc2lfaXNl
ci5oCkBAIC02MjgsOCArNjI4LDggQEAgdm9pZCBpc2VyX3VucmVnX3JkbWFfbWVtKHN0cnVjdCBp
c2NzaV9pc2VyX3Rhc2sgKnRhc2ssCiAJCQkgZW51bSBpc2VyX2RhdGFfZGlyIGRpcik7CiAKIGlu
dCAgaXNlcl9jb25uZWN0KHN0cnVjdCBpc2VyX2Nvbm4gKmlzZXJfY29ubiwKLQkJICBzdHJ1Y3Qg
c29ja2FkZHIgKnNyY19hZGRyLAotCQkgIHN0cnVjdCBzb2NrYWRkciAqZHN0X2FkZHIsCisJCSAg
c3RydWN0IHNvY2thZGRyX3N0b3JhZ2UgKnNyY19hZGRyLAorCQkgIHN0cnVjdCBzb2NrYWRkcl9z
dG9yYWdlICpkc3RfYWRkciwKIAkJICBpbnQgbm9uX2Jsb2NraW5nKTsKIAogdm9pZCBpc2VyX3Vu
cmVnX21lbV9mbXIoc3RydWN0IGlzY3NpX2lzZXJfdGFzayAqaXNlcl90YXNrLApkaWZmIC0tZ2l0
IGEvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pc2VyL2lzZXJfaW5pdGlhdG9yLmMgYi9kcml2ZXJz
L2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl9pbml0aWF0b3IuYwppbmRleCAxMmVkNjJjLi4zNjFk
NWU0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl9pbml0aWF0
b3IuYworKysgYi9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl9pbml0aWF0b3IuYwpA
QCAtMzUsNiArMzUsNyBAQAogI2luY2x1ZGUgPGxpbnV4L21tLmg+CiAjaW5jbHVkZSA8bGludXgv
c2NhdHRlcmxpc3QuaD4KICNpbmNsdWRlIDxsaW51eC9rZmlmby5oPgorI2luY2x1ZGUgPGxpbnV4
L2lmLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3NpX2NtbmQuaD4KICNpbmNsdWRlIDxzY3NpL3Njc2lf
aG9zdC5oPgogCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl9t
ZW1vcnkuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2VyX21lbW9yeS5jCmluZGV4
IDljM2U5YWIuLmM5ZDk1YjkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNl
ci9pc2VyX21lbW9yeS5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2VyX21l
bW9yeS5jCkBAIC0zNiw2ICszNiw3IEBACiAjaW5jbHVkZSA8bGludXgvbW0uaD4KICNpbmNsdWRl
IDxsaW51eC9oaWdobWVtLmg+CiAjaW5jbHVkZSA8bGludXgvc2NhdHRlcmxpc3QuaD4KKyNpbmNs
dWRlIDxsaW51eC9pZi5oPgogCiAjaW5jbHVkZSAiaXNjc2lfaXNlci5oIgogc3RhdGljCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl92ZXJicy5jIGIvZHJpdmVy
cy9pbmZpbmliYW5kL3VscC9pc2VyL2lzZXJfdmVyYnMuYwppbmRleCBjNTM4YTM4Li4wYTQzMDA5
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXIvaXNlcl92ZXJicy5jCisr
KyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlci9pc2VyX3ZlcmJzLmMKQEAgLTM1LDYgKzM1
LDcgQEAKICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+
CiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KKyNpbmNsdWRlIDxsaW51eC9pZi5oPgogCiAjaW5j
bHVkZSAiaXNjc2lfaXNlci5oIgogCkBAIC05NDEsOCArOTQyLDggQEAgdm9pZCBpc2VyX2Nvbm5f
aW5pdChzdHJ1Y3QgaXNlcl9jb25uICppc2VyX2Nvbm4pCiAgKiBzbGVlcHMgdW50aWwgdGhlIGNv
bm5lY3Rpb24gaXMgZXN0YWJsaXNoZWQgb3IgcmVqZWN0ZWQKICAqLwogaW50IGlzZXJfY29ubmVj
dChzdHJ1Y3QgaXNlcl9jb25uICAgKmlzZXJfY29ubiwKLQkJIHN0cnVjdCBzb2NrYWRkciAgICAq
c3JjX2FkZHIsCi0JCSBzdHJ1Y3Qgc29ja2FkZHIgICAgKmRzdF9hZGRyLAorCQkgc3RydWN0IHNv
Y2thZGRyX3N0b3JhZ2UgKnNyY19hZGRyLAorCQkgc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UgKmRz
dF9hZGRyLAogCQkgaW50ICAgICAgICAgICAgICAgICBub25fYmxvY2tpbmcpCiB7CiAJc3RydWN0
IGliX2Nvbm4gKmliX2Nvbm4gPSAmaXNlcl9jb25uLT5pYl9jb25uOwpAQCAtOTY4LDcgKzk2OSw4
IEBAIGludCBpc2VyX2Nvbm5lY3Qoc3RydWN0IGlzZXJfY29ubiAgICppc2VyX2Nvbm4sCiAJCWdv
dG8gaWRfZmFpbHVyZTsKIAl9CiAKLQllcnIgPSByZG1hX3Jlc29sdmVfYWRkcihpYl9jb25uLT5j
bWFfaWQsIHNyY19hZGRyLCBkc3RfYWRkciwgMTAwMCk7CisJZXJyID0gcmRtYV9yZXNvbHZlX2Fk
ZHIoaWJfY29ubi0+Y21hX2lkLCAoc3RydWN0IHNvY2thZGRyICopc3JjX2FkZHIsCisJCSAgICAg
ICAJCShzdHJ1Y3Qgc29ja2FkZHIgKilkc3RfYWRkciwgMTAwMCk7CiAJaWYgKGVycikgewogCQlp
c2VyX2VycigicmRtYV9yZXNvbHZlX2FkZHIgZmFpbGVkOiAlZFxuIiwgZXJyKTsKIAkJZ290byBh
ZGRyX2ZhaWx1cmU7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvYmUyaXNjc2kvYmVfY21kcy5j
IGIvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX2NtZHMuYwppbmRleCBhNzlhNWU3Li42NjE3ZjJh
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvYmUyaXNjc2kvYmVfY21kcy5jCisrKyBiL2RyaXZl
cnMvc2NzaS9iZTJpc2NzaS9iZV9jbWRzLmMKQEAgLTEzLDYgKzEzLDcgQEAKICAqLwogCiAjaW5j
bHVkZSA8c2NzaS9pc2NzaV9wcm90by5oPgorI2luY2x1ZGUgPGxpbnV4L2lmLmg+CiAKICNpbmNs
dWRlICJiZV9tYWluLmgiCiAjaW5jbHVkZSAiYmUuaCIKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS9iZTJpc2NzaS9iZV9pc2NzaS5jIGIvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX2lzY3NpLmMK
aW5kZXggOTdkY2E0Ni4uOTBhZGYyMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2JlMmlzY3Np
L2JlX2lzY3NpLmMKKysrIGIvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX2lzY3NpLmMKQEAgLTEy
LDYgKzEyLDcgQEAKICAqCiAgKi8KIAorI2luY2x1ZGUgPGxpbnV4L2lmLmg+CiAjaW5jbHVkZSA8
c2NzaS9saWJpc2NzaS5oPgogI2luY2x1ZGUgPHNjc2kvc2NzaV90cmFuc3BvcnRfaXNjc2kuaD4K
ICNpbmNsdWRlIDxzY3NpL3Njc2lfdHJhbnNwb3J0Lmg+CkBAIC0xMTYxLDggKzExNjIsOCBAQCBz
dGF0aWMgaW50IGJlaXNjc2lfb3Blbl9jb25uKHN0cnVjdCBpc2NzaV9lbmRwb2ludCAqZXAsCiAg
KiBUaGlzIHJvdXRpbmVzIGZpcnN0IGFza3MgY2hpcCB0byBjcmVhdGUgYSBjb25uZWN0aW9uIGFu
ZCB0aGVuIGFsbG9jYXRlcyBhbiBFUAogICovCiBzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKgotYmVp
c2NzaV9lcF9jb25uZWN0KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBzdHJ1Y3Qgc29ja2FkZHIg
KmRzdF9hZGRyLAotCQkgICBpbnQgbm9uX2Jsb2NraW5nKQorYmVpc2NzaV9lcF9jb25uZWN0KHN0
cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSAqZHN0X2FkZHIs
CisJCSAgIGludCBub25fYmxvY2tpbmcsIHN0cnVjdCBpZmFjZV9yZWMgKmlmYWNlKQogewogCXN0
cnVjdCBiZWlzY3NpX2hiYSAqcGhiYTsKIAlzdHJ1Y3QgYmVpc2NzaV9lbmRwb2ludCAqYmVpc2Nz
aV9lcDsKQEAgLTExOTgsNyArMTE5OSw4IEBAIHN0cnVjdCBpc2NzaV9lbmRwb2ludCAqCiAJYmVp
c2NzaV9lcCA9IGVwLT5kZF9kYXRhOwogCWJlaXNjc2lfZXAtPnBoYmEgPSBwaGJhOwogCWJlaXNj
c2lfZXAtPm9wZW5pc2NzaV9lcCA9IGVwOwotCXJldCA9IGJlaXNjc2lfb3Blbl9jb25uKGVwLCBO
VUxMLCBkc3RfYWRkciwgbm9uX2Jsb2NraW5nKTsKKwlyZXQgPSBiZWlzY3NpX29wZW5fY29ubihl
cCwgTlVMTCwgKHN0cnVjdCBzb2NrYWRkciAqKWRzdF9hZGRyLAorCQkgICAgICAgCQlub25fYmxv
Y2tpbmcpOwogCWlmIChyZXQpIHsKIAkJYmVpc2NzaV9sb2cocGhiYSwgS0VSTl9FUlIsIEJFSVND
U0lfTE9HX0NPTkZJRywKIAkJCSAgICAiQlNfJWQgOiBGYWlsZWQgaW4gYmVpc2NzaV9vcGVuX2Nv
bm5cbiIpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX2lzY3NpLmggYi9k
cml2ZXJzL3Njc2kvYmUyaXNjc2kvYmVfaXNjc2kuaAppbmRleCBiOWQ0NTlhLi42ODYxNmY4IDEw
MDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvYmUyaXNjc2kvYmVfaXNjc2kuaAorKysgYi9kcml2ZXJz
L3Njc2kvYmUyaXNjc2kvYmVfaXNjc2kuaApAQCAtNjgsOCArNjgsOSBAQCBpbnQgYmVpc2NzaV9z
ZXRfcGFyYW0oc3RydWN0IGlzY3NpX2Nsc19jb25uICpjbHNfY29ubiwKIGludCBiZWlzY3NpX2Nv
bm5fc3RhcnQoc3RydWN0IGlzY3NpX2Nsc19jb25uICpjbHNfY29ubik7CiAKIHN0cnVjdCBpc2Nz
aV9lbmRwb2ludCAqYmVpc2NzaV9lcF9jb25uZWN0KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LAot
CQkJCQkgIHN0cnVjdCBzb2NrYWRkciAqZHN0X2FkZHIsCi0JCQkJCSAgaW50IG5vbl9ibG9ja2lu
Zyk7CisJCQkJCSAgc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UgKmRzdF9hZGRyLAorCQkJCQkgIGlu
dCBub25fYmxvY2tpbmcsCisJCQkJCSAgc3RydWN0IGlmYWNlX3JlYyAqaWZhY2UpOwogCiBpbnQg
YmVpc2NzaV9lcF9wb2xsKHN0cnVjdCBpc2NzaV9lbmRwb2ludCAqZXAsIGludCB0aW1lb3V0X21z
KTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21haW4uYyBiL2RyaXZl
cnMvc2NzaS9iZTJpc2NzaS9iZV9tYWluLmMKaW5kZXggZjg2MjMzMi4uYWFiNzc3MiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21haW4uYworKysgYi9kcml2ZXJzL3Njc2kv
YmUyaXNjc2kvYmVfbWFpbi5jCkBAIC0yNSw2ICsyNSw3IEBACiAjaW5jbHVkZSA8bGludXgvbW9k
dWxlLmg+CiAjaW5jbHVkZSA8bGludXgvYnNnLWxpYi5oPgogI2luY2x1ZGUgPGxpbnV4L2lycV9w
b2xsLmg+CisjaW5jbHVkZSA8bGludXgvaWYuaD4KIAogI2luY2x1ZGUgPHNjc2kvbGliaXNjc2ku
aD4KICNpbmNsdWRlIDxzY3NpL3Njc2lfYnNnX2lzY3NpLmg+CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvYmUyaXNjc2kvYmVfbWdtdC5jIGIvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21nbXQu
YwppbmRleCBjNzM3NzUzLi45MjZhZmE0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvYmUyaXNj
c2kvYmVfbWdtdC5jCisrKyBiL2RyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tZ210LmMKQEAgLTEz
LDYgKzEzLDcgQEAKICAqLwogCiAjaW5jbHVkZSA8bGludXgvYnNnLWxpYi5oPgorI2luY2x1ZGUg
PGxpbnV4L2lmLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5oPgogI2lu
Y2x1ZGUgPHNjc2kvc2NzaV9ic2dfaXNjc2kuaD4KICNpbmNsdWRlICJiZV9tZ210LmgiCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvYm54MmkvYm54MmlfaHdpLmMgYi9kcml2ZXJzL3Njc2kvYm54
MmkvYm54MmlfaHdpLmMKaW5kZXggNDI5MjFkYi4uY2U4N2NlMiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zY3NpL2JueDJpL2JueDJpX2h3aS5jCisrKyBiL2RyaXZlcnMvc2NzaS9ibngyaS9ibngyaV9o
d2kuYwpAQCAtMTUsNiArMTUsNyBAQAogICovCiAKICNpbmNsdWRlIDxsaW51eC9nZnAuaD4KKyNp
bmNsdWRlIDxsaW51eC9pZi5oPgogI2luY2x1ZGUgPHNjc2kvc2NzaV90Y3EuaD4KICNpbmNsdWRl
IDxzY3NpL2xpYmlzY3NpLmg+CiAjaW5jbHVkZSAiYm54MmkuaCIKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9ibngyaS9ibngyaV9pc2NzaS5jIGIvZHJpdmVycy9zY3NpL2JueDJpL2JueDJpX2lz
Y3NpLmMKaW5kZXggZjMyYTY2Zi4uNTE1MTA2MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2Ju
eDJpL2JueDJpX2lzY3NpLmMKKysrIGIvZHJpdmVycy9zY3NpL2JueDJpL2JueDJpX2lzY3NpLmMK
QEAgLTE2LDggKzE2LDEwIEBACiAgKi8KIAogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNs
dWRlIDxsaW51eC9pZi5oPgogI2luY2x1ZGUgPHNjc2kvc2NzaV90Y3EuaD4KICNpbmNsdWRlIDxz
Y3NpL2xpYmlzY3NpLmg+CisjaW5jbHVkZSA8c2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5oPgog
I2luY2x1ZGUgImJueDJpLmgiCiAKIHN0cnVjdCBzY3NpX3RyYW5zcG9ydF90ZW1wbGF0ZSAqYm54
Mmlfc2NzaV94cG9ydF90ZW1wbGF0ZTsKQEAgLTE3NzEsOCArMTc3Myw5IEBAIHN0YXRpYyBpbnQg
Ym54MmlfdGVhcl9kb3duX2Nvbm4oc3RydWN0IGJueDJpX2hiYSAqaGJhLAogICoJc2VuZGluZyBk
b3duIG9wdGlvbi0yIHJlcXVlc3QgdG8gY29tcGxldGUgVENQIDMtd2F5IGhhbmRzaGFrZQogICov
CiBzdGF0aWMgc3RydWN0IGlzY3NpX2VuZHBvaW50ICpibngyaV9lcF9jb25uZWN0KHN0cnVjdCBT
Y3NpX0hvc3QgKnNob3N0LAotCQkJCQkgICAgICAgc3RydWN0IHNvY2thZGRyICpkc3RfYWRkciwK
LQkJCQkJICAgICAgIGludCBub25fYmxvY2tpbmcpCisJCQkJCSAgICAgICBzdHJ1Y3Qgc29ja2Fk
ZHJfc3RvcmFnZSAqZHN0X2FkZHIsCisJCQkJCSAgICAgICBpbnQgbm9uX2Jsb2NraW5nLAorCQkJ
CQkgICAgICAgc3RydWN0IGlmYWNlX3JlYyAqaWZhY2UpCiB7CiAJdTMyIGlzY3NpX2NpZCA9IEJO
WDJJX0NJRF9SRVNFUlZFRDsKIAlzdHJ1Y3Qgc29ja2FkZHJfaW4gKmRlc3RpID0gKHN0cnVjdCBz
b2NrYWRkcl9pbiAqKSBkc3RfYWRkcjsKQEAgLTE3OTIsNyArMTc5NSw3IEBAIHN0YXRpYyBzdHJ1
Y3QgaXNjc2lfZW5kcG9pbnQgKmJueDJpX2VwX2Nvbm5lY3Qoc3RydWN0IFNjc2lfSG9zdCAqc2hv
c3QsCiAJCSAqIGNoZWNrIGlmIHRoZSBnaXZlbiBkZXN0aW5hdGlvbiBjYW4gYmUgcmVhY2hlZCB0
aHJvdWdoCiAJCSAqIGEgaXNjc2kgY2FwYWJsZSBOZXRYdHJlbWUyIGRldmljZQogCQkgKi8KLQkJ
aGJhID0gYm54MmlfY2hlY2tfcm91dGUoZHN0X2FkZHIpOworCQloYmEgPSBibngyaV9jaGVja19y
b3V0ZSgoc3RydWN0IHNvY2thZGRyICopZHN0X2FkZHIpOwogCiAJaWYgKCFoYmEpIHsKIAkJcmMg
PSAtRUlOVkFMOwpAQCAtMTg4NywxMSArMTg5MCwxMSBAQCBzdGF0aWMgc3RydWN0IGlzY3NpX2Vu
ZHBvaW50ICpibngyaV9lcF9jb25uZWN0KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LAogCWNsZWFy
X2JpdChTS19UQ1BfVElNRVNUQU1QLCAmYm54MmlfZXAtPmNtX3NrLT50Y3BfZmxhZ3MpOwogCiAJ
bWVtc2V0KCZzYWRkciwgMCwgc2l6ZW9mKHNhZGRyKSk7Ci0JaWYgKGRzdF9hZGRyLT5zYV9mYW1p
bHkgPT0gQUZfSU5FVCkgeworCWlmIChkc3RfYWRkci0+c3NfZmFtaWx5ID09IEFGX0lORVQpIHsK
IAkJZGVzdGkgPSAoc3RydWN0IHNvY2thZGRyX2luICopIGRzdF9hZGRyOwogCQlzYWRkci5yZW1v
dGUudjQgPSAqZGVzdGk7CiAJCXNhZGRyLmxvY2FsLnY0LnNpbl9mYW1pbHkgPSBkZXN0aS0+c2lu
X2ZhbWlseTsKLQl9IGVsc2UgaWYgKGRzdF9hZGRyLT5zYV9mYW1pbHkgPT0gQUZfSU5FVDYpIHsK
Kwl9IGVsc2UgaWYgKGRzdF9hZGRyLT5zc19mYW1pbHkgPT0gQUZfSU5FVDYpIHsKIAkJZGVzdGk2
ID0gKHN0cnVjdCBzb2NrYWRkcl9pbjYgKikgZHN0X2FkZHI7CiAJCXNhZGRyLnJlbW90ZS52NiA9
ICpkZXN0aTY7CiAJCXNhZGRyLmxvY2FsLnY2LnNpbjZfZmFtaWx5ID0gZGVzdGk2LT5zaW42X2Zh
bWlseTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9jeGdiaS9saWJjeGdiaS5jIGIvZHJpdmVy
cy9zY3NpL2N4Z2JpL2xpYmN4Z2JpLmMKaW5kZXggYmQ3ZDM5ZS4uNjJmNjIzMCAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zY3NpL2N4Z2JpL2xpYmN4Z2JpLmMKKysrIGIvZHJpdmVycy9zY3NpL2N4Z2Jp
L2xpYmN4Z2JpLmMKQEAgLTI0OTksOCArMjQ5OSw5IEBAIGludCBjeGdiaV9nZXRfaG9zdF9wYXJh
bShzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwgZW51bSBpc2NzaV9ob3N0X3BhcmFtIHBhcmFtLAog
RVhQT1JUX1NZTUJPTF9HUEwoY3hnYmlfZ2V0X2hvc3RfcGFyYW0pOwogCiBzdHJ1Y3QgaXNjc2lf
ZW5kcG9pbnQgKmN4Z2JpX2VwX2Nvbm5lY3Qoc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QsCi0JCQkJ
CXN0cnVjdCBzb2NrYWRkciAqZHN0X2FkZHIsCi0JCQkJCWludCBub25fYmxvY2tpbmcpCisJCQkJ
CXN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlICpkc3RfYWRkciwKKwkJCQkJaW50IG5vbl9ibG9ja2lu
ZywKKwkJCQkJc3RydWN0IGlmYWNlX3JlYyAqaWZhY2UpCiB7CiAJc3RydWN0IGlzY3NpX2VuZHBv
aW50ICplcDsKIAlzdHJ1Y3QgY3hnYmlfZW5kcG9pbnQgKmNlcDsKQEAgLTI1MjAsMTUgKzI1MjEs
MTUgQEAgc3RydWN0IGlzY3NpX2VuZHBvaW50ICpjeGdiaV9lcF9jb25uZWN0KHN0cnVjdCBTY3Np
X0hvc3QgKnNob3N0LAogCQl9CiAJfQogCi0JaWYgKGRzdF9hZGRyLT5zYV9mYW1pbHkgPT0gQUZf
SU5FVCkgewotCQljc2sgPSBjeGdiaV9jaGVja19yb3V0ZShkc3RfYWRkcik7CisJaWYgKGRzdF9h
ZGRyLT5zc19mYW1pbHkgPT0gQUZfSU5FVCkgeworCQljc2sgPSBjeGdiaV9jaGVja19yb3V0ZSgo
c3RydWN0IHNvY2thZGRyICopZHN0X2FkZHIpOwogI2lmIElTX0VOQUJMRUQoQ09ORklHX0lQVjYp
Ci0JfSBlbHNlIGlmIChkc3RfYWRkci0+c2FfZmFtaWx5ID09IEFGX0lORVQ2KSB7Ci0JCWNzayA9
IGN4Z2JpX2NoZWNrX3JvdXRlNihkc3RfYWRkcik7CisJfSBlbHNlIGlmIChkc3RfYWRkci0+c3Nf
ZmFtaWx5ID09IEFGX0lORVQ2KSB7CisJCWNzayA9IGN4Z2JpX2NoZWNrX3JvdXRlNigoc3RydWN0
IHNvY2thZGRyICopZHN0X2FkZHIpOwogI2VuZGlmCiAJfSBlbHNlIHsKIAkJcHJfaW5mbygiYWRk
cmVzcyBmYW1pbHkgMHgleCBOT1Qgc3VwcG9ydGVkLlxuIiwKLQkJCWRzdF9hZGRyLT5zYV9mYW1p
bHkpOworCQkJZHN0X2FkZHItPnNzX2ZhbWlseSk7CiAJCWVyciA9IC1FQUZOT1NVUFBPUlQ7CiAJ
CXJldHVybiAoc3RydWN0IGlzY3NpX2VuZHBvaW50ICopRVJSX1BUUihlcnIpOwogCX0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9jeGdiaS9saWJjeGdiaS5oIGIvZHJpdmVycy9zY3NpL2N4Z2Jp
L2xpYmN4Z2JpLmgKaW5kZXggMThlMGVhOC4uZTJlMGM0ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
Y3NpL2N4Z2JpL2xpYmN4Z2JpLmgKKysrIGIvZHJpdmVycy9zY3NpL2N4Z2JpL2xpYmN4Z2JpLmgK
QEAgLTU5Niw3ICs1OTYsNyBAQCBpbnQgY3hnYmlfc2V0X2hvc3RfcGFyYW0oc3RydWN0IFNjc2lf
SG9zdCAqLAogCQkJZW51bSBpc2NzaV9ob3N0X3BhcmFtLCBjaGFyICosIGludCk7CiBpbnQgY3hn
YmlfZ2V0X2hvc3RfcGFyYW0oc3RydWN0IFNjc2lfSG9zdCAqLCBlbnVtIGlzY3NpX2hvc3RfcGFy
YW0sIGNoYXIgKik7CiBzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKmN4Z2JpX2VwX2Nvbm5lY3Qoc3Ry
dWN0IFNjc2lfSG9zdCAqLAotCQkJc3RydWN0IHNvY2thZGRyICosIGludCk7CisJCQlzdHJ1Y3Qg
c29ja2FkZHJfc3RvcmFnZSAqLCBpbnQsIHN0cnVjdCBpZmFjZV9yZWMgKik7CiBpbnQgY3hnYmlf
ZXBfcG9sbChzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKiwgaW50KTsKIHZvaWQgY3hnYmlfZXBfZGlz
Y29ubmVjdChzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKik7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9xbGE0eHh4L3FsNF9vcy5jIGIvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X29zLmMKaW5k
ZXggNjRjNmZhNS4uNGZjY2I1OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0
X29zLmMKKysrIGIvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X29zLmMKQEAgLTExOSw4ICsxMTks
OSBAQCBzdGF0aWMgaW50IHFsYTR4eHhfZ2V0X2lmYWNlX3BhcmFtKHN0cnVjdCBpc2NzaV9pZmFj
ZSAqaWZhY2UsCiAJCQkJICAgaW50IHBhcmFtLCBjaGFyICpidWYpOwogc3RhdGljIGVudW0gYmxr
X2VoX3RpbWVyX3JldHVybiBxbGE0eHh4X2VoX2NtZF90aW1lZF9vdXQoc3RydWN0IHNjc2lfY21u
ZCAqc2MpOwogc3RhdGljIHN0cnVjdCBpc2NzaV9lbmRwb2ludCAqcWxhNHh4eF9lcF9jb25uZWN0
KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LAotCQkJCQkJIHN0cnVjdCBzb2NrYWRkciAqZHN0X2Fk
ZHIsCi0JCQkJCQkgaW50IG5vbl9ibG9ja2luZyk7CisJCQkJCQkgc3RydWN0IHNvY2thZGRyX3N0
b3JhZ2UgKmRzdF9hZGRyLAorCQkJCQkJIGludCBub25fYmxvY2tpbmcsCisJCQkJCQkgc3RydWN0
IGlmYWNlX3JlYyAqaWZhY2UpOwogc3RhdGljIGludCBxbGE0eHh4X2VwX3BvbGwoc3RydWN0IGlz
Y3NpX2VuZHBvaW50ICplcCwgaW50IHRpbWVvdXRfbXMpOwogc3RhdGljIHZvaWQgcWxhNHh4eF9l
cF9kaXNjb25uZWN0KHN0cnVjdCBpc2NzaV9lbmRwb2ludCAqZXApOwogc3RhdGljIGludCBxbGE0
eHh4X2dldF9lcF9wYXJhbShzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKmVwLApAQCAtMTY1Niw4ICsx
NjU3LDggQEAgc3RhdGljIGludCBxbGE0eHh4X2dldF9pZmFjZV9wYXJhbShzdHJ1Y3QgaXNjc2lf
aWZhY2UgKmlmYWNlLAogfQogCiBzdGF0aWMgc3RydWN0IGlzY3NpX2VuZHBvaW50ICoKLXFsYTR4
eHhfZXBfY29ubmVjdChzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwgc3RydWN0IHNvY2thZGRyICpk
c3RfYWRkciwKLQkJICAgaW50IG5vbl9ibG9ja2luZykKK3FsYTR4eHhfZXBfY29ubmVjdChzdHJ1
Y3QgU2NzaV9Ib3N0ICpzaG9zdCwgc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UgKmRzdF9hZGRyLAor
CQkgICBpbnQgbm9uX2Jsb2NraW5nLCBzdHJ1Y3QgaWZhY2VfcmVjICppZmFjZSkKIHsKIAlpbnQg
cmV0OwogCXN0cnVjdCBpc2NzaV9lbmRwb2ludCAqZXA7CkBAIC0xNjgxLDEyICsxNjgyLDEyIEBA
IHN0YXRpYyBpbnQgcWxhNHh4eF9nZXRfaWZhY2VfcGFyYW0oc3RydWN0IGlzY3NpX2lmYWNlICpp
ZmFjZSwKIAogCXFsYV9lcCA9IGVwLT5kZF9kYXRhOwogCW1lbXNldChxbGFfZXAsIDAsIHNpemVv
ZihzdHJ1Y3QgcWxhX2VuZHBvaW50KSk7Ci0JaWYgKGRzdF9hZGRyLT5zYV9mYW1pbHkgPT0gQUZf
SU5FVCkgeworCWlmIChkc3RfYWRkci0+c3NfZmFtaWx5ID09IEFGX0lORVQpIHsKIAkJbWVtY3B5
KCZxbGFfZXAtPmRzdF9hZGRyLCBkc3RfYWRkciwgc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9pbikp
OwogCQlhZGRyID0gKHN0cnVjdCBzb2NrYWRkcl9pbiAqKSZxbGFfZXAtPmRzdF9hZGRyOwogCQlE
RUJVRzIocWw0X3ByaW50ayhLRVJOX0lORk8sIGhhLCAiJXM6ICVwSTRcbiIsIF9fZnVuY19fLAog
CQkJCSAgKGNoYXIgKikmYWRkci0+c2luX2FkZHIpKTsKLQl9IGVsc2UgaWYgKGRzdF9hZGRyLT5z
YV9mYW1pbHkgPT0gQUZfSU5FVDYpIHsKKwl9IGVsc2UgaWYgKGRzdF9hZGRyLT5zc19mYW1pbHkg
PT0gQUZfSU5FVDYpIHsKIAkJbWVtY3B5KCZxbGFfZXAtPmRzdF9hZGRyLCBkc3RfYWRkciwKIAkJ
ICAgICAgIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW42KSk7CiAJCWFkZHI2ID0gKHN0cnVjdCBz
b2NrYWRkcl9pbjYgKikmcWxhX2VwLT5kc3RfYWRkcjsKQEAgLTY1NjksNyArNjU3MCw3IEBAIHN0
YXRpYyBzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKnFsYTR4eHhfZ2V0X2VwX2Z3ZGIoc3RydWN0IHNj
c2lfcWxhX2hvc3QgKmhhLAogCQlhZGRyLT5zaW5fcG9ydCA9IGh0b25zKGxlMTZfdG9fY3B1KGZ3
X2RkYl9lbnRyeS0+cG9ydCkpOwogCX0KIAotCWVwID0gcWxhNHh4eF9lcF9jb25uZWN0KGhhLT5o
b3N0LCAoc3RydWN0IHNvY2thZGRyICopZHN0X2FkZHIsIDApOworCWVwID0gcWxhNHh4eF9lcF9j
b25uZWN0KGhhLT5ob3N0LCBkc3RfYWRkciwgMCwgTlVMTCk7CiAJdmZyZWUoZHN0X2FkZHIpOwog
CXJldHVybiBlcDsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9p
c2NzaS5jIGIvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMKaW5kZXggYTQyNGVh
ZS4uNjQxNTdhMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3Np
LmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMKQEAgLTM0LDYgKzM0
LDcgQEAKICNpbmNsdWRlIDxzY3NpL2lzY3NpX2lmLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3NpX2Nt
bmQuaD4KICNpbmNsdWRlIDxzY3NpL3Njc2lfYnNnX2lzY3NpLmg+CisjaW5jbHVkZSA8bGludXgv
aW5ldC5oPgogCiAjZGVmaW5lIElTQ1NJX1RSQU5TUE9SVF9WRVJTSU9OICIyLjAtODcwIgogCkBA
IC0yNzk0LDcgKzI3OTUsOCBAQCBzdGF0aWMgaW50IGlzY3NpX2lmX2VwX2Nvbm5lY3Qoc3RydWN0
IGlzY3NpX3RyYW5zcG9ydCAqdHJhbnNwb3J0LAogCQkJICAgICAgIHN0cnVjdCBpc2NzaV91ZXZl
bnQgKmV2LCBpbnQgbXNnX3R5cGUpCiB7CiAJc3RydWN0IGlzY3NpX2VuZHBvaW50ICplcDsKLQlz
dHJ1Y3Qgc29ja2FkZHIgKmRzdF9hZGRyOworCXN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlICpkc3Rf
YWRkcjsKKwlzdHJ1Y3QgaWZhY2VfcmVjICppZmFjZTsKIAlzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9z
dCA9IE5VTEw7CiAJaW50IG5vbl9ibG9ja2luZywgZXJyID0gMDsKIApAQCAtMjgxMyw4ICsyODE1
LDkgQEAgc3RhdGljIGludCBpc2NzaV9pZl9lcF9jb25uZWN0KHN0cnVjdCBpc2NzaV90cmFuc3Bv
cnQgKnRyYW5zcG9ydCwKIAl9IGVsc2UKIAkJbm9uX2Jsb2NraW5nID0gZXYtPnUuZXBfY29ubmVj
dC5ub25fYmxvY2tpbmc7CiAKLQlkc3RfYWRkciA9IChzdHJ1Y3Qgc29ja2FkZHIgKikoKGNoYXIq
KWV2ICsgc2l6ZW9mKCpldikpOwotCWVwID0gdHJhbnNwb3J0LT5lcF9jb25uZWN0KHNob3N0LCBk
c3RfYWRkciwgbm9uX2Jsb2NraW5nKTsKKwlkc3RfYWRkciA9IChzdHJ1Y3Qgc29ja2FkZHJfc3Rv
cmFnZSAqKSgoY2hhciopZXYgKyBzaXplb2YoKmV2KSk7CisJaWZhY2UgPSAoc3RydWN0IGlmYWNl
X3JlYyAqKSgoY2hhciopZXYgKyBzaXplb2YoKmV2KSArIHNpemVvZigqZHN0X2FkZHIpKTsKKwll
cCA9IHRyYW5zcG9ydC0+ZXBfY29ubmVjdChzaG9zdCwgZHN0X2FkZHIsIG5vbl9ibG9ja2luZywg
aWZhY2UpOwogCWlmIChJU19FUlIoZXApKSB7CiAJCWVyciA9IFBUUl9FUlIoZXApOwogCQlnb3Rv
IHJlbGVhc2VfaG9zdDsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9ydF9p
c2NzaS5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmgKaW5kZXggNjE4M2Qy
MC4uYzE0NmU5MCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3Np
LmgKKysrIGIvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmgKQEAgLTM3LDYgKzM3
LDcgQEAKIHN0cnVjdCBpc2NzaV9jb25uOwogc3RydWN0IGlzY3NpX3Rhc2s7CiBzdHJ1Y3Qgc29j
a2FkZHI7CitzdHJ1Y3QgaWZhY2VfcmVjOwogc3RydWN0IGlzY3NpX2lmYWNlOwogc3RydWN0IGJz
Z19qb2I7CiBzdHJ1Y3QgaXNjc2lfYnVzX2ZsYXNoX3Nlc3Npb247CkBAIC0xMzIsOCArMTMzLDkg
QEAgc3RydWN0IGlzY3NpX3RyYW5zcG9ydCB7CiAKIAl2b2lkICgqc2Vzc2lvbl9yZWNvdmVyeV90
aW1lZG91dCkgKHN0cnVjdCBpc2NzaV9jbHNfc2Vzc2lvbiAqc2Vzc2lvbik7CiAJc3RydWN0IGlz
Y3NpX2VuZHBvaW50ICooKmVwX2Nvbm5lY3QpIChzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwKLQkJ
CQkJICAgICAgc3RydWN0IHNvY2thZGRyICpkc3RfYWRkciwKLQkJCQkJICAgICAgaW50IG5vbl9i
bG9ja2luZyk7CisJCQkJCSAgICAgIHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlICpkc3RfYWRkciwK
KwkJCQkJICAgICAgaW50IG5vbl9ibG9ja2luZywKKwkJCQkJICAgICAgc3RydWN0IGlmYWNlX3Jl
YyAqaWZhY2UpOwogCWludCAoKmVwX3BvbGwpIChzdHJ1Y3QgaXNjc2lfZW5kcG9pbnQgKmVwLCBp
bnQgdGltZW91dF9tcyk7CiAJdm9pZCAoKmVwX2Rpc2Nvbm5lY3QpIChzdHJ1Y3QgaXNjc2lfZW5k
cG9pbnQgKmVwKTsKIAlpbnQgKCp0Z3RfZHNjdnIpIChzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwg
ZW51bSBpc2NzaV90Z3RfZHNjdnIgdHlwZSwKQEAgLTI5MSw2ICsyOTMsMTAwIEBAIHN0cnVjdCBp
c2NzaV9lbmRwb2ludCB7CiAJc3RydWN0IGlzY3NpX2Nsc19jb25uICpjb25uOwogfTsKIAorLyog
bWF4IGxlbiBvZiBpbnRlcmZhY2UgKi8KKyNkZWZpbmUgSVNDU0lfTUFYX0lGQUNFX0xFTgk2NQor
I2RlZmluZSBOSV9NQVhIT1NUIDEwMjUKKyNkZWZpbmUgSVNDU0lfSFdBRERSRVNTX0JVRl9TSVpF
IDE4CisjZGVmaW5lIElTQ1NJX1RSQU5TUE9SVF9OQU1FX01BWExFTiAxNgorI2RlZmluZSBJU0NT
SV9NQVhfU1RSX0xFTiA4MAorCitzdHJ1Y3QgaWZhY2VfcmVjIHsKKwlzdHJ1Y3QgbGlzdF9oZWFk
CWxpc3Q7CisJLyogaXNjc2kgaWZhY2UgcmVjb3JkIG5hbWUgKi8KKwljaGFyCQkJbmFtZVtJU0NT
SV9NQVhfSUZBQ0VfTEVOXTsKKwl1aW50MzJfdAkJaWZhY2VfbnVtOworCS8qIG5ldHdvcmsgbGF5
ZXIgaWZhY2UgbmFtZSAoZXRoMCkgKi8KKwljaGFyCQkJbmV0ZGV2W0lGTkFNU0laXTsKKwljaGFy
CQkJaXBhZGRyZXNzW05JX01BWEhPU1RdOworCWNoYXIJCQlzdWJuZXRfbWFza1tOSV9NQVhIT1NU
XTsKKwljaGFyCQkJZ2F0ZXdheVtOSV9NQVhIT1NUXTsKKwljaGFyCQkJYm9vdHByb3RvW0lTQ1NJ
X01BWF9TVFJfTEVOXTsKKwljaGFyCQkJaXB2Nl9saW5rbG9jYWxbTklfTUFYSE9TVF07CisJY2hh
cgkJCWlwdjZfcm91dGVyW05JX01BWEhPU1RdOworCWNoYXIJCQlpcHY2X2F1dG9jZmdbTklfTUFY
SE9TVF07CisJY2hhcgkJCWxpbmtsb2NhbF9hdXRvY2ZnW05JX01BWEhPU1RdOworCWNoYXIJCQly
b3V0ZXJfYXV0b2NmZ1tOSV9NQVhIT1NUXTsKKwl1aW50MTZfdAkJdmxhbl9pZDsKKwl1aW50OF90
CQkJdmxhbl9wcmlvcml0eTsKKwljaGFyCQkJdmxhbl9zdGF0ZVtJU0NTSV9NQVhfU1RSX0xFTl07
CisJY2hhcgkJCXN0YXRlW0lTQ1NJX01BWF9TVFJfTEVOXTsgLyogMCA9IGRpc2FibGUsCisJCQkJ
CQkJICAgKiAxID0gZW5hYmxlICovCisJdWludDE2X3QJCW10dTsKKwl1aW50MTZfdAkJcG9ydDsK
KwljaGFyCQkJZGVsYXllZF9hY2tbSVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJCQluYWdsZVtJ
U0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCXRjcF93c2Zfc3RhdGVbSVNDU0lfTUFYX1NUUl9M
RU5dOworCXVpbnQ4X3QJCQl0Y3Bfd3NmOworCXVpbnQ4X3QJCQl0Y3BfdGltZXJfc2NhbGU7CisJ
Y2hhcgkJCXRjcF90aW1lc3RhbXBbSVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJCQlkaGNwX2Ru
c1tJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRoY3Bfc2xwX2RhW0lTQ1NJX01BWF9TVFJf
TEVOXTsKKwljaGFyCQkJdG9zX3N0YXRlW0lTQ1NJX01BWF9TVFJfTEVOXTsKKwl1aW50OF90CQkJ
dG9zOworCWNoYXIJCQlncmF0dWl0b3VzX2FycFtJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJ
CWRoY3BfYWx0X2NsaWVudF9pZF9zdGF0ZVtJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRo
Y3BfYWx0X2NsaWVudF9pZFtJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRoY3BfcmVxX3Zl
bmRvcl9pZF9zdGF0ZVtJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRoY3BfdmVuZG9yX2lk
X3N0YXRlW0lTQ1NJX01BWF9TVFJfTEVOXTsKKwljaGFyCQkJZGhjcF92ZW5kb3JfaWRbSVNDU0lf
TUFYX1NUUl9MRU5dOworCWNoYXIJCQlkaGNwX2xlYXJuX2lxbltJU0NTSV9NQVhfU1RSX0xFTl07
CisJY2hhcgkJCWZyYWdtZW50YXRpb25bSVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJCQlpbmNv
bWluZ19mb3J3YXJkaW5nW0lTQ1NJX01BWF9TVFJfTEVOXTsKKwl1aW50OF90CQkJdHRsOworCWNo
YXIJCQlncmF0dWl0b3VzX25laWdoYm9yX2FkdltJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJ
CXJlZGlyZWN0W0lTQ1NJX01BWF9TVFJfTEVOXTsKKwljaGFyCQkJbWxkW0lTQ1NJX01BWF9TVFJf
TEVOXTsKKwl1aW50MzJfdAkJZmxvd19sYWJlbDsKKwl1aW50MzJfdAkJdHJhZmZpY19jbGFzczsK
Kwl1aW50OF90CQkJaG9wX2xpbWl0OworCXVpbnQzMl90CQluZF9yZWFjaGFibGVfdG1vOworCXVp
bnQzMl90CQluZF9yZXhtaXRfdGltZTsKKwl1aW50MzJfdAkJbmRfc3RhbGVfdG1vOworCXVpbnQ4
X3QJCQlkdXBfYWRkcl9kZXRlY3RfY250OworCXVpbnQzMl90CQlyb3V0ZXJfYWR2X2xpbmtfbXR1
OworCXVpbnQxNl90CQlkZWZfdGFza19tZ210X3RtbzsKKwljaGFyCQkJaGVhZGVyX2RpZ2VzdFtJ
U0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRhdGFfZGlnZXN0W0lTQ1NJX01BWF9TVFJfTEVO
XTsKKwljaGFyCQkJaW1tZWRpYXRlX2RhdGFbSVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJCQlp
bml0aWFsX3IydFtJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRhdGFfc2VxX2lub3JkZXJb
SVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJCQlkYXRhX3BkdV9pbm9yZGVyW0lTQ1NJX01BWF9T
VFJfTEVOXTsKKwl1aW50OF90CQkJZXJsOworCXVpbnQzMl90CQltYXhfcmVjdl9kbGVuZ3RoOwor
CXVpbnQzMl90CQlmaXJzdF9idXJzdF9sZW47CisJdWludDE2X3QJCW1heF9vdXRfcjJ0OworCXVp
bnQzMl90CQltYXhfYnVyc3RfbGVuOworCWNoYXIJCQljaGFwX2F1dGhbSVNDU0lfTUFYX1NUUl9M
RU5dOworCWNoYXIJCQliaWRpX2NoYXBbSVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJCQlzdHJp
Y3RfbG9naW5fY29tcFtJU0NTSV9NQVhfU1RSX0xFTl07CisJY2hhcgkJCWRpc2NvdmVyeV9hdXRo
W0lTQ1NJX01BWF9TVFJfTEVOXTsKKwljaGFyCQkJZGlzY292ZXJ5X2xvZ291dFtJU0NTSV9NQVhf
U1RSX0xFTl07CisJY2hhcgkJCXBvcnRfc3RhdGVbSVNDU0lfTUFYX1NUUl9MRU5dOworCWNoYXIJ
CQlwb3J0X3NwZWVkW0lTQ1NJX01BWF9TVFJfTEVOXTsKKwkvKgorCSAqIFRPRE86IHdlIG1heSBo
YXZlIHRvIG1ha2UgdGhpcyBiaWdnZXIgYW5kIGludGVyY29ubmVjdAorCSAqIHNwZWNpZmljIGZv
ciBpbmZpbmliYW5kCisJICovCisJY2hhcgkJCWh3YWRkcmVzc1tJU0NTSV9IV0FERFJFU1NfQlVG
X1NJWkVdOworCWNoYXIJCQl0cmFuc3BvcnRfbmFtZVtJU0NTSV9UUkFOU1BPUlRfTkFNRV9NQVhM
RU5dOworCS8qCisJICogVGhpcyBpcyBvbmx5IHVzZWQgZm9yIGJvb3Qgbm93LCBidXQgdGhlIGlz
ZXIgZ3V5cworCSAqIGNhbiB1c2UgdGhpcyBmb3IgdGhlaXIgdmlydHVhbGl6YXRpb24gaWRlYS4K
KwkgKi8KKwljaGFyCQkJYWxpYXNbVEFSR0VUX05BTUVfTUFYTEVOICsgMV07CisJY2hhcgkJCWlu
YW1lW1RBUkdFVF9OQU1FX01BWExFTiArIDFdOworfTsKKwogc3RydWN0IGlzY3NpX2lmYWNlIHsK
IAlzdHJ1Y3QgZGV2aWNlIGRldjsKIAlzdHJ1Y3QgaXNjc2lfdHJhbnNwb3J0ICp0cmFuc3BvcnQ7
Cg==
--94eb2c191f66b99c9b0551000175
Content-Type: text/x-patch; charset="US-ASCII"; name="iscsi_binding.patch"
Content-Disposition: attachment; filename="iscsi_binding.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j3gayvsh1

ZGlmZiAtLWdpdCBhL3Vzci9uZXRsaW5rLmMgYi91c3IvbmV0bGluay5jCmluZGV4IDFhMGJmODAu
LmM0NzQzNzUgMTAwNjQ0Ci0tLSBhL3Vzci9uZXRsaW5rLmMKKysrIGIvdXNyL25ldGxpbmsuYwpA
QCAtODQ4LDEwICs4NDgsMTMgQEAga3JlY3ZfcGR1X2VuZChzdHJ1Y3QgaXNjc2lfY29ubiAqY29u
bikKIGludAoga3RyYW5zcG9ydF9lcF9jb25uZWN0KGlzY3NpX2Nvbm5fdCAqY29ubiwgaW50IG5v
bl9ibG9ja2luZykKIHsKLQlpbnQgcmMsIGFkZHJsZW47CisJaW50IHJjLCBhZGRybGVuID0gc2l6
ZW9mKHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlKTsKIAlzdHJ1Y3QgaXNjc2lfdWV2ZW50ICpldjsK
LQlzdHJ1Y3Qgc29ja2FkZHIgKmRzdF9hZGRyID0gKHN0cnVjdCBzb2NrYWRkciAqKSZjb25uLT5z
YWRkcjsKKwlzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSAqZHN0X2FkZHIgPSAoc3RydWN0IHNvY2th
ZGRyX3N0b3JhZ2UgKikmY29ubi0+c2FkZHI7CiAJc3RydWN0IGlvdmVjIGlvdlsyXTsKKwlzdHJ1
Y3QgaXNjc2lfc2Vzc2lvbiAqdG1wX3Nlc3Npb24gPSAoc3RydWN0IGlzY3NpX3Nlc3Npb24gKilj
b25uLT5zZXNzaW9uOworCW5vZGVfcmVjX3QgKnRtcF9yZWMgPSAobm9kZV9yZWNfdCAqKSZ0bXBf
c2Vzc2lvbi0+bnJlYzsKKwlpZmFjZV9yZWNfdCAqdG1wX2lmYWNlID0gKGlmYWNlX3JlY190ICop
JnRtcF9yZWMtPmlmYWNlOwogCiAJbG9nX2RlYnVnKDcsICJpbiAlcyIsIF9fRlVOQ1RJT05fXyk7
CiAKQEAgLTg2OCwxOSArODcxLDE2IEBAIGt0cmFuc3BvcnRfZXBfY29ubmVjdChpc2NzaV9jb25u
X3QgKmNvbm4sIGludCBub25fYmxvY2tpbmcpCiAJCWV2LT51LmVwX2Nvbm5lY3Qubm9uX2Jsb2Nr
aW5nID0gbm9uX2Jsb2NraW5nOwogCX0KIAotCWlmIChkc3RfYWRkci0+c2FfZmFtaWx5ID09IFBG
X0lORVQpCi0JCWFkZHJsZW4gPSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX2luKTsKLQllbHNlIGlm
IChkc3RfYWRkci0+c2FfZmFtaWx5ID09IFBGX0lORVQ2KQotCQlhZGRybGVuID0gc2l6ZW9mKHN0
cnVjdCBzb2NrYWRkcl9pbjYpOwotCWVsc2UgeworCWlmIChkc3RfYWRkci0+c3NfZmFtaWx5ICE9
IEFGX0lORVQgJiYgZHN0X2FkZHItPnNzX2ZhbWlseSAhPSBBRl9JTkVUNikgewogCQlsb2dfZXJy
b3IoIiVzIHVua25vd24gYWRkciBmYW1pbHkgJWQiLAotCQkJIF9fRlVOQ1RJT05fXywgZHN0X2Fk
ZHItPnNhX2ZhbWlseSk7CisJCQkgX19GVU5DVElPTl9fLCBkc3RfYWRkci0+c3NfZmFtaWx5KTsK
IAkJcmV0dXJuIC1FSU5WQUw7CiAJfQogCW1lbWNweShzZXRwYXJhbV9idWYgKyBzaXplb2YoKmV2
KSwgZHN0X2FkZHIsIGFkZHJsZW4pOworCWlmYWNlX2NvcHkoc2V0cGFyYW1fYnVmICsgc2l6ZW9m
KCpldikgKyBhZGRybGVuLCB0bXBfaWZhY2UpOwogCiAJaW92WzFdLmlvdl9iYXNlID0gZXY7Ci0J
aW92WzFdLmlvdl9sZW4gPSBzaXplb2YoKmV2KSArIGFkZHJsZW47CisJaW92WzFdLmlvdl9sZW4g
PSBzaXplb2YoKmV2KSArIGFkZHJsZW4gKyBzaXplb2YoaWZhY2VfcmVjX3QpOwogCXJjID0gX19r
aXBjX2NhbGwoaW92LCAyKTsKIAlpZiAocmMgPCAwKQogCQlyZXR1cm4gcmM7Cg==
--94eb2c191f66b99c9b0551000175--
