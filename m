From: Steve Wise <larrystevenwise@gmail.com>
Subject: [PATCH v3 iproute2-next 1/4] Add .mailmap file
Date: Wed,  3 Apr 2019 12:10:29 -0500
Message-ID: <117ec8d5d01aa70fff44c515d9525bc21291cc04.1554304142.git.larrystevenwise@gmail.com>
References: <cover.1554304142.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1554304142.git.larrystevenwise@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: Steve Wise <larrystevenwise@gmail.com>, leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

.mailmap allows tracking multiple email addresses to the proper user name.

Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 .mailmap | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 .mailmap

diff --git a/.mailmap b/.mailmap
new file mode 100644
index 00000000..c012d3d0
--- /dev/null
+++ b/.mailmap
@@ -0,0 +1,8 @@
+#
+# This list is used by git-shortlog to fix a few botched name translations
+# in the git archive, either because the author's full name was messed up
+# and/or not always written the same way, making contributions from the
+# same person appearing not to be so or badly displayed.
+#
+Steve Wise <larrystevenwise@gmail.com> <swise@opengridcomputing.com>
+Steve Wise <larrystevenwise@gmail.com> <swise@chelsio.com>
-- 
2.20.1
