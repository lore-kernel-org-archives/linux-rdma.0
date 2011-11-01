From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm: Fix typo in routing section in man page
 and doc
Date: Tue, 01 Nov 2011 08:37:55 -0400
Message-ID: <4EAFE823.1000100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/current-routing.txt |    2 +-
 man/opensm.8.in         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/current-routing.txt b/doc/current-routing.txt
index f97bc3f..ae2c65f 100644
--- a/doc/current-routing.txt
+++ b/doc/current-routing.txt
@@ -69,7 +69,7 @@ a decision is made as to what port should be used to get to that LID.
    This step is common to standard and Up/Down routing. Each port has a
 counter counting the number of target LIDs going through it.
    When there are multiple alternative ports with same MinHop to a LID,
-the one with less previously assigned ports is selected.
+the one with less previously assigned LIDs is selected.
    If LMC > 0, more checks are added: Within each group of LIDs assigned to
 same target port,
    a. use only ports which have same MinHop
diff --git a/man/opensm.8.in b/man/opensm.8.in
index 042bee3..029e3b8 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -756,7 +756,7 @@ decision is made as to what port should be used to get to that LID.
    This step is common to standard and Up/Down routing. Each port has a
 counter counting the number of target LIDs going through it.
    When there are multiple alternative ports with same MinHop to a LID,
-the one with less previously assigned ports is selected.
+the one with less previously assigned LIDs is selected.
    If LMC > 0, more checks are added: Within each group of LIDs assigned to
 same target port,
    a. use only ports which have same MinHop
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
