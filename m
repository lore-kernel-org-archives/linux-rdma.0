From: Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v2 4/5] rds: Add runchecks.cfg for net/rds
Date: Sat, 16 Dec 2017 15:42:29 +0100
Message-ID: <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Knut Omang <knut.omang@oracle.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

Add a runchecks.cfg to net/rds to start "reining in"
future checker errors, and making it easier to
selectively clean up existing issues.

This runchecks.cfg lets make C=2 M=net/rds
pass with all errors/warnings suppressed

See Documentation/dev-tools/runchecks.rst for
motivation and details.

Signed-off-by: Knut Omang <knut.omang@oracle.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Åsmund Østvold <asmund.ostvold@oracle.com>
---
 net/rds/runchecks.cfg | 76 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+)
 create mode 100644 net/rds/runchecks.cfg

diff --git a/net/rds/runchecks.cfg b/net/rds/runchecks.cfg
new file mode 100644
index 0000000..2a02701
--- /dev/null
+++ b/net/rds/runchecks.cfg
@@ -0,0 +1,76 @@
+#
+# checker suppression lists for net/rds
+#
+# see Documentation/dev-tools/runchecks.rst
+#
+
+checker checkpatch
+##################
+
+# Accept somewhat longer lines:
+line_len 110
+
+# Important to fix from a quality perspective:
+#
+except AVOID_BUG connection.c ib.c ib_cm.c ib_rdma.c ib_recv.c ib_ring.c ib_send.c info.c loop.c message.c
+except AVOID_BUG rdma.c recv.c send.c stats.c tcp_recv.c transport.c
+except MEMORY_BARRIER ib_recv.c send.c tcp_send.c
+except WAITQUEUE_ACTIVE cong.c ib_rdma.c ib_ring.c ib_send.c
+except UNNECESSARY_ELSE bind.c ib_cm.c
+except MACRO_ARG_PRECEDENCE connection.c ib.h rds.h
+except MACRO_ARG_REUSE rds.h
+except ALLOC_SIZEOF_STRUCT cong.c ib.c ib_cm.c loop.c message.c rdma.c
+except UNCOMMENTED_DEFINITION ib_cm.c
+
+# Code simplification:
+#
+except ALLOC_WITH_MULTIPLY ib.c
+except PREFER_PR_LEVEL ib_cm.c ib_recv.c ib_send.c rdma_transport.c threads.c transport.c
+except UNNECESSARY_ELSE ib_fmr.c
+except UNNECESSARY_PARENTHESES ib_rdma.c rdma.c recv.c send.c
+except PRINTK_RATELIMITED ib_frmr.c
+except EMBEDDED_FUNCTION_NAME ib_rdma.c
+
+# Style and readability:
+#
+except BRACES ib_cm.c ib_rdma.c ib_recv.c send.c transport.c
+except OOM_MESSAGE ib.c tcp.c
+except LONG_LINE_STRING ib.c ib_recv.c ib_send.c
+except FUNCTION_ARGUMENTS ib.h ib_mr.h rds.h tcp.h
+except OPEN_ENDED_LINE recv.c ib_recv.c
+
+# Candidates to leave as exceptions (don't fix):
+except MULTIPLE_ASSIGNMENTS ib_send.c
+except LONG_LINE_STRING connection.c
+except OPEN_BRACE connection.c
+
+# These are in most of the source files, ignore for all files:
+#
+pervasive NETWORKING_BLOCK_COMMENT_STYLE BLOCK_COMMENT_STYLE
+
+# These are easily autocorrected by checkpatch with --fix-inplace:
+# Just ignore here - fixed in a separate commit:
+#
+pervasive PREFER_KERNEL_TYPES LINE_SPACING SPACING SPACE_BEFORE_TAB SPLIT_STRING
+pervasive BIT_MACRO SIZEOF_PARENTHESIS LOGICAL_CONTINUATIONS GLOBAL_INITIALISERS
+pervasive ALLOC_WITH_MULTIPLY TABSTOP
+
+# These were easy to fix manually while getting make C=2 to pass.
+# Fixed in a separate commit:
+#
+pervasive SUSPECT_CODE_INDENT PARENTHESIS_ALIGNMENT BRACES PRINTF_L COMPARISON_TO_NULL
+pervasive LOGICAL_CONTINUATIONS
+
+
+checker sparse
+##############
+
+except VLA connection.c
+except COND_ADDRESS_ARRAY connection.c
+except PTR_SUBTRACTION_BLOWS ib_recv.c
+except TYPESIGN ib_frmr.c
+
+# This is coming from linux/dma-mapping.h:
+except RETURN_VOID ib_cm.c
+
+pervasive BITWISE SHADOW
-- 
git-series 0.9.1
