From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] RDMA/bnxt_re: Add bnxt_re RoCE driver
Date: Thu, 28 Sep 2017 13:42:28 +0300
Message-ID: <20170928104227.rbpmr456v6syrswu@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Selvin Xavier,

The patch 1ac5a4047975: "RDMA/bnxt_re: Add bnxt_re RoCE driver" from
Feb 10, 2017, leads to the following static checker warning:

drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:95 __send_message() warn: test_bit() takes a bit number
drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:104 __send_message() warn: test_bit() takes a bit number
drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:110 __send_message() warn: test_bit() takes a bit number
drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:232 bnxt_qplib_rcfw_send_message() warn: test_bit() takes a bit number
drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:430 bnxt_qplib_deinit_rcfw() warn: test_bit() takes a bit number
drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:524 bnxt_qplib_init_rcfw() warn: test_bit() takes a bit number


drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
   164          unsigned long           flags;
   165  #define FIRMWARE_INITIALIZED_FLAG       BIT(0)
   166  #define FIRMWARE_FIRST_FLAG             BIT(31)
   167  #define FIRMWARE_TIMED_OUT              BIT(3)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Defined here.

   168          wait_queue_head_t       waitq;

drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
    81  static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
    82                            struct creq_base *resp, void *sb, u8 is_block)
    83  {
    84          struct bnxt_qplib_cmdqe *cmdqe, **cmdq_ptr;
    85          struct bnxt_qplib_hwq *cmdq = &rcfw->cmdq;
    86          struct bnxt_qplib_crsq *crsqe;
    87          u32 sw_prod, cmdq_prod;
    88          unsigned long flags;
    89          u32 size, opcode;
    90          u16 cookie, cbit;
    91          int pg, idx;
    92          u8 *preq;
    93  
    94          opcode = req->opcode;
    95          if (!test_bit(FIRMWARE_INITIALIZED_FLAG, &rcfw->flags) &&
                              ^^^^^^^^^^^^^^^^^^^^^^^^^
We're actually testing "1 << BIT(0)" here.  Which is fine because we
do it consistently and because it happens to not overlap with any of the
other flags and because we don't use "test_bit(FIRMWARE_FIRST_FLAG ...".
But it's not the right way to use this function.

    96              (opcode != CMDQ_BASE_OPCODE_QUERY_FUNC &&
    97               opcode != CMDQ_BASE_OPCODE_INITIALIZE_FW)) {
    98                  dev_err(&rcfw->pdev->dev,
    99                          "QPLIB: RCFW not initialized, reject opcode 0x%x",
   100                          opcode);
   101                  return -EINVAL;
   102          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
