From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH] opensm.spec.in: Add in man5 for torus-2QoS.conf
Date: Thu, 10 Feb 2011 12:53:50 -0700
Message-ID: <1297367630-22898-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm.spec.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm.spec.in b/opensm/opensm.spec.in
index c541804..65e46c9 100644
--- a/opensm/opensm.spec.in
+++ b/opensm/opensm.spec.in
@@ -129,6 +129,7 @@ fi
 %{_sbindir}/opensm
 %{_sbindir}/osmtest
 %{_mandir}/man8/*
+%{_mandir}/man5/*
 %doc AUTHORS COPYING README doc/performance-manager-HOWTO.txt doc/QoS_management_in_OpenSM.txt doc/opensm_release_notes-3.3.txt
 %{_sysconfdir}/init.d/opensmd
 %{_sbindir}/sldd.sh
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
