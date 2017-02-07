From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch 2/2 v2] IB/rxe: Fix mem_check_range integer overflow
Date: Tue, 7 Feb 2017 16:45:19 +0300
Message-ID: <20170207134431.GK11103@mwanda>
References: <8892e1d1-84ba-489b-d118-3599b9b50b0f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8892e1d1-84ba-489b-d118-3599b9b50b0f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Update the range check to avoid integer-overflow in edge case.
Resolves CVE 2016-8636.

Signed-off-by: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v2: I completely misread Eyal's first patch.

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 8cf38b253c37..37eea7441ca4 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -59,9 +59,11 @@ int mem_check_range(struct rxe_mem *mem, u64 iova, size_t length)
 
 	case RXE_MEM_TYPE_MR:
 	case RXE_MEM_TYPE_FMR:
-		return ((iova < mem->iova) ||
-			((iova + length) > (mem->iova + mem->length))) ?
-			-EFAULT : 0;
+		if (iova < mem->iova ||
+		    length > mem->length ||
+		    iova > mem->iova + mem->length - length)
+			return -EFAULT;
+		return 0;
 
 	default:
 		return -EFAULT;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
