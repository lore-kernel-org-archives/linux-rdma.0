From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 189031] New: Function mlx4_ib_query_device() does not set error
 codes on some failures
Date: Fri, 25 Nov 2016 11:18:36 +0000
Message-ID: <bug-189031-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=189031

            Bug ID: 189031
           Summary: Function mlx4_ib_query_device() does not set error
                    codes on some failures
           Product: Drivers
           Version: 2.5
    Kernel Version: linux-4.9-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bianpan2010-AvrBmmDjM4YnDS1+zs4M5A@public.gmane.org
        Regression: No

Functions kzalloc() and kmalloc() return NULL pointers if there is no enough
memory. They are called in the function mlx4_ib_query_device() defined in file
drivers/infiniband/hw/mlx4/main.c. If they return NULL pointers (see line 458),
function mlx4_ib_query_device() returns variable err. Because variable err is
checked at line 444, the value of err may be 0 when kzalloc() and kmalloc() are
called. As a result, 0 (indicates success) may be returned even on failures.
Though these errors may occur rarely, I think it is better to set correct error
code (e.g. -ENOMEM) when kzalloc() and kmalloc() returns NULL pointers. Codes
related to this bug are summarised as follows.

mlx4_ib_query_device @@ drivers/infiniband/hw/mlx4/main.c
 426 static int mlx4_ib_query_device(struct ib_device *ibdev,
 427                 struct ib_device_attr *props,
 428                 struct ib_udata *uhw)
 429 {
 430     struct mlx4_ib_dev *dev = to_mdev(ibdev);
 431     struct ib_smp *in_mad  = NULL;
 432     struct ib_smp *out_mad = NULL;
 433     int err = -ENOMEM;
         ...
 439     if (uhw->inlen) {
 440         if (uhw->inlen < sizeof(cmd))
 441             return -EINVAL;
 442 
 443         err = ib_copy_from_udata(&cmd, uhw, sizeof(cmd));
 444         if (err)
 445             return err;
 446 
 447         if (cmd.comp_mask)
 448             return -EINVAL;
 449 
 450         if (cmd.reserved)
 451             return -EINVAL;
 452     }
 453 
 454     resp.response_length = offsetof(typeof(resp), response_length) +
 455         sizeof(resp.response_length);
 456     in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 457     out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 458     if (!in_mad || !out_mad)
             // The value of err may be 0. Insert "err = -ENOMEM;" ?
 459         goto out;
         ...
 567 out:
 568     kfree(in_mad);
 569     kfree(out_mad);
 570 
 571     return err;
 572 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
