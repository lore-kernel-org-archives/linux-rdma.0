From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/cm: fix device_create() return value check
Date: Thu, 11 Mar 2010 08:25:29 -0800
Message-ID: <076C4D5BB2EE4DAEA01C314A2BFD9E99@amr.corp.intel.com>
References: <1268324248-30394-1-git-send-email-ext-jani.1.nikula@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268324248-30394-1-git-send-email-ext-jani.1.nikula-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jani Nikula' <ext-jani.1.nikula-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>From: Jani Nikula <ext-jani.1.nikula-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>
>
>Use IS_ERR() instead of comparing to NULL.
>
>Signed-off-by: Jani Nikula <ext-jani.1.nikula-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>
>
>---
>
>NOTE: I'm afraid I'm unable to test this; please consider this more a
>bug report than a complete patch.

This looks correct to me.  Good catch.

>---
> drivers/infiniband/core/cm.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>index 764787e..c9730cb 100644
>--- a/drivers/infiniband/core/cm.c
>+++ b/drivers/infiniband/core/cm.c
>@@ -3693,7 +3693,7 @@ static void cm_add_one(struct ib_device *ib_device)
> 	cm_dev->device = device_create(&cm_class, &ib_device->dev,
> 				       MKDEV(0, 0), NULL,
> 				       "%s", ib_device->name);
>-	if (!cm_dev->device) {
>+	if (IS_ERR(cm_dev->device)) {
> 		kfree(cm_dev);
> 		return;
> 	}
>--
>1.6.5.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
