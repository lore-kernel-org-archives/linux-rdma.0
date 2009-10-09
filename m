From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting IB path
Date: Fri, 9 Oct 2009 14:48:03 -0700
Message-ID: <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F0EFC2D8E6A340D48497497670C5969C-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before spending any more time on this patch series, is there any disagreement to
accepting this patch (as is or slightly modified) upstream?

- Sean

>Export rdma_set_ib_paths to user space to allow applications to
>manually set the IB path used for connections.  This allows
>alternative ways for a user space application or library to obtain
>path record information, including retrieving path information
>from cached data, avoiding direct interaction with the IB SA.
>The IB SA is a single, centralized entity that can limit scaling
>on large clusters running MPI applications.
>
>Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>---
>I'd like to get feedback on this approach with the possibility of merging
>for 2.6.33.
>
> drivers/infiniband/core/ucma.c |   40 ++++++++++++++++++++++++++++++++++++++++
> include/rdma/rdma_user_cm.h    |    7 +++++--
> 2 files changed, 45 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
>index 4346a24..1359727 100644
>--- a/drivers/infiniband/core/ucma.c
>+++ b/drivers/infiniband/core/ucma.c
>@@ -42,6 +42,7 @@
> #include <rdma/rdma_user_cm.h>
> #include <rdma/ib_marshall.h>
> #include <rdma/rdma_cm.h>
>+#include <rdma/rdma_cm_ib.h>
>
> MODULE_AUTHOR("Sean Hefty");
> MODULE_DESCRIPTION("RDMA Userspace Connection Manager Access");
>@@ -811,6 +812,42 @@ static int ucma_set_option_id(struct ucma_context *ctx,
>int optname,
> 	return ret;
> }
>
>+static int ucma_set_ib_path(struct ucma_context *ctx,
>+			    struct ib_user_path_rec *upath, size_t optlen)
>+{
>+	struct ib_sa_path_rec sa_path;
>+	struct rdma_cm_event event;
>+	int ret;
>+
>+	if (optlen != sizeof(*upath))
>+		return -EINVAL;
>+
>+	ib_copy_path_rec_from_user(&sa_path, upath);
>+	ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
>+	if (ret)
>+		return ret;
>+
>+	memset(&event, 0, sizeof event);
>+	event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
>+	return ucma_event_handler(ctx->cm_id, &event);
>+}
>+
>+static int ucma_set_option_ib(struct ucma_context *ctx, int optname,
>+			      void *optval, size_t optlen)
>+{
>+	int ret;
>+
>+	switch (optname) {
>+	case RDMA_OPTION_IB_PATH:
>+		ret = ucma_set_ib_path(ctx, optval, optlen);
>+		break;
>+	default:
>+		ret = -ENOSYS;
>+	}
>+
>+	return ret;
>+}
>+
> static int ucma_set_option_level(struct ucma_context *ctx, int level,
> 				 int optname, void *optval, size_t optlen)
> {
>@@ -820,6 +857,9 @@ static int ucma_set_option_level(struct ucma_context *ctx,
>int level,
> 	case RDMA_OPTION_ID:
> 		ret = ucma_set_option_id(ctx, optname, optval, optlen);
> 		break;
>+	case RDMA_OPTION_IB:
>+		ret = ucma_set_option_ib(ctx, optname, optval, optlen);
>+		break;
> 	default:
> 		ret = -ENOSYS;
> 	}
>diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
>index c557054..d7829f4 100644
>--- a/include/rdma/rdma_user_cm.h
>+++ b/include/rdma/rdma_user_cm.h
>@@ -215,12 +215,15 @@ struct rdma_ucm_event_resp {
>
> /* Option levels */
> enum {
>-	RDMA_OPTION_ID		= 0
>+	RDMA_OPTION_ID		= 0,
>+	RDMA_OPTION_IB		= 1
> };
>
> /* Option details */
> enum {
>-	RDMA_OPTION_ID_TOS	= 0
>+	RDMA_OPTION_ID_TOS	= 0,
>+
>+	RDMA_OPTION_IB_PATH	= 1
> };
>
> struct rdma_ucm_set_option {
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
