From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ofa-general][PATCH 2/4] SRP fail-over faster
Date: Mon, 12 Oct 2009 15:57:07 -0700
Message-ID: <4AD3B443.7040107@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050808080704060904080806"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808080704060904080806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------050808080704060904080806
Content-Type: message/rfc822;
 name="[ofa-general][PATCH 2/4] SRP fail-over faster,.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[ofa-general][PATCH 2/4] SRP fail-over faster,.eml"

Message-ID: <4AD3B1D6.9050507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 12 Oct 2009 15:46:46 -0700
From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: OF General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
CC: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ofa-general][PATCH 2/4] SRP fail-over faster,
Content-Type: multipart/mixed;
 boundary="------------090109010505020904060307"

This is a multi-part message in MIME format.
--------------090109010505020904060307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Disconnect connection without waiting.

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>



--------------090109010505020904060307
Content-Type: text/plain;
 name="srp_2_disconnect_without_wait.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_2_disconnect_without_wait.patch"

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 --
 1 file changed, 2 deletions(-)

Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.c
+++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
@@ -421,7 +421,6 @@ static void srp_disconnect_target(struct
 			     PFX "Sending CM DREQ failed\n");
 		return;
 	}
-	wait_for_completion(&target->done);
 }
 
 static void srp_remove_work(struct work_struct *work)
@@ -1301,7 +1300,6 @@ static int srp_cm_handler(struct ib_cm_i
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
-		comp = 1;
 		target->status = 0;
 		break;
 

--------------090109010505020904060307--


--------------050808080704060904080806--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
