From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 2/4] IB/core: Check mad_agent in ib_unregister_mad_agent before dereferencing it
Date: Thu, 29 Jan 2015 11:14:29 +0200
Message-ID: <1422522871-11216-3-git-send-email-ogerlitz@mellanox.com>
References: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422522871-11216-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When ib_register_mad_agent fails, it returns a pointer with error which is not
NULL, therefore when calling ib_unregister_mad_agent we need to check that the
passed mad_agent is valid and not erroneous.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 74c30f4..8ec811e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -619,6 +619,9 @@ int ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
 	struct ib_mad_agent_private *mad_agent_priv;
 	struct ib_mad_snoop_private *mad_snoop_priv;
 
+	if (IS_ERR(mad_agent))
+		goto out;
+
 	/* If the TID is zero, the agent can only snoop. */
 	if (mad_agent->hi_tid) {
 		mad_agent_priv = container_of(mad_agent,
@@ -631,6 +634,7 @@ int ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
 					      agent);
 		unregister_mad_snoop(mad_snoop_priv);
 	}
+out:
 	return 0;
 }
 EXPORT_SYMBOL(ib_unregister_mad_agent);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
