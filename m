From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: clarification on the mlx4 CQE structure
Date: Tue, 19 Jan 2010 14:19:54 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1001191416160.22919@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny, looking on commit f780a9f "mlx4_core: Add ethernet fields
to CQE struct" I see the following two changes:

@@ -692,14 +692,13 @@ repoll:
-		wc->sl		   = cqe->sl >> 4;
+		wc->sl		   = be16_to_cpu(cqe->sl_vid >> 12);

I wasn't sure if/why a conversion from network order to host order is
neeed here, can you clarify that?

Or.


@@ -39,17 +39,18 @@
 struct mlx4_cqe {
-	__be32			my_qpn;
+	__be32			vlan_my_qpn;
-	u8			sl;
-	u8			reserved1;
+	__be16			sl_vid;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
