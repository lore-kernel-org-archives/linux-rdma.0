From: dann frazier <dann.frazier-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] perftest: Fix typos in s390x support
Date: Fri, 12 Feb 2016 08:38:29 -0700
Message-ID: <1455291509-24868-1-git-send-email-dann.frazier@canonical.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 472171fbd5a8 added support for s390x systems, but it looks like the
changeset got corrupted between submit and commit, resulting in a compile
failure. The version on the mailing list looks fine:

    http://www.spinics.net/lists/linux-rdma/msg19592.html

Signed-off-by: dann frazier <dann.frazier-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 README          | 2 +-
 src/get_clock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 935379f..0447e7f 100644
--- a/README
+++ b/README
@@ -237,7 +237,7 @@ Special feature detailed explanation in tests:
     ./configure --disable-verbs_exp
     make
 
- 6. In te x390x platform virtualized environment the results shown by package test applications can be incorrect.
+ 6. In the s390x platform virtualized environment the results shown by package test applications can be incorrect.
 
  7. perftest-2.3 release includes support for dualport VPI test - port1-Ethernet , port2-IB. (in addition to Eth:Eth, IB:IB)
     Currently, running dualport when port1-IB , port2-Ethernet still not working.
diff --git a/src/get_clock.c b/src/get_clock.c
index 9b0c23e..fd27be1 100755
--- a/src/get_clock.c
+++ b/src/get_clock.c
@@ -201,7 +201,7 @@ static double proc_get_cpu_mhz(int no_cpu_freq_warn)
 double get_cpu_mhz(int no_cpu_freq_warn)
 {
 	#ifdef __s390x__
-	return sample_get_cpu_mgz();
+	return sample_get_cpu_mhz();
 	#else
 	double sample, proc, delta;
 	sample = sample_get_cpu_mhz();
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
