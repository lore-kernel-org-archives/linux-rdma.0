From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 188831] New: Function ocrdma_mbx_create_ah_tbl() does not set
 error code when the call to dma_alloc_coherent() fails
Date: Fri, 25 Nov 2016 11:01:59 +0000
Message-ID: <bug-188831-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188831

            Bug ID: 188831
           Summary: Function ocrdma_mbx_create_ah_tbl() does not set error
                    code when the call to dma_alloc_coherent() fails
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

Function dma_alloc_coherent() returns a NULL pointer if there is no enough
memory. Function ocrdma_mbx_create_ah_tbl() defined in file
drivers/infiniband/hw/ocrdma/ocrdma_hw.c will return 0 on success or negative
error codes on failures. It calls function dma_alloc_coherent() twice and
checks the return values against NULL (at lines 1681 and 1686). The control
flow jumps to label "mem_err_ah" and returns the value of variable status. The
value of status is 0 (see the check of variable status at line 1645). As a
result, the caller of ocrdma_mbx_create_ah_tbl() will be misled to believe all
goes well even the memory allocation fails. Maybe it is better to assign
"-ENOMEM" to variable status before the jump instructions at lines 1682 and
1687, or simply initialize status with "-ENOMEM" rather than "0" at line 1645.
Codes related to this bug are summarised as follows.

ocrdma_mbx_create_ah_tbl @@ drivers/infiniband/hw/ocrdma/ocrdma_hw.c
1642 static int ocrdma_mbx_create_ah_tbl(struct ocrdma_dev *dev)
1643 {
1644     int i;
1645     int status = 0;  // use "int status = -ENOMEM;" ?
         ...
1653     cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_AH_TBL, sizeof(*cmd));
1654     if (!cmd)
1655         return status;
         ...
1678     dev->av_tbl.pbl.va = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
1679                         &dev->av_tbl.pbl.pa,
1680                         GFP_KERNEL);
1681     if (dev->av_tbl.pbl.va == NULL)
1682         goto mem_err;
1683 
1684     dev->av_tbl.va = dma_alloc_coherent(&pdev->dev, dev->av_tbl.size,
1685                         &pa, GFP_KERNEL);
1686     if (dev->av_tbl.va == NULL)
1687         goto mem_err_ah;
         ...
1706     return 0;
1707 
1708 mbx_err:
1709     dma_free_coherent(&pdev->dev, dev->av_tbl.size, dev->av_tbl.va,
1710               dev->av_tbl.pa);
1711     dev->av_tbl.va = NULL;
1712 mem_err_ah:
1713     dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->av_tbl.pbl.va,
1714               dev->av_tbl.pbl.pa);
1715     dev->av_tbl.pbl.va = NULL;
1716     dev->av_tbl.size = 0;
1717 mem_err:
1718     kfree(cmd);
1719     return status;
1720 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
