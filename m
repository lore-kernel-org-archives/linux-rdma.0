From: Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v2 5/5] RDMA/core: Add runchecks.cfg for drivers/infiniband/core
Date: Sat, 16 Dec 2017 15:42:30 +0100
Message-ID: <0ce3c307255b22d23f49d13213b76044647e6f60.1513430008.git-series.knut.omang@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Knut Omang <knut.omang@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>, =?UTF-8?q?=C3=85smund=20=C3=98stvold?= <asmund.ostvold@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Add a runchecks.cfg to drivers/infiniband/core
to start "reining in" future checker errors,
and making it easier to selectively clean up existing
issues.

This runchecks.cfg lets make C=2 M=drivers/infiniband/core
pass with all errors/warnings suppressed

See Documentation/dev-tools/runchecks.rst for
motivation and details.

Signed-off-by: Knut Omang <knut.omang@oracle.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Åsmund Østvold <asmund.ostvold@oracle.com>
---
 drivers/infiniband/core/runchecks.cfg | 83 ++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+)
 create mode 100644 drivers/infiniband/core/runchecks.cfg

diff --git a/drivers/infiniband/core/runchecks.cfg b/drivers/infiniband/core/runchecks.cfg
new file mode 100644
index 0000000..75ca57c
--- /dev/null
+++ b/drivers/infiniband/core/runchecks.cfg
@@ -0,0 +1,83 @@
+#
+# checker suppression lists for drivers/infiniband/core
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
+# Uncategorized:
+#
+except TRAILING_STATEMENTS packer.c
+except NON_OCTAL_PERMISSIONS rw.c
+except STATIC_CONST_CHAR_ARRAY sysfs.c
+except SYMBOLIC_PERMS sysfs.c
+except NEEDLESS_IF sysfs.c
+except NAKED_SSCANF device.c
+except ALLOC_WITH_MULTIPLY fmr_pool.c iwpm_util.c cma.c
+except MULTIPLE_ASSIGNMENTS rw.c verbs.c
+except ALLOC_SIZEOF_STRUCT sysfs.c iwpm_util.c iwpm_msg.c cma.c cm.c iwcm.c
+except LOGICAL_CONTINUATIONS mad.c iwpm_util.c user_mad.c
+
+# Important to fix/go through from a quality perspective:
+#
+except AVOID_BUG rw.c mad.c cm.c iwcm.c cma.c
+except UNCOMMENTED_DEFINITION ucma.c fmr_pool.c multicast.c mad_rmpp.c
+except UNCOMMENTED_DEFINITION ucm.c umem.c cma.c user_mad.c cm.c
+except ASSIGN_IN_IF mad.c cma.c uverbs_ioctl_merge.c
+except SUSPECT_CODE_INDENT iwpm_util.c cma.c uverbs_ioctl.c user_mad.c uverbs_cmd.c
+except COMPLEX_MACRO uverbs_ioctl_merge.c
+except BOOL_COMPARISON roce_gid_mgmt.c
+
+# Code simplification:
+#
+except UNNECESSARY_ELSE cache.c mad.c mad_rmpp.c
+except UNNECESSARY_PARENTHESES cma.c sa_query.c mad.c ucma.c mad_rmpp.c umem.c
+except UNNECESSARY_PARENTHESES user_mad.c uverbs_cmd.c uverbs_marshall.c cm.c
+except EMBEDDED_FUNCTION_NAME mad.c umem.c cma.c ucma.c user_mad.c
+except RETURN_VOID sysfs.c sa_query.c mad.c cma.c ucm.c uverbs_main.c umem.c
+except CONSTANT_COMPARISON smi.c
+except OOM_MESSAGE iwpm_util.c
+
+# Style and readability:
+#
+except OPEN_BRACE cache.c mad.c umem_odp.c umem_rbtree.c cm.c
+except MULTILINE_DEREFERENCE mad.c cm.c cma.c uverbs_main.c
+except LONG_LINE cma.c
+except PARENTHESIS_ALIGNMENT umem.c cm.c
+except FUNCTION_ARGUMENTS verbs.c uverbs_cmd.c sa_query.c sysfs.c
+
+# Candidates to leave as exceptions (don't fix):
+except SPACING umem_rbtree.c
+except MACRO_ARG_REUSE ud_header.c sa_query.c uverbs_ioctl_merge.c
+
+# These are in most of the source files, ignore for all files:
+#
+pervasive BLOCK_COMMENT_STYLE ENOSYS BRACES OPEN_ENDED_LINE
+
+# These are easily autocorrected by checkpatch with --fix-inplace:
+#
+pervasive SIZEOF_PARENTHESIS SPACING LINE_SPACING SPACE_BEFORE_TAB TABSTOP
+pervasive TRAILING_WHITESPACE POINTER_LOCATION INITIALISED_STATIC
+pervasive CODE_INDENT ELSE_AFTER_BRACE SYMBOLIC_PERMS LEADING_SPACE
+pervasive PARENTHESIS_ALIGNMENT COMPARISON_TO_NULL TYPO_SPELLING
+
+checker sparse
+##############
+
+except SHADOW sysfs.c fmr_pool.c user_mad.c uverbs_main.c ucm.c ucma.c
+except RETURN_VOID roce_gid_mgmt.c
+except TYPESIGN ucm.c ucma.c
+
+# From linux/device.h:
+except RETURN_VOID ucm.c
+
+checker checkdoc
+################
+
+except PARAM_DESC verbs.c device.c fmr_pool.c cache.c sa_query.c
+except X_PARAM verbs.c fmr_pool.c cache.c
-- 
git-series 0.9.1
