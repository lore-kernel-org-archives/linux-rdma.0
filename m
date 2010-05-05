From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] ib/iser: remove buggy back-pointer setting
Date: Wed, 5 May 2010 17:30:34 +0300 (IDT)
Message-ID: <Pine.LNX.4.64.1005051730170.29957@zuben.voltaire.com>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1005051726110.29957-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

iscsi connection object life cycle includes binding and unbinding
(conn_stop) to/from the iscsi transport connection object. Since
iscsi connection objects are recycled, on the time the transport
connection (e.g iser's ib connection) is released it is illegal
to touch the iscsi connection tied to the transport back-pointer, as
it may already point to a different transport connection.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -346,8 +346,6 @@ static void iser_conn_release(struct ise
 	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
 	if (device != NULL)
 		iser_device_try_release(device);
-	if (ib_conn->iser_conn)
-		ib_conn->iser_conn->ib_conn = NULL;
 	iscsi_destroy_endpoint(ib_conn->ep);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
