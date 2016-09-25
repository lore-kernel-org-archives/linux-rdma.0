From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] IB/hfi1: Add a new VL sysfs attribute for sdma engines
Date: Sun, 25 Sep 2016 07:44:30 -0700
Message-ID: <20160925144428.12088.80972.stgit@scvm10.sc.intel.com>
References: <20160925144248.12088.71489.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds a read-only "VL" attribute for the sysfs entry of each
sdma engine. It will allow the user to check VL to sdma engine mappings.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/sysfs.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index 836eea5..edba224 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -826,12 +826,25 @@ static ssize_t sde_store_cpu_to_sde_map(struct sdma_engine *sde,
 	return sdma_set_cpu_to_sde_map(sde, buf, count);
 }
 
+static ssize_t sde_show_vl(struct sdma_engine *sde, char *buf)
+{
+	int vl;
+
+	vl = sdma_engine_get_vl(sde);
+	if (vl < 0)
+		return vl;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", vl);
+}
+
 static SDE_ATTR(cpu_list, S_IWUSR | S_IRUGO,
 		sde_show_cpu_to_sde_map,
 		sde_store_cpu_to_sde_map);
+static SDE_ATTR(vl, S_IRUGO, sde_show_vl, NULL);
 
 static struct sde_attribute *sde_attribs[] = {
-	&sde_attr_cpu_list
+	&sde_attr_cpu_list,
+	&sde_attr_vl
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
