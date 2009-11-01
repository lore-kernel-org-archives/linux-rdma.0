From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm_release_notes-3.3: remove OFED dependency
Date: Sun, 1 Nov 2009 20:43:57 +0200
Message-ID: <20091101184357.GK29434@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Remove OFED (and older friends) from OpenSM software dependencies list,
replace by just IB stack. Also add the mainstream Linux kernel to the
list of qualified stacks.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/doc/opensm_release_notes-3.3.txt |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/opensm/doc/opensm_release_notes-3.3.txt b/opensm/doc/opensm_release_notes-3.3.txt
index 02a110b..9725ad0 100644
--- a/opensm/doc/opensm_release_notes-3.3.txt
+++ b/opensm/doc/opensm_release_notes-3.3.txt
@@ -97,9 +97,10 @@ ced5a6e opensm/opensm/osm_console.c: move reporting of plugins to "status"
 
 1.4 Software Dependencies
 
-OpenSM depends on the installation of either OFED 1.x, OpenIB gen2 (e.g.
-IBG2 distribution), OpenIB gen1 (e.g. IBGD distribution), or Mellanox
-VAPI stacks. The qualified driver versions are provided in Table 2,
+OpenSM depends on the installation of libibumad package (distributed as
+part of OFA IB management together with OpenSM) and IB stack presence,
+in particular libibumad uses user_mad kernel interface ('ib_umad' kernel
+module). The qualified driver versions are provided in Table 2,
 "Qualified IB Stacks".
 
 Also, building of QoS manager policy file parser requires flex, and either
@@ -457,6 +458,7 @@ Table 2 - Qualified IB Stacks
 
 Stack                                    | Version
 -----------------------------------------|--------------------------
+The main stream Linux kernel             |   2.6.x
 OFED                                     |   1.4
 OFED                                     |   1.3
 OFED                                     |   1.2
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
