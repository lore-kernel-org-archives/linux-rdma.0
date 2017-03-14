From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/hns: Fix the bug when free mr
Date: Tue, 14 Mar 2017 16:39:29 +0300
Message-ID: <20170314133929.GA31861@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Shaobo Xu,

The patch bfcc681bd09d: "IB/hns: Fix the bug when free mr" from Nov
29, 2016, leads to the following static checker warning:

	drivers/infiniband/hw/hns/hns_roce_hw_v1.c:909 hns_roce_v1_recreate_lp_qp()
	error: potential null dereference 'lp_qp_work'.  (kzalloc returns null)

drivers/infiniband/hw/hns/hns_roce_hw_v1.c
   891  static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
   892  {
   893          struct device *dev = &hr_dev->pdev->dev;
   894          struct hns_roce_recreate_lp_qp_work *lp_qp_work;
   895          struct hns_roce_free_mr *free_mr;
   896          struct hns_roce_v1_priv *priv;
   897          struct completion comp;
   898          unsigned long end =
   899            msecs_to_jiffies(HNS_ROCE_V1_RECREATE_LP_QP_TIMEOUT_MSECS) + jiffies;
   900  
   901          priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
   902          free_mr = &priv->free_mr;
   903  
   904          lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
                ^^^^^^^^^^^^^^^^^^^^
Not checked.

   905                               GFP_KERNEL);
   906  
   907          INIT_WORK(&(lp_qp_work->work), hns_roce_v1_recreate_lp_qp_work_fn);
   908  
   909          lp_qp_work->ib_dev = &(hr_dev->ib_dev);
   910          lp_qp_work->comp = &comp;
   911          lp_qp_work->comp_flag = 1;
   912  
   913          init_completion(lp_qp_work->comp);
   914  
   915          queue_work(free_mr->free_mr_wq, &(lp_qp_work->work));
   916  
   917          while (time_before_eq(jiffies, end)) {
   918                  if (try_wait_for_completion(&comp))
   919                          return 0;
   920                  msleep(HNS_ROCE_V1_RECREATE_LP_QP_WAIT_VALUE);
   921          }


regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
