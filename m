From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 4/7] RDMA/hns: Fill sq wqe context of ud type
 in hip08
Date: Sat, 13 Jan 2018 05:22:35 +0800
Message-ID: <201801130528.qwegQUrn%fengguang.wu@intel.com>
References: <1515566393-63888-5-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515566393-63888-5-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Lijun,

I love your patch! Perhaps something to improve:

[auto build test WARNING on rdma/for-next]
[also build test WARNING on next-20180112]
[cannot apply to linus/master v4.15-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Lijun-Ou/Add-CM-and-a-bugfix-to-hip08/20180112-215900
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:49:20: sparse: incorrect type in assignment (different base types) @@ expected restricted __be32 lkey @@ got restricted __be32 lkey @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:49:20: expected restricted __be32 lkey
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:49:20: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:50:20: sparse: incorrect type in assignment (different base types) @@ expected restricted __be64 addr @@ got restricted __be64 addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:50:20: expected restricted __be64 addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:50:20: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:51:20: sparse: incorrect type in assignment (different base types) @@ expected restricted __be32 len @@ got restricted __be32 len @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:51:20: expected restricted __be32 len
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:51:20: got restricted __le32 <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:222:45: sparse: incorrect type in assignment (different base types) @@ expected unsigned int immtdata @@ got gned] immtdata @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:222:45: expected unsigned int immtdata
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:222:45: got restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:263:25: sparse: cast from restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:282:25: sparse: restricted __le32 degrades to integer
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:315:53: sparse: incorrect type in assignment (different base types) @@ expected unsigned int inv_key_immtdata @@ got gned] inv_key_immtdata @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:315:53: expected unsigned int inv_key_immtdata
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:315:53: got restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:338:49: sparse: incorrect type in assignment (different base types) @@ expected unsigned int rkey @@ got ed int rkey @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:338:49: expected unsigned int rkey
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:338:49: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:340:47: sparse: incorrect type in assignment (different base types) @@ expected unsigned long long va @@ got g long va @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:340:47: expected unsigned long long va
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:340:47: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:348:49: sparse: incorrect type in assignment (different base types) @@ expected unsigned int rkey @@ got ed int rkey @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:348:49: expected unsigned int rkey
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:348:49: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:350:47: sparse: incorrect type in assignment (different base types) @@ expected unsigned long long va @@ got g long va @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:350:47: expected unsigned long long va
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:350:47: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:358:49: sparse: incorrect type in assignment (different base types) @@ expected unsigned int rkey @@ got ed int rkey @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:358:49: expected unsigned int rkey
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:358:49: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:360:47: sparse: incorrect type in assignment (different base types) @@ expected unsigned long long va @@ got g long va @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:360:47: expected unsigned long long va
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:360:47: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:443:17: sparse: cast from restricted __le64
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:692:22: sparse: incorrect type in assignment (different base types) @@ expected unsigned short opcode @@ got short opcode @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:692:22: expected unsigned short opcode
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:692:22: got restricted __le16 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:693:20: sparse: incorrect type in assignment (different base types) @@ expected unsigned short flag @@ got short flag @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:693:20: expected unsigned short flag
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:693:20: got restricted __le16 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:696:28: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:696:28: left side has type unsigned short
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:696:28: right side has type restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:698:28: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:698:28: left side has type unsigned short
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:698:28: right side has type restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:832:26: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:832:26: sparse: cast from restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:833:29: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:833:29: sparse: cast from restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:848:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:848:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:848:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:848:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:848:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:848:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:851:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:851:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:851:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:851:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:851:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:851:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:870:38: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:870:38: left side has type unsigned short
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:870:38: right side has type restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:872:38: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:872:38: left side has type unsigned short
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:872:38: right side has type fouled restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:881:35: sparse: restricted __le32 degrades to integer
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:884:36: sparse: restricted __le32 degrades to integer
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:887:35: sparse: restricted __le32 degrades to integer
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:890:35: sparse: restricted __le32 degrades to integer
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:913:38: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:913:38: left side has type unsigned short
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:913:38: right side has type restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:915:38: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:915:38: left side has type unsigned short
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:915:38: right side has type fouled restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1202:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1202:22: expected unsigned long val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1202:22: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1203:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1203:22: expected unsigned long val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1203:22: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1208:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1208:22: expected unsigned int val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1208:22: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1209:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1209:22: expected unsigned int val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1209:22: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1321:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1321:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1321:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1321:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1321:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1321:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1323:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1323:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1323:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1323:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1323:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1323:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: right side has type unsigned long
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: left side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: right side has type unsigned long

