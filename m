From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/hns: Fix for checkpatch.pl comment style warnings
Date: Thu, 10 Aug 2017 15:14:29 +0300
Message-ID: <20170810121429.srem4m44dhsrl37i@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello oulijun,

The patch 5f110ac4bed8: "IB/hns: Fix for checkpatch.pl comment style
warnings" from Jun 10, 2017, leads to the following static checker
warning:

	drivers/infiniband/hw/hns/hns_roce_hw_v1.c:3562 check_qp_db_process_status()
	warn: inconsistent indenting

drivers/infiniband/hw/hns/hns_roce_hw_v1.c
  3529                                  sdb_retry_cnt = roce_read(hr_dev,
  3530                                                         ROCEE_SDB_RETRY_CNT_REG);
  3531                                  cur_cnt = roce_get_field(sdb_send_ptr,
  3532                                          ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
  3533                                          ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
  3534                                          roce_get_field(sdb_retry_cnt,
  3535                                          ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
  3536                                          ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
  3537                                  if (!roce_get_bit(tsp_st,
  3538                                          ROCEE_CNT_CLR_CE_CNT_CLR_CE_S)) {
  3539                                          old_cnt = roce_get_field(old_send,
  3540                                          ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
  3541                                          ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
  3542                                          roce_get_field(old_retry,
  3543                                          ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
  3544                                          ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
  3545                                          if (cur_cnt - old_cnt > SDB_ST_CMP_VAL)
  3546                                                  success_flags = 1;
  3547                                  } else {
  3548                                          old_cnt = roce_get_field(old_send,
  3549                                          ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
  3550                                          ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S);
  3551                                          if (cur_cnt - old_cnt >
  3552                                              SDB_ST_CMP_VAL) {
  3553                                                  success_flags = 1;
  3554                                          } else {
  3555                                                  send_ptr =
                                                        ^^^^^^^^^^
This line is indented one more level

  3556                                                          roce_get_field(old_send,
  3557                                              ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
  3558                                              ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
  3559                                              roce_get_field(sdb_retry_cnt,
  3560                                              ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
  3561                                              ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
  3562                                              roce_set_field(old_send,
                                                    ^^^^^^^^^^^^^^^^^^^^^^^^
than this line.

But really!  What the heck???  This is so unreadable.  Every single line
is a game of spot the difference.
https://www.google.com/search?q=spot+the+difference+hard&tbm=isch
This is nice as a children's game if you're waiting for food at a
restaurant, but grizzly for if you're trying to read code.

  3563                                              ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
  3564                                              ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S,
  3565                                                  send_ptr);
  3566                                          }
  3567                                  }
  3568                          } while (!success_flags);

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
