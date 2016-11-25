From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 188821] New: Function c4iw_rdev_open() does not set error code
 when the call to __get_free_page() fails.
Date: Fri, 25 Nov 2016 11:01:16 +0000
Message-ID: <bug-188821-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188821

            Bug ID: 188821
           Summary: Function c4iw_rdev_open() does not set error code when
                    the call to __get_free_page() fails.
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

Function __get_free_page() returns a NULL pointer if there is no enough memory.
In function c4iw_rdev_open defined in file
drivers/infiniband/hw/cxgb4/device.c, __get_free_page() is called and its
return value is checked against NULL (at line 831). When the return value is
NULL, the control flow jumps to label "destroy_ocqp_pool", and returns the
value of variable err. However, after the check of variable err at line 825,
the value of err must be 0. As a result, 0 (indicates success) may be returned
even when the memory allocation fails. Maybe it is better to assign "-ENOMEM"
to err before the jump instruction at line 832. Codes related to this bug are
summarised as follows.

c4iw_rdev_open @@ drivers/infiniband/hw/cxgb4/device.c
 752 static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 753 {
 754     int err;
         ...
 824     err = c4iw_ocqp_pool_create(rdev);
 825     if (err) {
 826         printk(KERN_ERR MOD "error %d initializing ocqp pool\n", err);
 827         goto destroy_rqtpool;
 828     }
 829     rdev->status_page = (struct t4_dev_status_page *)
 830                 __get_free_page(GFP_KERNEL);
 831     if (!rdev->status_page)
 832         goto destroy_ocqp_pool;  // insert "err = -ENOMEM" before this
line?
         ...
 851     return 0;
 852 destroy_ocqp_pool:
 853     c4iw_ocqp_pool_destroy(rdev);
 854 destroy_rqtpool:
 855     c4iw_rqtpool_destroy(rdev);
 856 destroy_pblpool:
 857     c4iw_pblpool_destroy(rdev);
 858 destroy_resource:
 859     c4iw_destroy_resource(&rdev->resource);
 860     return err;
 861 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
