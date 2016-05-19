From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] IB/hfi1: Fix sdma_event_names[] build warning
Date: Thu, 19 May 2016 05:21:37 -0700
Message-ID: <20160519122136.30706.36989.stgit@scvm10.sc.intel.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

sdma_event_names[] is only used within CONFIG_SDMA_VERBOSITY ifdefs, so
when CONFIG_SDMA_VERBOSITY is disabled, it results in the following
0-day build warning:
>> drivers/infiniband/hw/hfi1/sdma.c:137:27: warning: 'sdma_event_names'
>> defined but not used [-Wunused-const-variable=]
    static const char * const sdma_event_names[] = {
                              ^~~~~~~~~~~~~~~~
This occurs on the following compiler:
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430

For more information check:
https://lists.01.org/pipermail/kbuild-all/2016-May/020060.html

Fix this warning by defining sdma_event_name[] only within the
CONFIG_SDMA_VERBOSITY ifdefs.

Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index e938017..f9befc0 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -134,6 +134,7 @@ static const char * const sdma_state_names[] = {
 	[sdma_state_s99_running]                = "s99_Running",
 };
 
+#ifdef CONFIG_SDMA_VERBOSITY
 static const char * const sdma_event_names[] = {
 	[sdma_event_e00_go_hw_down]   = "e00_GoHwDown",
 	[sdma_event_e10_go_hw_start]  = "e10_GoHwStart",
@@ -150,6 +151,7 @@ static const char * const sdma_event_names[] = {
 	[sdma_event_e85_link_down]    = "e85_LinkDown",
 	[sdma_event_e90_sw_halted]    = "e90_SwHalted",
 };
+#endif
 
 static const struct sdma_set_state_action sdma_action_table[] = {
 	[sdma_state_s00_hw_down] = {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
