From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 02/10] Remove uses of htonll
Date: Sun, 12 Feb 2017 08:26:17 +0000
Message-ID: <SN1PR07MB22077D2262770CF1B62A13B7F8460@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1486677212-3188-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>=20
> Done via
>=20
> $ git ls-files | xargs sed -i -e 's/htonll/htobe64/g'
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/include/acm_mad.h       | 84 +++++++++++++++++++++----------------=
------
>  ibacm/prov/acmp/src/acmp.c    | 10 +++---
>  ibacm/src/acm.c               |  6 ++--
>  providers/cxgb3/cxio_wr.h     |  2 +-
>  providers/cxgb3/qp.c          | 12 +++----
>  providers/cxgb4/t4.h          |  2 +-
>  providers/mlx4/qp.c           | 12 +++----
>  providers/mlx4/srq.c          |  2 +-
>  providers/mlx5/qp.c           | 24 ++++++-------
>  providers/mlx5/srq.c          |  2 +-
>  providers/mthca/qp.c          | 34 +++++++++---------
>  providers/mthca/srq.c         |  4 +--
>  providers/qedr/qelr_verbs.c   |  2 +-
>  srp_daemon/srp_daemon.c       | 16 ++++-----
>  srp_daemon/srp_handle_traps.c |  4 +--
>  15 files changed, 108 insertions(+), 108 deletions(-)
>=20
> diff --git a/ibacm/include/acm_mad.h b/ibacm/include/acm_mad.h
> index 68e231bc6680ca..f237ef6fde563c 100644
> --- a/ibacm/include/acm_mad.h
> +++ b/ibacm/include/acm_mad.h
> @@ -121,52 +121,52 @@ struct ib_sa_mad {
>=20
>  #define IB_SA_ATTR_PATH_REC htons(0x0035)
>=20
> -#define IB_COMP_MASK_PR_SERVICE_ID         (htonll(1 << 0) | \
> -                                            htonll(1 << 1))
> -#define IB_COMP_MASK_PR_DGID                htonll(1 << 2)
> -#define IB_COMP_MASK_PR_SGID                htonll(1 << 3)
> -#define IB_COMP_MASK_PR_DLID                htonll(1 << 4)
> -#define IB_COMP_MASK_PR_SLID                htonll(1 << 5)
> -#define IB_COMP_MASK_PR_RAW_TRAFFIC         htonll(1 << 6)
> -/* RESERVED                                 htonll(1 << 7) */
> -#define IB_COMP_MASK_PR_FLOW_LABEL          htonll(1 << 8)
> -#define IB_COMP_MASK_PR_HOP_LIMIT           htonll(1 << 9)
> -#define IB_COMP_MASK_PR_TCLASS              htonll(1 << 10)
> -#define IB_COMP_MASK_PR_REVERSIBLE          htonll(1 << 11)
> -#define IB_COMP_MASK_PR_NUM_PATH            htonll(1 << 12)
> -#define IB_COMP_MASK_PR_PKEY                htonll(1 << 13)
> -#define IB_COMP_MASK_PR_QOS_CLASS           htonll(1 << 14)
> -#define IB_COMP_MASK_PR_SL                  htonll(1 << 15)
> -#define IB_COMP_MASK_PR_MTU_SELECTOR        htonll(1 << 16)
> -#define IB_COMP_MASK_PR_MTU                 htonll(1 << 17)
> -#define IB_COMP_MASK_PR_RATE_SELECTOR       htonll(1 << 18)
> -#define IB_COMP_MASK_PR_RATE                htonll(1 << 19)
> -#define IB_COMP_MASK_PR_PACKET_LIFETIME_SELECTOR htonll(1 << 20)
> -#define IB_COMP_MASK_PR_PACKET_LIFETIME     htonll(1 << 21)
> -#define IB_COMP_MASK_PR_PREFERENCE          htonll(1 << 22)
> -/* RESERVED                                 htonll(1 << 23) */
> +#define IB_COMP_MASK_PR_SERVICE_ID         (htobe64(1 << 0) | \
> +                                            htobe64(1 << 1))
> +#define IB_COMP_MASK_PR_DGID                htobe64(1 << 2)
> +#define IB_COMP_MASK_PR_SGID                htobe64(1 << 3)
> +#define IB_COMP_MASK_PR_DLID                htobe64(1 << 4)
> +#define IB_COMP_MASK_PR_SLID                htobe64(1 << 5)
> +#define IB_COMP_MASK_PR_RAW_TRAFFIC         htobe64(1 << 6)
> +/* RESERVED                                 htobe64(1 << 7) */
> +#define IB_COMP_MASK_PR_FLOW_LABEL          htobe64(1 << 8)
> +#define IB_COMP_MASK_PR_HOP_LIMIT           htobe64(1 << 9)
> +#define IB_COMP_MASK_PR_TCLASS              htobe64(1 << 10)
> +#define IB_COMP_MASK_PR_REVERSIBLE          htobe64(1 << 11)
> +#define IB_COMP_MASK_PR_NUM_PATH            htobe64(1 << 12)
> +#define IB_COMP_MASK_PR_PKEY                htobe64(1 << 13)
> +#define IB_COMP_MASK_PR_QOS_CLASS           htobe64(1 << 14)
> +#define IB_COMP_MASK_PR_SL                  htobe64(1 << 15)
> +#define IB_COMP_MASK_PR_MTU_SELECTOR        htobe64(1 << 16)
> +#define IB_COMP_MASK_PR_MTU                 htobe64(1 << 17)
> +#define IB_COMP_MASK_PR_RATE_SELECTOR       htobe64(1 << 18)
> +#define IB_COMP_MASK_PR_RATE                htobe64(1 << 19)
> +#define IB_COMP_MASK_PR_PACKET_LIFETIME_SELECTOR htobe64(1 << 20)
> +#define IB_COMP_MASK_PR_PACKET_LIFETIME     htobe64(1 << 21)
> +#define IB_COMP_MASK_PR_PREFERENCE          htobe64(1 << 22)
> +/* RESERVED                                 htobe64(1 << 23) */
>=20
>  #define IB_MC_QPN 0xffffff
>  #define IB_SA_ATTR_MC_MEMBER_REC htons(0x0038)
>=20
> -#define IB_COMP_MASK_MC_MGID                htonll(1 << 0)
> -#define IB_COMP_MASK_MC_PORT_GID            htonll(1 << 1)
> -#define IB_COMP_MASK_MC_QKEY                htonll(1 << 2)
> -#define IB_COMP_MASK_MC_MLID                htonll(1 << 3)
> -#define IB_COMP_MASK_MC_MTU_SEL             htonll(1 << 4)
> -#define IB_COMP_MASK_MC_MTU                 htonll(1 << 5)
> -#define IB_COMP_MASK_MC_TCLASS              htonll(1 << 6)
> -#define IB_COMP_MASK_MC_PKEY                htonll(1 << 7)
> -#define IB_COMP_MASK_MC_RATE_SEL            htonll(1 << 8)
> -#define IB_COMP_MASK_MC_RATE                htonll(1 << 9)
> -#define IB_COMP_MASK_MC_PACKET_LIFETIME_SEL htonll(1 << 10)
> -#define IB_COMP_MASK_MC_PACKET_LIFETIME     htonll(1 << 11)
> -#define IB_COMP_MASK_MC_SL                  htonll(1 << 12)
> -#define IB_COMP_MASK_MC_FLOW                htonll(1 << 13)
> -#define IB_COMP_MASK_MC_HOP                 htonll(1 << 14)
> -#define IB_COMP_MASK_MC_SCOPE               htonll(1 << 15)
> -#define IB_COMP_MASK_MC_JOIN_STATE          htonll(1 << 16)
> -#define IB_COMP_MASK_MC_PROXY_JOIN          htonll(1 << 17)
> +#define IB_COMP_MASK_MC_MGID                htobe64(1 << 0)
> +#define IB_COMP_MASK_MC_PORT_GID            htobe64(1 << 1)
> +#define IB_COMP_MASK_MC_QKEY                htobe64(1 << 2)
> +#define IB_COMP_MASK_MC_MLID                htobe64(1 << 3)
> +#define IB_COMP_MASK_MC_MTU_SEL             htobe64(1 << 4)
> +#define IB_COMP_MASK_MC_MTU                 htobe64(1 << 5)
> +#define IB_COMP_MASK_MC_TCLASS              htobe64(1 << 6)
> +#define IB_COMP_MASK_MC_PKEY                htobe64(1 << 7)
> +#define IB_COMP_MASK_MC_RATE_SEL            htobe64(1 << 8)
> +#define IB_COMP_MASK_MC_RATE                htobe64(1 << 9)
> +#define IB_COMP_MASK_MC_PACKET_LIFETIME_SEL htobe64(1 << 10)
> +#define IB_COMP_MASK_MC_PACKET_LIFETIME     htobe64(1 << 11)
> +#define IB_COMP_MASK_MC_SL                  htobe64(1 << 12)
> +#define IB_COMP_MASK_MC_FLOW                htobe64(1 << 13)
> +#define IB_COMP_MASK_MC_HOP                 htobe64(1 << 14)
> +#define IB_COMP_MASK_MC_SCOPE               htobe64(1 << 15)
> +#define IB_COMP_MASK_MC_JOIN_STATE          htobe64(1 << 16)
> +#define IB_COMP_MASK_MC_PROXY_JOIN          htobe64(1 << 17)
>=20
>  struct ib_mc_member_rec {
>  	union ibv_gid mgid;
> diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
> index fb6684f2eac1f5..6b7cbb8c203478 100644
> --- a/ibacm/prov/acmp/src/acmp.c
> +++ b/ibacm/prov/acmp/src/acmp.c
> @@ -780,7 +780,7 @@ static void acmp_init_path_query(struct ib_sa_mad *ma=
d)
>  	mad->mgmt_class =3D IB_MGMT_CLASS_SA;
>  	mad->class_version =3D 2;
>  	mad->method =3D IB_METHOD_GET;
> -	mad->tid =3D htonll((uint64_t) atomic_inc(&g_tid));
> +	mad->tid =3D htobe64((uint64_t) atomic_inc(&g_tid));
>  	mad->attr_id =3D IB_SA_ATTR_PATH_REC;
>  }
>=20
> @@ -1367,7 +1367,7 @@ static void acmp_init_join(struct ib_sa_mad *mad, u=
nion ibv_gid *port_gid,
>  	mad->mgmt_class =3D IB_MGMT_CLASS_SA;
>  	mad->class_version =3D 2;
>  	mad->method =3D IB_METHOD_SET;
> -	mad->tid =3D htonll((uint64_t) atomic_inc(&g_tid));
> +	mad->tid =3D htobe64((uint64_t) atomic_inc(&g_tid));
>  	mad->attr_id =3D IB_SA_ATTR_MC_MEMBER_REC;
>  	mad->comp_mask =3D
>  		IB_COMP_MASK_MC_MGID | IB_COMP_MASK_MC_PORT_GID |
> @@ -1673,7 +1673,7 @@ acmp_send_resolve(struct acmp_ep *ep, struct acmp_d=
est *dest,
>  	mad->class_version =3D 1;
>  	mad->method =3D IB_METHOD_GET;
>  	mad->control =3D ACM_CTRL_RESOLVE;
> -	mad->tid =3D htonll((uint64_t) atomic_inc(&g_tid));
> +	mad->tid =3D htobe64((uint64_t) atomic_inc(&g_tid));
>=20
>  	rec =3D (struct acm_resolve_rec *) mad->data;
>  	rec->src_type =3D (uint8_t) saddr->type;
> @@ -1957,7 +1957,7 @@ static void acmp_query_perf(void *ep_context, uint6=
4_t *values, uint8_t *cnt)
>  	int i;
>=20
>  	for (i =3D 0; i < ACM_MAX_COUNTER; i++)
> -		values[i] =3D htonll((uint64_t) atomic_get(&ep->counters[i]));
> +		values[i] =3D htobe64((uint64_t) atomic_get(&ep->counters[i]));
>  	*cnt =3D ACM_MAX_COUNTER;
>  }
>=20
> @@ -2082,7 +2082,7 @@ static void acmp_parse_osm_fullv1_lid2guid(FILE *f,=
 uint64_t *lid2guid)
>  		if (lid2guid[lid])
>  			acm_log(0, "ERROR - duplicate lid %u\n", lid);
>  		else
> -			lid2guid[lid] =3D htonll(guid);
> +			lid2guid[lid] =3D htobe64(guid);
>  	}
>  }
>=20
> diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
> index fd06a2e81fbe76..2cf1ea8b2148c0 100644
> --- a/ibacm/src/acm.c
> +++ b/ibacm/src/acm.c
> @@ -1000,7 +1000,7 @@ static int acm_svr_perf_query(struct acmc_client *c=
lient, struct acm_msg *msg)
>  	    ((ntohs(msg->hdr.length) >=3D (ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENG=
TH)
>  	    && !(msg->resolve_data[0].flags & ACM_EP_FLAG_SOURCE)))) {
>  		for (i =3D 0; i < ACM_MAX_COUNTER; i++)
> -			msg->perf_data[i] =3D htonll((uint64_t) atomic_get(&counter[i]));
> +			msg->perf_data[i] =3D htobe64((uint64_t) atomic_get(&counter[i]));
>=20
>  		msg->hdr.data[0] =3D ACM_MAX_COUNTER;
>  		len =3D ACM_MSG_HDR_LENGTH + (ACM_MAX_COUNTER * sizeof(uint64_t));
> @@ -1426,7 +1426,7 @@ static int acm_nl_parse_path_attr(struct nlattr *at=
tr,
>  		sid =3D (uint64_t *) NLA_DATA(attr);
>  		if (NLA_LEN(attr) =3D=3D sizeof(*sid)) {
>  			acm_log(2, "service_id 0x%" PRIx64 "\n", *sid);
> -			path->service_id =3D htonll(*sid);
> +			path->service_id =3D htobe64(*sid);
>  		} else {
>  			ret =3D -1;
>  		}
> @@ -2499,7 +2499,7 @@ static void acm_load_prov_config(void)
>  		acm_log(2, "provider %s subnet_prefix 0x%" PRIx64 "\n",
>  			prov_name, prefix);
>  		/* Convert it into network byte order */
> -		prefix =3D htonll(prefix);
> +		prefix =3D htobe64(prefix);
>=20
>  		list_for_each(&provider_list, prov, entry) {
>  			if (!strcasecmp(prov->prov->name, prov_name)) {
> diff --git a/providers/cxgb3/cxio_wr.h b/providers/cxgb3/cxio_wr.h
> index d56c5298ebaad5..735b64918a15c8 100644
> --- a/providers/cxgb3/cxio_wr.h
> +++ b/providers/cxgb3/cxio_wr.h
> @@ -351,7 +351,7 @@ static inline void build_fw_riwrh(struct fw_riwrh *wq=
e, enum t3_wr_opcode op,
>  	wqe->gen_tid_len =3D htonl(V_FW_RIWR_GEN(genbit) | V_FW_RIWR_TID(tid) |
>  				 V_FW_RIWR_LEN(len));
>  	/* 2nd gen bit... */
> -        ((union t3_wr *)wqe)->flit[15] =3D htonll(genbit);
> +        ((union t3_wr *)wqe)->flit[15] =3D htobe64(genbit);
>  }
>=20
>  /*
> diff --git a/providers/cxgb3/qp.c b/providers/cxgb3/qp.c
> index 30dd898f6e874b..b0cf10364e9a6c 100644
> --- a/providers/cxgb3/qp.c
> +++ b/providers/cxgb3/qp.c
> @@ -84,7 +84,7 @@ static inline int iwch_build_rdma_send(union t3_wr *wqe=
, struct ibv_send_wr *wr,
>  			    htonl(wr->sg_list[i].lkey);
>  			wqe->send.sgl[i].len =3D
>  			    htonl(wr->sg_list[i].length);
> -			wqe->send.sgl[i].to =3D htonll(wr->sg_list[i].addr);
> +			wqe->send.sgl[i].to =3D htobe64(wr->sg_list[i].addr);
>  		}
>  		wqe->send.plen =3D htonl(wqe->send.plen);
>  		wqe->send.num_sgle =3D htonl(wr->num_sge);
> @@ -104,7 +104,7 @@ static inline int iwch_build_rdma_write(union t3_wr *=
wqe,
>  	wqe->write.rdmaop =3D T3_RDMA_WRITE;
>  	wqe->write.reserved =3D 0;
>  	wqe->write.stag_sink =3D htonl(wr->wr.rdma.rkey);
> -	wqe->write.to_sink =3D htonll(wr->wr.rdma.remote_addr);
> +	wqe->write.to_sink =3D htobe64(wr->wr.rdma.remote_addr);
>=20
>  	wqe->write.num_sgle =3D wr->num_sge;
>=20
> @@ -139,7 +139,7 @@ static inline int iwch_build_rdma_write(union t3_wr *=
wqe,
>  			wqe->write.sgl[i].len =3D
>  			    htonl(wr->sg_list[i].length);
>  			wqe->write.sgl[i].to =3D
> -			    htonll(wr->sg_list[i].addr);
> +			    htobe64(wr->sg_list[i].addr);
>  		}
>  		wqe->write.plen =3D htonl(wqe->write.plen);
>  		wqe->write.num_sgle =3D htonl(wr->num_sge);
> @@ -157,10 +157,10 @@ static inline int iwch_build_rdma_read(union t3_wr =
*wqe, struct ibv_send_wr *wr,
>  	wqe->read.reserved =3D 0;
>  	if (wr->num_sge =3D=3D 1 && wr->sg_list[0].length > 0) {
>  		wqe->read.rem_stag =3D htonl(wr->wr.rdma.rkey);
> -		wqe->read.rem_to =3D htonll(wr->wr.rdma.remote_addr);
> +		wqe->read.rem_to =3D htobe64(wr->wr.rdma.remote_addr);
>  		wqe->read.local_stag =3D htonl(wr->sg_list[0].lkey);
>  		wqe->read.local_len =3D htonl(wr->sg_list[0].length);
> -		wqe->read.local_to =3D htonll(wr->sg_list[0].addr);
> +		wqe->read.local_to =3D htobe64(wr->sg_list[0].addr);
>  	} else {
>=20
>  		/* build passable 0B read request */
> @@ -295,7 +295,7 @@ static inline int iwch_build_rdma_recv(struct iwch_de=
vice *rhp,
>  	for (i =3D 0; i < wr->num_sge; i++) {
>  		wqe->recv.sgl[i].stag =3D htonl(wr->sg_list[i].lkey);
>  		wqe->recv.sgl[i].len =3D htonl(wr->sg_list[i].length);
> -		wqe->recv.sgl[i].to =3D htonll(wr->sg_list[i].addr);
> +		wqe->recv.sgl[i].to =3D htobe64(wr->sg_list[i].addr);
>  	}
>  	for (; i < T3_MAX_SGE; i++) {
>  		wqe->recv.sgl[i].stag =3D 0;
> diff --git a/providers/cxgb4/t4.h b/providers/cxgb4/t4.h
> index cad675c3fdb193..59dbc65d4e164b 100644
> --- a/providers/cxgb4/t4.h
> +++ b/providers/cxgb4/t4.h
> @@ -55,7 +55,7 @@
>  #define __iomem
>  #define cpu_to_be16 htons
>  #define cpu_to_be32 htonl
> -#define cpu_to_be64 htonll
> +#define cpu_to_be64 htobe64
>  #define be16_to_cpu ntohs
>  #define be32_to_cpu ntohl
>  #define be64_to_cpu ntohll
> diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
> index 268fb7dc83dd11..a607326c7c452c 100644
> --- a/providers/mlx4/qp.c
> +++ b/providers/mlx4/qp.c
> @@ -157,7 +157,7 @@ static inline void set_local_inv_seg(struct mlx4_wqe_=
local_inval_seg *iseg,
>  static inline void set_raddr_seg(struct mlx4_wqe_raddr_seg *rseg,
>  				 uint64_t remote_addr, uint32_t rkey)
>  {
> -	rseg->raddr    =3D htonll(remote_addr);
> +	rseg->raddr    =3D htobe64(remote_addr);
>  	rseg->rkey     =3D htonl(rkey);
>  	rseg->reserved =3D 0;
>  }
> @@ -165,10 +165,10 @@ static inline void set_raddr_seg(struct mlx4_wqe_ra=
ddr_seg *rseg,
>  static void set_atomic_seg(struct mlx4_wqe_atomic_seg *aseg, struct ibv_=
send_wr *wr)
>  {
>  	if (wr->opcode =3D=3D IBV_WR_ATOMIC_CMP_AND_SWP) {
> -		aseg->swap_add =3D htonll(wr->wr.atomic.swap);
> -		aseg->compare  =3D htonll(wr->wr.atomic.compare_add);
> +		aseg->swap_add =3D htobe64(wr->wr.atomic.swap);
> +		aseg->compare  =3D htobe64(wr->wr.atomic.compare_add);
>  	} else {
> -		aseg->swap_add =3D htonll(wr->wr.atomic.compare_add);
> +		aseg->swap_add =3D htobe64(wr->wr.atomic.compare_add);
>  		aseg->compare  =3D 0;
>  	}
>=20
> @@ -188,13 +188,13 @@ static void __set_data_seg(struct mlx4_wqe_data_seg=
 *dseg, struct ibv_sge *sg)
>  {
>  	dseg->byte_count =3D htonl(sg->length);
>  	dseg->lkey       =3D htonl(sg->lkey);
> -	dseg->addr       =3D htonll(sg->addr);
> +	dseg->addr       =3D htobe64(sg->addr);
>  }
>=20
>  static void set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ibv_sge =
*sg)
>  {
>  	dseg->lkey       =3D htonl(sg->lkey);
> -	dseg->addr       =3D htonll(sg->addr);
> +	dseg->addr       =3D htobe64(sg->addr);
>=20
>  	/*
>  	 * Need a barrier here before writing the byte_count field to
> diff --git a/providers/mlx4/srq.c b/providers/mlx4/srq.c
> index c0e028671828d8..4f90efdf927209 100644
> --- a/providers/mlx4/srq.c
> +++ b/providers/mlx4/srq.c
> @@ -96,7 +96,7 @@ int mlx4_post_srq_recv(struct ibv_srq *ibsrq,
>  		for (i =3D 0; i < wr->num_sge; ++i) {
>  			scat[i].byte_count =3D htonl(wr->sg_list[i].length);
>  			scat[i].lkey       =3D htonl(wr->sg_list[i].lkey);
> -			scat[i].addr       =3D htonll(wr->sg_list[i].addr);
> +			scat[i].addr       =3D htobe64(wr->sg_list[i].addr);
>  		}
>=20
>  		if (i < srq->max_gs) {
> diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
> index e82b1a0bebc3f9..7d034880f4caf6 100644
> --- a/providers/mlx5/qp.c
> +++ b/providers/mlx5/qp.c
> @@ -190,7 +190,7 @@ static int mlx5_wq_overflow(struct mlx5_wq *wq, int n=
req, struct mlx5_cq *cq)
>  static inline void set_raddr_seg(struct mlx5_wqe_raddr_seg *rseg,
>  				 uint64_t remote_addr, uint32_t rkey)
>  {
> -	rseg->raddr    =3D htonll(remote_addr);
> +	rseg->raddr    =3D htobe64(remote_addr);
>  	rseg->rkey     =3D htonl(rkey);
>  	rseg->reserved =3D 0;
>  }
> @@ -201,10 +201,10 @@ static void set_atomic_seg(struct mlx5_wqe_atomic_s=
eg *aseg,
>  			   uint64_t compare_add)
>  {
>  	if (opcode =3D=3D IBV_WR_ATOMIC_CMP_AND_SWP) {
> -		aseg->swap_add =3D htonll(swap);
> -		aseg->compare  =3D htonll(compare_add);
> +		aseg->swap_add =3D htobe64(swap);
> +		aseg->compare  =3D htobe64(compare_add);
>  	} else {
> -		aseg->swap_add =3D htonll(compare_add);
> +		aseg->swap_add =3D htobe64(compare_add);
>  	}
>  }
>=20
> @@ -221,7 +221,7 @@ static void set_data_ptr_seg(struct mlx5_wqe_data_seg=
 *dseg, struct ibv_sge *sg,
>  {
>  	dseg->byte_count =3D htonl(sg->length - offset);
>  	dseg->lkey       =3D htonl(sg->lkey);
> -	dseg->addr       =3D htonll(sg->addr + offset);
> +	dseg->addr       =3D htobe64(sg->addr + offset);
>  }
>=20
>  static void set_data_ptr_seg_atomic(struct mlx5_wqe_data_seg *dseg,
> @@ -229,7 +229,7 @@ static void set_data_ptr_seg_atomic(struct mlx5_wqe_d=
ata_seg *dseg,
>  {
>  	dseg->byte_count =3D htonl(MLX5_ATOMIC_SIZE);
>  	dseg->lkey       =3D htonl(sg->lkey);
> -	dseg->addr       =3D htonll(sg->addr);
> +	dseg->addr       =3D htobe64(sg->addr);
>  }
>=20
>  /*
> @@ -430,7 +430,7 @@ static void set_umr_data_seg(struct mlx5_qp *qp, enum=
 ibv_mw_type type,
>=20
>  	data->klm.byte_count =3D htonl(bind_info->length);
>  	data->klm.mkey =3D htonl(bind_info->mr->lkey);
> -	data->klm.address =3D htonll(bind_info->addr);
> +	data->klm.address =3D htobe64(bind_info->addr);
>=20
>  	memset(&data->klm + 1, 0, sizeof(data->reserved) -
>  	       sizeof(data->klm));
> @@ -467,8 +467,8 @@ static void set_umr_mkey_seg(struct mlx5_qp *qp, enum=
 ibv_mw_type type,
>  		if (bind_info->mw_access_flags & IBV_ACCESS_ZERO_BASED)
>  			mkey->start_addr =3D 0;
>  		else
> -			mkey->start_addr =3D htonll(bind_info->addr);
> -		mkey->len =3D htonll(bind_info->length);
> +			mkey->start_addr =3D htobe64(bind_info->addr);
> +		mkey->len =3D htobe64(bind_info->length);
>  	} else {
>  		mkey->free =3D MLX5_WQE_MKEY_CONTEXT_FREE;
>  	}
> @@ -485,20 +485,20 @@ static inline void set_umr_control_seg(struct mlx5_=
qp *qp, enum ibv_mw_type type
>=20
>  	ctrl->flags =3D MLX5_WQE_UMR_CTRL_FLAG_TRNSLATION_OFFSET |
>  		MLX5_WQE_UMR_CTRL_FLAG_INLINE;
> -	ctrl->mkey_mask =3D htonll(MLX5_WQE_UMR_CTRL_MKEY_MASK_FREE |
> +	ctrl->mkey_mask =3D htobe64(MLX5_WQE_UMR_CTRL_MKEY_MASK_FREE |
>  				     MLX5_WQE_UMR_CTRL_MKEY_MASK_MKEY);
>  	ctrl->translation_offset =3D 0;
>  	memset(ctrl->rsvd0, 0, sizeof(ctrl->rsvd0));
>  	memset(ctrl->rsvd1, 0, sizeof(ctrl->rsvd1));
>=20
>  	if (type =3D=3D IBV_MW_TYPE_2)
> -		ctrl->mkey_mask |=3D htonll(MLX5_WQE_UMR_CTRL_MKEY_MASK_QPN);
> +		ctrl->mkey_mask |=3D htobe64(MLX5_WQE_UMR_CTRL_MKEY_MASK_QPN);
>=20
>  	if (bind_info->length) {
>  		ctrl->klm_octowords =3D get_klm_octo(1);
>  		if (type =3D=3D IBV_MW_TYPE_2)
>  			ctrl->flags |=3D  MLX5_WQE_UMR_CTRL_FLAG_CHECK_FREE;
> -		ctrl->mkey_mask |=3D htonll(MLX5_WQE_UMR_CTRL_MKEY_MASK_LEN	|
> +		ctrl->mkey_mask |=3D htobe64(MLX5_WQE_UMR_CTRL_MKEY_MASK_LEN	|
>  					      MLX5_WQE_UMR_CTRL_MKEY_MASK_START_ADDR |
>  					      MLX5_WQE_UMR_CTRL_MKEY_MASK_ACCESS_LOCAL_WRITE |
>  					      MLX5_WQE_UMR_CTRL_MKEY_MASK_ACCESS_REMOTE_READ |
> diff --git a/providers/mlx5/srq.c b/providers/mlx5/srq.c
> index a06afa3a5931b6..b362ec85724961 100644
> --- a/providers/mlx5/srq.c
> +++ b/providers/mlx5/srq.c
> @@ -120,7 +120,7 @@ int mlx5_post_srq_recv(struct ibv_srq *ibsrq,
>  		for (i =3D 0; i < wr->num_sge; ++i) {
>  			scat[i].byte_count =3D htonl(wr->sg_list[i].length);
>  			scat[i].lkey       =3D htonl(wr->sg_list[i].lkey);
> -			scat[i].addr       =3D htonll(wr->sg_list[i].addr);
> +			scat[i].addr       =3D htobe64(wr->sg_list[i].addr);
>  		}
>=20
>  		if (i < srq->max_gs) {
> diff --git a/providers/mthca/qp.c b/providers/mthca/qp.c
> index 129e6c74ef5382..d221bb19bfa67c 100644
> --- a/providers/mthca/qp.c
> +++ b/providers/mthca/qp.c
> @@ -147,7 +147,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			case IBV_WR_ATOMIC_CMP_AND_SWP:
>  			case IBV_WR_ATOMIC_FETCH_AND_ADD:
>  				((struct mthca_raddr_seg *) wqe)->raddr =3D
> -					htonll(wr->wr.atomic.remote_addr);
> +					htobe64(wr->wr.atomic.remote_addr);
>  				((struct mthca_raddr_seg *) wqe)->rkey =3D
>  					htonl(wr->wr.atomic.rkey);
>  				((struct mthca_raddr_seg *) wqe)->reserved =3D 0;
> @@ -156,12 +156,12 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, stru=
ct ibv_send_wr *wr,
>=20
>  				if (wr->opcode =3D=3D IBV_WR_ATOMIC_CMP_AND_SWP) {
>  					((struct mthca_atomic_seg *) wqe)->swap_add =3D
> -						htonll(wr->wr.atomic.swap);
> +						htobe64(wr->wr.atomic.swap);
>  					((struct mthca_atomic_seg *) wqe)->compare =3D
> -						htonll(wr->wr.atomic.compare_add);
> +						htobe64(wr->wr.atomic.compare_add);
>  				} else {
>  					((struct mthca_atomic_seg *) wqe)->swap_add =3D
> -						htonll(wr->wr.atomic.compare_add);
> +						htobe64(wr->wr.atomic.compare_add);
>  					((struct mthca_atomic_seg *) wqe)->compare =3D 0;
>  				}
>=20
> @@ -174,7 +174,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			case IBV_WR_RDMA_WRITE_WITH_IMM:
>  			case IBV_WR_RDMA_READ:
>  				((struct mthca_raddr_seg *) wqe)->raddr =3D
> -					htonll(wr->wr.rdma.remote_addr);
> +					htobe64(wr->wr.rdma.remote_addr);
>  				((struct mthca_raddr_seg *) wqe)->rkey =3D
>  					htonl(wr->wr.rdma.rkey);
>  				((struct mthca_raddr_seg *) wqe)->reserved =3D 0;
> @@ -194,7 +194,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			case IBV_WR_RDMA_WRITE:
>  			case IBV_WR_RDMA_WRITE_WITH_IMM:
>  				((struct mthca_raddr_seg *) wqe)->raddr =3D
> -					htonll(wr->wr.rdma.remote_addr);
> +					htobe64(wr->wr.rdma.remote_addr);
>  				((struct mthca_raddr_seg *) wqe)->rkey =3D
>  					htonl(wr->wr.rdma.rkey);
>  				((struct mthca_raddr_seg *) wqe)->reserved =3D 0;
> @@ -213,7 +213,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			((struct mthca_tavor_ud_seg *) wqe)->lkey =3D
>  				htonl(to_mah(wr->wr.ud.ah)->key);
>  			((struct mthca_tavor_ud_seg *) wqe)->av_addr =3D
> -				htonll((uintptr_t) to_mah(wr->wr.ud.ah)->av);
> +				htobe64((uintptr_t) to_mah(wr->wr.ud.ah)->av);
>  			((struct mthca_tavor_ud_seg *) wqe)->dqpn =3D
>  				htonl(wr->wr.ud.remote_qpn);
>  			((struct mthca_tavor_ud_seg *) wqe)->qkey =3D
> @@ -265,7 +265,7 @@ int mthca_tavor_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  				seg =3D wqe;
>  				seg->byte_count =3D htonl(wr->sg_list[i].length);
>  				seg->lkey =3D htonl(wr->sg_list[i].lkey);
> -				seg->addr =3D htonll(wr->sg_list[i].addr);
> +				seg->addr =3D htobe64(wr->sg_list[i].addr);
>  				wqe +=3D sizeof *seg;
>  			}
>=20
> @@ -372,7 +372,7 @@ int mthca_tavor_post_recv(struct ibv_qp *ibqp, struct=
 ibv_recv_wr *wr,
>  			((struct mthca_data_seg *) wqe)->lkey =3D
>  				htonl(wr->sg_list[i].lkey);
>  			((struct mthca_data_seg *) wqe)->addr =3D
> -				htonll(wr->sg_list[i].addr);
> +				htobe64(wr->sg_list[i].addr);
>  			wqe +=3D sizeof (struct mthca_data_seg);
>  			size +=3D sizeof (struct mthca_data_seg) / 16;
>  		}
> @@ -508,7 +508,7 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			case IBV_WR_ATOMIC_CMP_AND_SWP:
>  			case IBV_WR_ATOMIC_FETCH_AND_ADD:
>  				((struct mthca_raddr_seg *) wqe)->raddr =3D
> -					htonll(wr->wr.atomic.remote_addr);
> +					htobe64(wr->wr.atomic.remote_addr);
>  				((struct mthca_raddr_seg *) wqe)->rkey =3D
>  					htonl(wr->wr.atomic.rkey);
>  				((struct mthca_raddr_seg *) wqe)->reserved =3D 0;
> @@ -517,12 +517,12 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, stru=
ct ibv_send_wr *wr,
>=20
>  				if (wr->opcode =3D=3D IBV_WR_ATOMIC_CMP_AND_SWP) {
>  					((struct mthca_atomic_seg *) wqe)->swap_add =3D
> -						htonll(wr->wr.atomic.swap);
> +						htobe64(wr->wr.atomic.swap);
>  					((struct mthca_atomic_seg *) wqe)->compare =3D
> -						htonll(wr->wr.atomic.compare_add);
> +						htobe64(wr->wr.atomic.compare_add);
>  				} else {
>  					((struct mthca_atomic_seg *) wqe)->swap_add =3D
> -						htonll(wr->wr.atomic.compare_add);
> +						htobe64(wr->wr.atomic.compare_add);
>  					((struct mthca_atomic_seg *) wqe)->compare =3D 0;
>  				}
>=20
> @@ -535,7 +535,7 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			case IBV_WR_RDMA_WRITE_WITH_IMM:
>  			case IBV_WR_RDMA_READ:
>  				((struct mthca_raddr_seg *) wqe)->raddr =3D
> -					htonll(wr->wr.rdma.remote_addr);
> +					htobe64(wr->wr.rdma.remote_addr);
>  				((struct mthca_raddr_seg *) wqe)->rkey =3D
>  					htonl(wr->wr.rdma.rkey);
>  				((struct mthca_raddr_seg *) wqe)->reserved =3D 0;
> @@ -555,7 +555,7 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  			case IBV_WR_RDMA_WRITE:
>  			case IBV_WR_RDMA_WRITE_WITH_IMM:
>  				((struct mthca_raddr_seg *) wqe)->raddr =3D
> -					htonll(wr->wr.rdma.remote_addr);
> +					htobe64(wr->wr.rdma.remote_addr);
>  				((struct mthca_raddr_seg *) wqe)->rkey =3D
>  					htonl(wr->wr.rdma.rkey);
>  				((struct mthca_raddr_seg *) wqe)->reserved =3D 0;
> @@ -624,7 +624,7 @@ int mthca_arbel_post_send(struct ibv_qp *ibqp, struct=
 ibv_send_wr *wr,
>  				seg =3D wqe;
>  				seg->byte_count =3D htonl(wr->sg_list[i].length);
>  				seg->lkey =3D htonl(wr->sg_list[i].lkey);
> -				seg->addr =3D htonll(wr->sg_list[i].addr);
> +				seg->addr =3D htobe64(wr->sg_list[i].addr);
>  				wqe +=3D sizeof *seg;
>  			}
>=20
> @@ -730,7 +730,7 @@ int mthca_arbel_post_recv(struct ibv_qp *ibqp, struct=
 ibv_recv_wr *wr,
>  			((struct mthca_data_seg *) wqe)->lkey =3D
>  				htonl(wr->sg_list[i].lkey);
>  			((struct mthca_data_seg *) wqe)->addr =3D
> -				htonll(wr->sg_list[i].addr);
> +				htobe64(wr->sg_list[i].addr);
>  			wqe +=3D sizeof (struct mthca_data_seg);
>  		}
>=20
> diff --git a/providers/mthca/srq.c b/providers/mthca/srq.c
> index ff6f532733f4ae..66ac924a720c84 100644
> --- a/providers/mthca/srq.c
> +++ b/providers/mthca/srq.c
> @@ -126,7 +126,7 @@ int mthca_tavor_post_srq_recv(struct ibv_srq *ibsrq,
>  			((struct mthca_data_seg *) wqe)->lkey =3D
>  				htonl(wr->sg_list[i].lkey);
>  			((struct mthca_data_seg *) wqe)->addr =3D
> -				htonll(wr->sg_list[i].addr);
> +				htobe64(wr->sg_list[i].addr);
>  			wqe +=3D sizeof (struct mthca_data_seg);
>  		}
>=20
> @@ -219,7 +219,7 @@ int mthca_arbel_post_srq_recv(struct ibv_srq *ibsrq,
>  			((struct mthca_data_seg *) wqe)->lkey =3D
>  				htonl(wr->sg_list[i].lkey);
>  			((struct mthca_data_seg *) wqe)->addr =3D
> -				htonll(wr->sg_list[i].addr);
> +				htobe64(wr->sg_list[i].addr);
>  			wqe +=3D sizeof (struct mthca_data_seg);
>  		}
>=20
> diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
> index 823ed8754c09d7..932115c8ab7f39 100644
> --- a/providers/qedr/qelr_verbs.c
> +++ b/providers/qedr/qelr_verbs.c
> @@ -900,7 +900,7 @@ static inline void qelr_edpm_set_rdma_ext(struct qelr=
_qp *qp,
>  	if (!qp->edpm.is_edpm)
>  		return;
>=20
> -	qp->edpm.rdma_ext->remote_va =3D htonll(remote_addr);
> +	qp->edpm.rdma_ext->remote_va =3D htobe64(remote_addr);
>  	qp->edpm.rdma_ext->remote_key =3D htonl(rkey);
>  	qp->edpm.dpm_payload_offset +=3D sizeof(*qp->edpm.rdma_ext);
>  	qp->edpm.dpm_payload_size +=3D sizeof(*qp->edpm.rdma_ext);
> diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> index e0e550d81ab3c2..ff6118acf611ca 100644
> --- a/srp_daemon/srp_daemon.c
> +++ b/srp_daemon/srp_daemon.c
> @@ -462,9 +462,9 @@ static int add_non_exist_target(struct target_details=
 *target)
>  			if (srpd_sys_read_gid(scsi_host_dir, "dgid", dgid_val))
>  				continue;
>  		}
> -		if (htonll(target->subnet_prefix) !=3D *((uint64_t *) dgid_val))
> +		if (htobe64(target->subnet_prefix) !=3D *((uint64_t *) dgid_val))
>  			continue;
> -		if (htonll(target->h_guid) !=3D *((uint64_t *) (dgid_val+8)))
> +		if (htobe64(target->h_guid) !=3D *((uint64_t *) (dgid_val+8)))
>  			continue;
>=20
>  		/* If there is no local_ib_device in the scsi host dir (old kernel mod=
ule), assumes it is equal */
> @@ -603,7 +603,7 @@ static int send_and_get(int portid, int agent, srp_ib=
_user_mad_t *out_mad,
>  		/* Skip tid 0 because OpenSM ignores it. */
>  		if (++tid =3D=3D 0)
>  			++tid;
> -		out_dm_mad->tid =3D htonll(tid);
> +		out_dm_mad->tid =3D htobe64(tid);
>=20
>  		ret =3D umad_send(portid, agent, out_mad, MAD_BLOCK_SIZE,
>  				config->timeout, 0);
> @@ -1033,7 +1033,7 @@ int get_node(struct umad_resources *umad_res, uint1=
6_t dlid, uint64_t *guid)
>  	init_srp_sa_mad(&out_mad, umad_res->agent, umad_res->sm_lid,
>  		        SRP_SA_ATTR_NODE, 0);
>=20
> -	out_sa_mad->comp_mask     =3D htonll(1); /* LID */
> +	out_sa_mad->comp_mask     =3D htobe64(1); /* LID */
>  	node			  =3D (void *) out_sa_mad->data;
>  	node->lid		  =3D htons(dlid);
>=20
> @@ -1059,7 +1059,7 @@ static int get_port_info(struct umad_resources *uma=
d_res, uint16_t dlid,
>  	init_srp_sa_mad(&out_mad, umad_res->agent, umad_res->sm_lid,
>  		        SRP_SA_ATTR_PORT_INFO, 0);
>=20
> -	out_sa_mad->comp_mask     =3D htonll(1); /* LID */
> +	out_sa_mad->comp_mask     =3D htobe64(1); /* LID */
>  	port_info                 =3D (void *) out_sa_mad->data;
>  	port_info->endport_lid	  =3D htons(dlid);
>=20
> @@ -1134,7 +1134,7 @@ static int get_shared_pkeys(struct resources *res,
>  			continue;
>=20
>  		/* Mark components: DLID, SLID, PKEY */
> -		out_sa_mad->comp_mask =3D htonll(1 << 4 | 1 << 5 | 1 << 13);
> +		out_sa_mad->comp_mask =3D htobe64(1 << 4 | 1 << 5 | 1 << 13);
>  		out_sa_mad->rmpp_version =3D 1;
>  		out_sa_mad->rmpp_type =3D 1;
>  		path_rec =3D (ib_path_rec_t *)out_sa_mad->data;
> @@ -1194,7 +1194,7 @@ static int do_dm_port_list(struct resources *res)
>  		        SRP_SA_ATTR_PORT_INFO, SRP_SM_CAP_MASK_MATCH_ATTR_MOD);
>=20
>  	out_sa_mad->method     	   =3D SRP_SA_METHOD_GET_TABLE;
> -	out_sa_mad->comp_mask      =3D htonll(1 << 7); /* Capability mask */
> +	out_sa_mad->comp_mask      =3D htobe64(1 << 7); /* Capability mask */
>  	out_sa_mad->rmpp_version   =3D 1;
>  	out_sa_mad->rmpp_type      =3D 1;
>  	port_info		   =3D (void *) out_sa_mad->data;
> @@ -2330,7 +2330,7 @@ static int get_lid(struct umad_resources *umad_res,=
 ib_gid_t *gid, uint16_t *lid
>  	init_srp_sa_mad(&out_mad, umad_res->agent, umad_res->sm_lid,
>  		        SRP_SA_ATTR_PATH_REC, 0);
>=20
> -	out_sa_mad->comp_mask =3D htonll( 4 | 8 | 64 | 512 | 4096 );
> +	out_sa_mad->comp_mask =3D htobe64( 4 | 8 | 64 | 512 | 4096 );
>=20
>  	path_rec->sgid =3D *gid;
>  	path_rec->dgid =3D *gid;
> diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.=
c
> index 01cc5445e8352b..6a7a2d1ab479a1 100644
> --- a/srp_daemon/srp_handle_traps.c
> +++ b/srp_daemon/srp_handle_traps.c
> @@ -606,14 +606,14 @@ static int register_to_trap(struct sync_resources *=
sync_res,
>  	    comp_mask |=3D SRP_INFORMINFO_QPN_COMP;
>  	}
>=20
> -	p_sa_mad->comp_mask =3D htonll(comp_mask);
> +	p_sa_mad->comp_mask =3D htobe64(comp_mask);
>  	pr_debug("comp_mask: %llx\n", comp_mask);
>=20
>  	do {
>  		pthread_mutex_lock(res->mad_buffer_mutex);
>  		res->mad_buffer->base_ver =3D 0; // flag that the buffer is empty
>  		pthread_mutex_unlock(res->mad_buffer_mutex);
> -		mad_hdr->trans_id =3D htonll(trans_id);
> +		mad_hdr->trans_id =3D htobe64(trans_id);
>  		trans_id++;
>=20
>  		ret =3D ibv_post_send(res->qp, &sr, bad_wr);
> --
> 2.7.4
>=20

Looks good.

Reviewed-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
