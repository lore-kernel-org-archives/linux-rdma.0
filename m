From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V2] infiniband-diags/ibqueryerrors: Fix realloc size to
 prevent core
Date: Tue, 3 Nov 2009 16:46:52 -0800
Message-ID: <20091103164652.78f1100a.weiny2@llnl.gov>
References: <20091103132003.112e10b0.weiny2@llnl.gov>
	<1257284362.580.59.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1257284362.580.59.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 03 Nov 2009 13:39:22 -0800
Al Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Need to check for NULL?  Manpage says its possible:

Good idea; V2 below,
Ira


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 13:19:33 -0800
Subject: [PATCH] infiniband-diags/ibqueryerrors: Fix realloc size to prevent core

	Realloc size was wrong causing a core when enough errors were
	suppressed.  Reproduced by running:

	ibqueryerrors -c -s RcvSwRelayErrors,LinkDowned,VL15Dropped,XmtWait,SymbolErrors,LinkRecovers,RcvErrors

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f83f29e..2b5f63f 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -381,7 +381,11 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 static void add_suppressed(enum MAD_FIELDS field)
 {
-	suppressed_fields = realloc(suppressed_fields, sizeof(enum MAD_FIELDS));
+	suppressed_fields = realloc(suppressed_fields,
+				    (sup_total+1)*sizeof(enum MAD_FIELDS));
+	if (!suppressed_fields)
+		IBERROR("realloc failed");
+
 	suppressed_fields[sup_total] = field;
 	sup_total++;
 }
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
