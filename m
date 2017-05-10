From: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: NULL required to terminate attr array
Date: Wed, 10 May 2017 08:40:30 -0500
Message-ID: <20170510134030.GA28309@oc1783850105.ibm.com>
References: <20170509210907.GA29717@oc1783850105.ibm.com>
 <20170510053543.GA1839@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170510053543.GA1839-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This patch fixes a kernel panic when loading the hfi driver as a dynamic module.Addressing this patch will make performance tweaking the driver as a loadable module possible.

git diff | scripts/checkpatch.pl
total: 0 errors, 0 warnings, 9 lines checked

Your patch has no obvious style problems and is ready for submission.

Signed-off-by: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

 drivers/infiniband/hw/hfi1/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sys
index 50d140d..2f3bbca 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -196,7 +196,8 @@ static ssize_t cc_attr_store(struct kobject *kobj, struct at
 };

 static struct attribute *port_cc_default_attributes[] = {
-       &cc_prescan_attr.attr
+       &cc_prescan_attr.attr,
+       NULL
 };

 static struct kobj_type port_cc_ktype = {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
