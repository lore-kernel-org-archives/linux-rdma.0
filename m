From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/ib_types.h: Mask off client rereg bit in
	set_client_rereg
Date: Tue, 13 Oct 2009 15:35:49 -0400
Message-ID: <20091013193549.GA14990@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Issue introduced by commit 2d13530a16ab580894d3c2f83536dcf93909f43f

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index 935df43..fb4f79d 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -5315,7 +5315,7 @@ ib_port_info_set_client_rereg(IN ib_port_info_t * const p_pi,
 {
 	CL_ASSERT(client_rereg <= 0x1);
 	p_pi->subnet_timeout =
-	    (uint8_t) (p_pi->subnet_timeout | (client_rereg << 7));
+	    (uint8_t) ((p_pi->subnet_timeout & 0x7F) | (client_rereg << 7));
 }
 
 /*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
