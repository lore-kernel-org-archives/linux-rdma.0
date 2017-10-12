From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 19/45] IB/hns: Declare local functions 'static'
Date: Thu, 12 Oct 2017 09:12:45 +0800
Message-ID: <59DEC18D.90400@huawei.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
 <20171011174927.25113-20-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-20-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 2017/10/12 1:49, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 64 ++++++++++++++++--------------
>   1 file changed, 35 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 187241484fa1..658e3a7464b3 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -57,8 +57,8 @@ static void set_raddr_seg(struct hns_roce_wqe_raddr_seg *rseg, u64 remote_addr,
>   	rseg->len   = 0;
>   }
>   
> -int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> -			  struct ib_send_wr **bad_wr)
> +static int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> +				 struct ib_send_wr **bad_wr)
>   {
>   	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
>   	struct hns_roce_ah *ah = to_hr_ah(ud_wr(wr)->ah);
> @@ -317,8 +317,8 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>   	return ret;
>   }
>   
> -int hns_roce_v1_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
> -			  struct ib_recv_wr **bad_wr)
> +static int hns_roce_v1_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
> +				 struct ib_recv_wr **bad_wr)
>   {
>   	int ret = 0;
>   	int nreq = 0;
> @@ -877,7 +877,7 @@ static int hns_roce_db_init(struct hns_roce_dev *hr_dev)
>   	return 0;
>   }
>   
> -void hns_roce_v1_recreate_lp_qp_work_fn(struct work_struct *work)
> +static void hns_roce_v1_recreate_lp_qp_work_fn(struct work_struct *work)
>   {
>   	struct hns_roce_recreate_lp_qp_work *lp_qp_work;
>   	struct hns_roce_dev *hr_dev;
> @@ -1033,7 +1033,8 @@ static void hns_roce_v1_mr_free_work_fn(struct work_struct *work)
>   	kfree(mr_work);
>   }
>   
> -int hns_roce_v1_dereg_mr(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr)
> +static int hns_roce_v1_dereg_mr(struct hns_roce_dev *hr_dev,
> +				struct hns_roce_mr *mr)
>   {
>   	struct device *dev = &hr_dev->pdev->dev;
>   	struct hns_roce_mr_free_work *mr_work;
> @@ -1391,7 +1392,7 @@ static void hns_roce_free_mr_free(struct hns_roce_dev *hr_dev)
>    * @enable: true -- drop reset, false -- reset
>    * return 0 - success , negative --fail
>    */
> -int hns_roce_v1_reset(struct hns_roce_dev *hr_dev, bool dereset)
> +static int hns_roce_v1_reset(struct hns_roce_dev *hr_dev, bool dereset)
>   {
>   	struct device_node *dsaf_node;
>   	struct device *dev = &hr_dev->pdev->dev;
> @@ -1466,7 +1467,7 @@ static void hns_roce_des_qp_free(struct hns_roce_dev *hr_dev)
>   	destroy_workqueue(des_qp->qp_wq);
>   }
>   
> -int hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
> +static int hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
>   {
>   	int i = 0;
>   	struct hns_roce_caps *caps = &hr_dev->caps;
> @@ -1538,7 +1539,7 @@ int hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
>   	return 0;
>   }
>   
> -int hns_roce_v1_init(struct hns_roce_dev *hr_dev)
> +static int hns_roce_v1_init(struct hns_roce_dev *hr_dev)
>   {
>   	int ret;
>   	u32 val;
> @@ -1617,7 +1618,7 @@ int hns_roce_v1_init(struct hns_roce_dev *hr_dev)
>   	return ret;
>   }
>   
> -void hns_roce_v1_exit(struct hns_roce_dev *hr_dev)
> +static void hns_roce_v1_exit(struct hns_roce_dev *hr_dev)
>   {
>   	hns_roce_port_enable(hr_dev, HNS_ROCE_PORT_DOWN);
>   	hns_roce_free_mr_free(hr_dev);
> @@ -1701,8 +1702,8 @@ static int hns_roce_v1_chk_mbox(struct hns_roce_dev *hr_dev,
>   	return 0;
>   }
>   
> -void hns_roce_v1_set_gid(struct hns_roce_dev *hr_dev, u8 port, int gid_index,
> -			 union ib_gid *gid)
> +static void hns_roce_v1_set_gid(struct hns_roce_dev *hr_dev, u8 port,
> +				int gid_index, union ib_gid *gid)
>   {
>   	u32 *p = NULL;
>   	u8 gid_idx = 0;
> @@ -1765,8 +1766,8 @@ static int hns_roce_v1_set_mac(struct hns_roce_dev *hr_dev, u8 phy_port,
>   	return 0;
>   }
>   
> -void hns_roce_v1_set_mtu(struct hns_roce_dev *hr_dev, u8 phy_port,
> -			 enum ib_mtu mtu)
> +static void hns_roce_v1_set_mtu(struct hns_roce_dev *hr_dev, u8 phy_port,
> +				enum ib_mtu mtu)
>   {
>   	u32 val;
>   
> @@ -1778,8 +1779,8 @@ void hns_roce_v1_set_mtu(struct hns_roce_dev *hr_dev, u8 phy_port,
>   		   val);
>   }
>   
> -int hns_roce_v1_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
> -			   unsigned long mtpt_idx)
> +static int hns_roce_v1_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
> +				  unsigned long mtpt_idx)
>   {
>   	struct hns_roce_v1_mpt_entry *mpt_entry;
>   	struct scatterlist *sg;
> @@ -1951,7 +1952,7 @@ static struct hns_roce_cqe *next_cqe_sw(struct hns_roce_cq *hr_cq)
>   	return get_sw_cqe(hr_cq, hr_cq->cons_index);
>   }
>   
> -void hns_roce_v1_cq_set_ci(struct hns_roce_cq *hr_cq, u32 cons_index)
> +static void hns_roce_v1_cq_set_ci(struct hns_roce_cq *hr_cq, u32 cons_index)
>   {
>   	u32 doorbell[2];
>   
> @@ -2024,9 +2025,10 @@ static void hns_roce_v1_cq_clean(struct hns_roce_cq *hr_cq, u32 qpn,
>   	spin_unlock_irq(&hr_cq->lock);
>   }
>   
> -void hns_roce_v1_write_cqc(struct hns_roce_dev *hr_dev,
> -			   struct hns_roce_cq *hr_cq, void *mb_buf, u64 *mtts,
> -			   dma_addr_t dma_handle, int nent, u32 vector)
> +static void hns_roce_v1_write_cqc(struct hns_roce_dev *hr_dev,
> +				  struct hns_roce_cq *hr_cq, void *mb_buf,
> +				  u64 *mtts, dma_addr_t dma_handle, int nent,
> +				  u32 vector)
>   {
>   	struct hns_roce_cq_context *cq_context = NULL;
>   	struct hns_roce_buf_list *tptr_buf;
> @@ -2111,7 +2113,8 @@ void hns_roce_v1_write_cqc(struct hns_roce_dev *hr_dev,
>   	cq_context->cqc_byte_32 = cpu_to_le32(cq_context->cqc_byte_32);
>   }
>   
> -int hns_roce_v1_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
> +static int hns_roce_v1_req_notify_cq(struct ib_cq *ibcq,
> +				     enum ib_cq_notify_flags flags)
>   {
>   	struct hns_roce_cq *hr_cq = to_hr_cq(ibcq);
>   	u32 notification_flag;
> @@ -2372,8 +2375,9 @@ int hns_roce_v1_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
>   		return ret;
>   }
>   
> -int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
> -		struct hns_roce_hem_table *table, int obj, int step_idx)
> +static int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
> +				 struct hns_roce_hem_table *table, int obj,
> +				 int step_idx)
>   {
>   	struct device *dev = &hr_dev->pdev->dev;
>   	struct hns_roce_v1_priv *priv;
> @@ -3272,9 +3276,10 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
>   	return ret;
>   }
>   
> -int hns_roce_v1_modify_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
> -			  int attr_mask, enum ib_qp_state cur_state,
> -			  enum ib_qp_state new_state)
> +static int hns_roce_v1_modify_qp(struct ib_qp *ibqp,
> +				 const struct ib_qp_attr *attr, int attr_mask,
> +				 enum ib_qp_state cur_state,
> +				 enum ib_qp_state new_state)
>   {
>   
>   	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
> @@ -3541,8 +3546,9 @@ static int hns_roce_v1_q_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
>   	return ret;
>   }
>   
> -int hns_roce_v1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
> -			 int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
> +static int hns_roce_v1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
> +				int qp_attr_mask,
> +				struct ib_qp_init_attr *qp_init_attr)
>   {
>   	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
>   
> @@ -3893,7 +3899,7 @@ int hns_roce_v1_destroy_qp(struct ib_qp *ibqp)
>   	return 0;
>   }
>   
> -int hns_roce_v1_destroy_cq(struct ib_cq *ibcq)
> +static int hns_roce_v1_destroy_cq(struct ib_cq *ibcq)
>   {
>   	struct hns_roce_dev *hr_dev = to_hr_dev(ibcq->device);
>   	struct hns_roce_cq *hr_cq = to_hr_cq(ibcq);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
