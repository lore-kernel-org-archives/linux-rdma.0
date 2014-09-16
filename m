From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: [PATCH 14/22] ib_srpt: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:28 +0200
Message-ID: <1410900696-6481-15-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410900696-6481-1-git-send-email-linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d28a8c2..7206547 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3574,7 +3574,7 @@ static int srpt_parse_i_port_id(u8 i_port_id[16], const char *name)
 	int ret, rc;
 
 	p = name;
-	if (strnicmp(p, "0x", 2) == 0)
+	if (strncasecmp(p, "0x", 2) == 0)
 		p += 2;
 	ret = -EINVAL;
 	len = strlen(p);
-- 
2.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