vim +222 drivers/infiniband/hw/hns/hns_roce_hw_v2.c

    45	
    46	static void set_data_seg_v2(struct hns_roce_v2_wqe_data_seg *dseg,
    47				    struct ib_sge *sg)
    48	{
  > 49		dseg->lkey = cpu_to_le32(sg->lkey);
    50		dseg->addr = cpu_to_le64(sg->addr);
    51		dseg->len  = cpu_to_le32(sg->length);
    52	}
    53	
    54	static int set_rwqe_data_seg(struct ib_qp *ibqp, struct ib_send_wr *wr,
    55				     struct hns_roce_v2_rc_send_wqe *rc_sq_wqe,
    56				     void *wqe, unsigned int *sge_ind,
    57				     struct ib_send_wr **bad_wr)
    58	{
    59		struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
    60		struct hns_roce_v2_wqe_data_seg *dseg = wqe;
    61		struct hns_roce_qp *qp = to_hr_qp(ibqp);
    62		int i;
    63	
    64		if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
    65			if (rc_sq_wqe->msg_len > hr_dev->caps.max_sq_inline) {
    66				*bad_wr = wr;
    67				dev_err(hr_dev->dev, "inline len(1-%d)=%d, illegal",
    68					rc_sq_wqe->msg_len, hr_dev->caps.max_sq_inline);
    69				return -EINVAL;
    70			}
    71	
    72			for (i = 0; i < wr->num_sge; i++) {
    73				memcpy(wqe, ((void *)wr->sg_list[i].addr),
    74				       wr->sg_list[i].length);
    75				wqe += wr->sg_list[i].length;
    76			}
    77	
    78			roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_INLINE_S,
    79				     1);
    80		} else {
    81			if (wr->num_sge <= 2) {
    82				for (i = 0; i < wr->num_sge; i++) {
    83					if (likely(wr->sg_list[i].length)) {
    84						set_data_seg_v2(dseg, wr->sg_list + i);
    85						dseg++;
    86					}
    87				}
    88			} else {
    89				roce_set_field(rc_sq_wqe->byte_20,
    90					     V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_M,
    91					     V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
    92					     (*sge_ind) & (qp->sge.sge_cnt - 1));
    93	
    94				for (i = 0; i < 2; i++) {
    95					if (likely(wr->sg_list[i].length)) {
    96						set_data_seg_v2(dseg, wr->sg_list + i);
    97						dseg++;
    98					}
    99				}
   100	
   101				dseg = get_send_extend_sge(qp,
   102						    (*sge_ind) & (qp->sge.sge_cnt - 1));
   103	
   104				for (i = 0; i < wr->num_sge - 2; i++) {
   105					if (likely(wr->sg_list[i + 2].length)) {
   106						set_data_seg_v2(dseg,
   107								wr->sg_list + 2 + i);
   108						dseg++;
   109						(*sge_ind)++;
   110					}
   111				}
   112			}
   113	
   114			roce_set_field(rc_sq_wqe->byte_16,
   115				       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_M,
   116				       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_S, wr->num_sge);
   117		}
   118	
   119		return 0;
   120	}
   121	
   122	static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
   123					 struct ib_send_wr **bad_wr)
   124	{
   125		struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
   126		struct hns_roce_ah *ah = to_hr_ah(ud_wr(wr)->ah);
   127		struct hns_roce_v2_ud_send_wqe *ud_sq_wqe;
   128		struct hns_roce_v2_rc_send_wqe *rc_sq_wqe;
   129		struct hns_roce_qp *qp = to_hr_qp(ibqp);
   130		struct hns_roce_v2_wqe_data_seg *dseg;
   131		struct device *dev = hr_dev->dev;
   132		struct hns_roce_v2_db sq_db;
   133		unsigned int sge_ind = 0;
   134		unsigned int owner_bit;
   135		unsigned long flags;
   136		unsigned int ind;
   137		void *wqe = NULL;
   138		bool loopback;
   139		int ret = 0;
   140		u8 *smac;
   141		int nreq;
   142		int i;
   143	
   144		if (unlikely(ibqp->qp_type != IB_QPT_RC &&
   145			     ibqp->qp_type != IB_QPT_GSI &&
   146			     ibqp->qp_type != IB_QPT_UD)) {
   147			dev_err(dev, "Not supported QP(0x%x)type!\n", ibqp->qp_type);
   148			*bad_wr = NULL;
   149			return -EOPNOTSUPP;
   150		}
   151	
   152		if (unlikely(qp->state == IB_QPS_RESET || qp->state == IB_QPS_INIT ||
   153			     qp->state == IB_QPS_RTR)) {
   154			dev_err(dev, "Post WQE fail, QP state %d err!\n", qp->state);
   155			*bad_wr = wr;
   156			return -EINVAL;
   157		}
   158	
   159		spin_lock_irqsave(&qp->sq.lock, flags);
   160		ind = qp->sq_next_wqe;
   161		sge_ind = qp->next_sge;
   162	
   163		for (nreq = 0; wr; ++nreq, wr = wr->next) {
   164			if (hns_roce_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq)) {
   165				ret = -ENOMEM;
   166				*bad_wr = wr;
   167				goto out;
   168			}
   169	
   170			if (unlikely(wr->num_sge > qp->sq.max_gs)) {
   171				dev_err(dev, "num_sge=%d > qp->sq.max_gs=%d\n",
   172					wr->num_sge, qp->sq.max_gs);
   173				ret = -EINVAL;
   174				*bad_wr = wr;
   175				goto out;
   176			}
   177	
   178			wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
   179			qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
   180									      wr->wr_id;
   181	
   182			owner_bit = ~(qp->sq.head >> ilog2(qp->sq.wqe_cnt)) & 0x1;
   183	
   184			/* Corresponding to the QP type, wqe process separately */
   185			if (ibqp->qp_type == IB_QPT_GSI) {
   186				ud_sq_wqe = wqe;
   187				memset(ud_sq_wqe, 0, sizeof(*ud_sq_wqe));
   188	
   189				roce_set_field(ud_sq_wqe->dmac, V2_UD_SEND_WQE_DMAC_0_M,
   190					       V2_UD_SEND_WQE_DMAC_0_S, ah->av.mac[0]);
   191				roce_set_field(ud_sq_wqe->dmac, V2_UD_SEND_WQE_DMAC_1_M,
   192					       V2_UD_SEND_WQE_DMAC_1_S, ah->av.mac[1]);
   193				roce_set_field(ud_sq_wqe->dmac, V2_UD_SEND_WQE_DMAC_2_M,
   194					       V2_UD_SEND_WQE_DMAC_2_S, ah->av.mac[2]);
   195				roce_set_field(ud_sq_wqe->dmac, V2_UD_SEND_WQE_DMAC_3_M,
   196					       V2_UD_SEND_WQE_DMAC_3_S, ah->av.mac[3]);
   197				roce_set_field(ud_sq_wqe->byte_48,
   198					       V2_UD_SEND_WQE_BYTE_48_DMAC_4_M,
   199					       V2_UD_SEND_WQE_BYTE_48_DMAC_4_S,
   200					       ah->av.mac[4]);
   201				roce_set_field(ud_sq_wqe->byte_48,
   202					       V2_UD_SEND_WQE_BYTE_48_DMAC_5_M,
   203					       V2_UD_SEND_WQE_BYTE_48_DMAC_5_S,
   204					       ah->av.mac[5]);
   205	
   206				/* MAC loopback */
   207				smac = (u8 *)hr_dev->dev_addr[qp->port];
   208				loopback = ether_addr_equal_unaligned(ah->av.mac,
   209								      smac) ? 1 : 0;
   210	
   211				roce_set_bit(ud_sq_wqe->byte_40,
   212					     V2_UD_SEND_WQE_BYTE_40_LBI_S, loopback);
   213	
   214				roce_set_field(ud_sq_wqe->byte_4,
   215					       V2_UD_SEND_WQE_BYTE_4_OPCODE_M,
   216					       V2_UD_SEND_WQE_BYTE_4_OPCODE_S,
   217					       HNS_ROCE_V2_WQE_OP_SEND);
   218	
   219				for (i = 0; i < wr->num_sge; i++)
   220					ud_sq_wqe->msg_len += wr->sg_list[i].length;
   221	
 > 222				ud_sq_wqe->immtdata = send_ieth(wr);
   223	
   224				/* Set sig attr */
   225				roce_set_bit(ud_sq_wqe->byte_4,
   226					   V2_UD_SEND_WQE_BYTE_4_CQE_S,
   227					   (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
   228	
   229				/* Set se attr */
   230				roce_set_bit(ud_sq_wqe->byte_4,
   231					  V2_UD_SEND_WQE_BYTE_4_SE_S,
   232					  (wr->send_flags & IB_SEND_SOLICITED) ? 1 : 0);
   233	
   234				roce_set_bit(ud_sq_wqe->byte_4,
   235					     V2_UD_SEND_WQE_BYTE_4_OWNER_S, owner_bit);
   236	
   237				roce_set_field(ud_sq_wqe->byte_16,
   238					       V2_UD_SEND_WQE_BYTE_16_PD_M,
   239					       V2_UD_SEND_WQE_BYTE_16_PD_S,
   240					       to_hr_pd(ibqp->pd)->pdn);
   241	
   242				roce_set_field(ud_sq_wqe->byte_16,
   243					       V2_UD_SEND_WQE_BYTE_16_SGE_NUM_M,
   244					       V2_UD_SEND_WQE_BYTE_16_SGE_NUM_S,
   245					       wr->num_sge);
   246	
   247				roce_set_field(ud_sq_wqe->byte_20,
   248					     V2_UD_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_M,
   249					     V2_UD_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
   250					     sge_ind & (qp->sge.sge_cnt - 1));
   251	
   252				roce_set_field(ud_sq_wqe->byte_24,
   253					       V2_UD_SEND_WQE_BYTE_24_UDPSPN_M,
   254					       V2_UD_SEND_WQE_BYTE_24_UDPSPN_S, 0);
   255				ud_sq_wqe->qkey =
   256				     cpu_to_be32(ud_wr(wr)->remote_qkey & 0x80000000) ?
   257				     qp->qkey : ud_wr(wr)->remote_qkey;
   258				roce_set_field(ud_sq_wqe->byte_32,
   259					       V2_UD_SEND_WQE_BYTE_32_DQPN_M,
   260					       V2_UD_SEND_WQE_BYTE_32_DQPN_S,
   261					       ud_wr(wr)->remote_qpn);
   262	
   263				roce_set_field(ud_sq_wqe->byte_36,
   264					       V2_UD_SEND_WQE_BYTE_36_VLAN_M,
   265					       V2_UD_SEND_WQE_BYTE_36_VLAN_S,
   266					       ah->av.vlan);
   267				roce_set_field(ud_sq_wqe->byte_36,
   268					       V2_UD_SEND_WQE_BYTE_36_HOPLIMIT_M,
   269					       V2_UD_SEND_WQE_BYTE_36_HOPLIMIT_S,
   270					       ah->av.hop_limit);
   271				roce_set_field(ud_sq_wqe->byte_36,
   272					       V2_UD_SEND_WQE_BYTE_36_TCLASS_M,
   273					       V2_UD_SEND_WQE_BYTE_36_TCLASS_S,
   274					       0);
   275				roce_set_field(ud_sq_wqe->byte_36,
   276					       V2_UD_SEND_WQE_BYTE_36_TCLASS_M,
   277					       V2_UD_SEND_WQE_BYTE_36_TCLASS_S,
   278					       0);
   279				roce_set_field(ud_sq_wqe->byte_40,
   280					       V2_UD_SEND_WQE_BYTE_40_FLOW_LABEL_M,
   281					       V2_UD_SEND_WQE_BYTE_40_FLOW_LABEL_S, 0);
   282				roce_set_field(ud_sq_wqe->byte_40,
   283					       V2_UD_SEND_WQE_BYTE_40_SL_M,
   284					       V2_UD_SEND_WQE_BYTE_40_SL_S,
   285					       ah->av.sl_tclass_flowlabel >>
   286					       HNS_ROCE_SL_SHIFT);
   287				roce_set_field(ud_sq_wqe->byte_40,
   288					       V2_UD_SEND_WQE_BYTE_40_PORTN_M,
   289					       V2_UD_SEND_WQE_BYTE_40_PORTN_S,
   290					       qp->port);
   291	
   292				roce_set_field(ud_sq_wqe->byte_48,
   293					       V2_UD_SEND_WQE_BYTE_48_SGID_INDX_M,
   294					       V2_UD_SEND_WQE_BYTE_48_SGID_INDX_S,
   295					       hns_get_gid_index(hr_dev, qp->phy_port,
   296								 ah->av.gid_index));
   297	
   298				memcpy(&ud_sq_wqe->dgid[0], &ah->av.dgid[0],
   299				       GID_LEN_V2);
   300	
   301				dseg = get_send_extend_sge(qp,
   302						    sge_ind & (qp->sge.sge_cnt - 1));
   303				for (i = 0; i < wr->num_sge; i++) {
   304					set_data_seg_v2(dseg + i, wr->sg_list + i);
   305					sge_ind++;
   306				}
   307	
   308				ind++;
   309			} else if (ibqp->qp_type == IB_QPT_RC) {
   310				rc_sq_wqe = wqe;
   311				memset(rc_sq_wqe, 0, sizeof(*rc_sq_wqe));
   312				for (i = 0; i < wr->num_sge; i++)
   313					rc_sq_wqe->msg_len += wr->sg_list[i].length;
   314	
   315				rc_sq_wqe->inv_key_immtdata = send_ieth(wr);
   316	
   317				roce_set_bit(rc_sq_wqe->byte_4,
   318					     V2_RC_SEND_WQE_BYTE_4_FENCE_S,
   319					     (wr->send_flags & IB_SEND_FENCE) ? 1 : 0);
   320	
   321				roce_set_bit(rc_sq_wqe->byte_4,
   322					  V2_RC_SEND_WQE_BYTE_4_SE_S,
   323					  (wr->send_flags & IB_SEND_SOLICITED) ? 1 : 0);
   324	
   325				roce_set_bit(rc_sq_wqe->byte_4,
   326					   V2_RC_SEND_WQE_BYTE_4_CQE_S,
   327					   (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
   328	
   329				roce_set_bit(rc_sq_wqe->byte_4,
   330					     V2_RC_SEND_WQE_BYTE_4_OWNER_S, owner_bit);
   331	
   332				switch (wr->opcode) {
   333				case IB_WR_RDMA_READ:
   334					roce_set_field(rc_sq_wqe->byte_4,
   335						       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   336						       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   337						       HNS_ROCE_V2_WQE_OP_RDMA_READ);
   338					rc_sq_wqe->rkey =
   339						cpu_to_le32(rdma_wr(wr)->rkey);
   340					rc_sq_wqe->va =
   341						cpu_to_le64(rdma_wr(wr)->remote_addr);
   342					break;
   343				case IB_WR_RDMA_WRITE:
   344					roce_set_field(rc_sq_wqe->byte_4,
   345						       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   346						       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   347						       HNS_ROCE_V2_WQE_OP_RDMA_WRITE);
   348					rc_sq_wqe->rkey =
   349						cpu_to_le32(rdma_wr(wr)->rkey);
   350					rc_sq_wqe->va =
   351						cpu_to_le64(rdma_wr(wr)->remote_addr);
   352					break;
   353				case IB_WR_RDMA_WRITE_WITH_IMM:
   354					roce_set_field(rc_sq_wqe->byte_4,
   355					       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   356					       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   357					       HNS_ROCE_V2_WQE_OP_RDMA_WRITE_WITH_IMM);
   358					rc_sq_wqe->rkey =
   359						cpu_to_le32(rdma_wr(wr)->rkey);
   360					rc_sq_wqe->va =
   361						cpu_to_le64(rdma_wr(wr)->remote_addr);
   362					break;
   363				case IB_WR_SEND:
   364					roce_set_field(rc_sq_wqe->byte_4,
   365						       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   366						       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   367						       HNS_ROCE_V2_WQE_OP_SEND);
   368					break;
   369				case IB_WR_SEND_WITH_INV:
   370					roce_set_field(rc_sq_wqe->byte_4,
   371					       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   372					       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   373					       HNS_ROCE_V2_WQE_OP_SEND_WITH_INV);
   374					break;
   375				case IB_WR_SEND_WITH_IMM:
   376					roce_set_field(rc_sq_wqe->byte_4,
   377						      V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   378						      V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   379						      HNS_ROCE_V2_WQE_OP_SEND_WITH_IMM);
   380					break;
   381				case IB_WR_LOCAL_INV:
   382					roce_set_field(rc_sq_wqe->byte_4,
   383						       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   384						       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   385						       HNS_ROCE_V2_WQE_OP_LOCAL_INV);
   386					break;
   387				case IB_WR_ATOMIC_CMP_AND_SWP:
   388					roce_set_field(rc_sq_wqe->byte_4,
   389						  V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   390						  V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   391						  HNS_ROCE_V2_WQE_OP_ATOM_CMP_AND_SWAP);
   392					break;
   393				case IB_WR_ATOMIC_FETCH_AND_ADD:
   394					roce_set_field(rc_sq_wqe->byte_4,
   395						 V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   396						 V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   397						 HNS_ROCE_V2_WQE_OP_ATOM_FETCH_AND_ADD);
   398					break;
   399				case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
   400					roce_set_field(rc_sq_wqe->byte_4,
   401					      V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   402					      V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   403					      HNS_ROCE_V2_WQE_OP_ATOM_MSK_CMP_AND_SWAP);
   404					break;
   405				case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
   406					roce_set_field(rc_sq_wqe->byte_4,
   407					     V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   408					     V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   409					     HNS_ROCE_V2_WQE_OP_ATOM_MSK_FETCH_AND_ADD);
   410					break;
   411				default:
   412					roce_set_field(rc_sq_wqe->byte_4,
   413						       V2_RC_SEND_WQE_BYTE_4_OPCODE_M,
   414						       V2_RC_SEND_WQE_BYTE_4_OPCODE_S,
   415						       HNS_ROCE_V2_WQE_OP_MASK);
   416					break;
   417				}
   418	
   419				wqe += sizeof(struct hns_roce_v2_rc_send_wqe);
   420				dseg = wqe;
   421	
   422				ret = set_rwqe_data_seg(ibqp, wr, rc_sq_wqe, wqe,
   423							&sge_ind, bad_wr);
   424				if (ret)
   425					goto out;
   426				ind++;
   427			} else {
   428				dev_err(dev, "Illegal qp_type(0x%x)\n", ibqp->qp_type);
   429				spin_unlock_irqrestore(&qp->sq.lock, flags);
   430				return -EOPNOTSUPP;
   431			}
   432		}
   433	
   434	out:
   435		if (likely(nreq)) {
   436			qp->sq.head += nreq;
   437			/* Memory barrier */
   438			wmb();
   439	
   440			sq_db.byte_4 = 0;
   441			sq_db.parameter = 0;
   442	
   443			roce_set_field(sq_db.byte_4, V2_DB_BYTE_4_TAG_M,
   444				       V2_DB_BYTE_4_TAG_S, qp->doorbell_qpn);
   445			roce_set_field(sq_db.byte_4, V2_DB_BYTE_4_CMD_M,
   446				       V2_DB_BYTE_4_CMD_S, HNS_ROCE_V2_SQ_DB);
   447			roce_set_field(sq_db.parameter, V2_DB_PARAMETER_CONS_IDX_M,
   448				       V2_DB_PARAMETER_CONS_IDX_S,
   449				       qp->sq.head & ((qp->sq.wqe_cnt << 1) - 1));
   450			roce_set_field(sq_db.parameter, V2_DB_PARAMETER_SL_M,
   451				       V2_DB_PARAMETER_SL_S, qp->sl);
   452	
   453			hns_roce_write64_k((__be32 *)&sq_db, qp->sq.db_reg_l);
   454	
   455			qp->sq_next_wqe = ind;
   456			qp->next_sge = sge_ind;
   457		}
   458	
   459		spin_unlock_irqrestore(&qp->sq.lock, flags);
   460	
   461		return ret;
   462	}
   463	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
