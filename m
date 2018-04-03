From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v5 3/3] RDMA/qedr: eliminate duplicate barriers on
 weakly-ordered archs #2
Date: Mon, 2 Apr 2018 22:29:53 -0400
Message-ID: <ac46b4e4-7e6c-c15f-06eb-01b1e4893d50@codeaurora.org>
References: <1521736009-23387-1-git-send-email-okaya@codeaurora.org>
 <1521736009-23387-4-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521736009-23387-4-git-send-email-okaya@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/22/2018 12:26 PM, Sinan Kaya wrote:
> @@ -860,7 +860,7 @@ static void doorbell_cq(struct qedr_cq *cq, u32 cons, u8 flags)
>  	wmb();
>  	cq->db.data.agg_flags = flags;
>  	cq->db.data.value = cpu_to_le32(cons);
> -	writeq(cq->db.raw, cq->db_addr);
> +	writeq_relaxed(cq->db.raw, cq->db_addr);

Given the direction to get rid of wmb() in front of writeX() functions, I have been
reviewing this code. Under normal circumstances, I can get rid of all wmb() as follows.

However, I started having my doubts now. Are these wmb() used as a SMP barrier too?
I can't find any smp_Xmb() in drivers/infiniband/hw/qedr directory.

static void doorbell_cq(struct qedr_cq *cq, u32 cons, u8 flags)
 {
-       /* Flush data before signalling doorbell */
-       wmb();
        cq->db.data.agg_flags = flags;
        cq->db.data.value = cpu_to_le32(cons);
        writeq(cq->db.raw, cq->db_addr);
@@ -1870,8 +1868,7 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
                         */

                        if (rdma_protocol_roce(&dev->ibdev, 1)) {
-                               wmb();
-                               writel_relaxed(qp->rq.db_data.raw, qp->rq.db);
+                               writel(qp->rq.db_data.raw, qp->rq.db);
                                /* Make sure write takes effect */
                                mmiowb();
                        }
@@ -3275,8 +3272,7 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
         * unchanged). For performance reasons we avoid checking for this
         * redundant doorbell.
         */
-       wmb();
-       writel_relaxed(qp->sq.db_data.raw, qp->sq.db);
+       writel(qp->sq.db_data.raw, qp->sq.db);

        /* Make sure write sticks */
        mmiowb();
@@ -3362,9 +3358,6 @@ int qedr_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,

                qedr_inc_sw_prod(&qp->rq);

-               /* Flush all the writes before signalling doorbell */
-               wmb();





-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
