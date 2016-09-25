From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] IB/hfi1: Document new sysfs entries for hfi1 driver
Date: Sun, 25 Sep 2016 07:44:51 -0700
Message-ID: <20160925144449.12088.81828.stgit@scvm10.sc.intel.com>
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

This patch adds description for the sdma engine related sysfs entries
for the HFI1 driver.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/infiniband/sysfs.txt |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/infiniband/sysfs.txt b/Documentation/infiniband/sysfs.txt
index 45bcafe..77570d1 100644
--- a/Documentation/infiniband/sysfs.txt
+++ b/Documentation/infiniband/sysfs.txt
@@ -89,6 +89,36 @@ HFI1
    nctxts - number of allowed contexts (PSM2)
    chip_reset - diagnostic (root only)
    boardversion - board version
+
+   sdma<N>/ - one directory per sdma engine (0 - 15)
+	sdma<N>/cpu_list - read-write, list of cpus for user-process to sdma
+			   engine assignment.
+	sdma<N>/vl - read-only, vl the sdma engine maps to.
+
+	The new interface will give the user control on the affinity settings
+	for the hfi1 device.
+	As an example, to set an sdma engine irq affinity and thread affinity
+	of a user processes to use the sdma engine, which is "near" in terms
+	of NUMA configuration, or physical cpu location, the user will do:
+
+	echo "3" > /proc/irq/<N>/smp_affinity_list
+	echo "4-7" > /sys/devices/.../sdma3/cpu_list
+	cat /sys/devices/.../sdma3/vl
+	0
+	echo "8" > /proc/irq/<M>/smp_affinity_list
+	echo "9-12" > /sys/devices/.../sdma4/cpu_list
+	cat /sys/devices/.../sdma4/vl
+	1
+
+	to make sure that when a process runs on cpus 4,5,6, or 7,
+	and uses vl=0, then sdma engine 3 is selected by the driver,
+	and also the interrupt of the sdma engine 3 is steered to cpu 3.
+	Similarly, when a process runs on cpus 9,10,11, or 12 and sets vl=1,
+	then engine 4 will be selected and the irq of the sdma engine 4 is
+	steered to cpu 8.
+	This assumes that in the above N is the irq number of "sdma3",
+	and M is irq number of "sdma4" in the /proc/interrupts file.
+
    ports/1/
           CCMgtA/
                cc_settings_bin - CCA tables used by PSM2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
