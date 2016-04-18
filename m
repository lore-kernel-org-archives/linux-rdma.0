From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/12] target: enhance and export target_alloc_sgl/target_free_sgl
Date: Mon, 18 Apr 2016 16:14:20 -0400
Message-ID: <1461010463-6603-10-git-send-email-hch@lst.de>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1461010463-6603-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The SRP target driver will need to allocate and chain it's own SGLs soon.
For this export target_alloc_sgl, and add a new argument to it so that it
can allocate an additional chain entry that doesn't point to a page.  Also
export transport_free_sgl after renaming it to target_free_sgl to free
these SGLs again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/target/target_core_transport.c | 32 ++++++++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  2 +-
 include/target/target_core_backend.h   |  1 -
 include/target/target_core_fabric.h    |  4 ++++
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ab2bf12..590384a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2195,7 +2195,7 @@ queue_full:
 	transport_handle_queue_full(cmd, cmd->se_dev);
 }
 
-static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
+void target_free_sgl(struct scatterlist *sgl, int nents)
 {
 	struct scatterlist *sg;
 	int count;
@@ -2205,6 +2205,7 @@ static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
 
 	kfree(sgl);
 }
+EXPORT_SYMBOL(target_free_sgl);
 
 static inline void transport_reset_sgl_orig(struct se_cmd *cmd)
 {
@@ -2225,7 +2226,7 @@ static inline void transport_reset_sgl_orig(struct se_cmd *cmd)
 static inline void transport_free_pages(struct se_cmd *cmd)
 {
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
-		transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
+		target_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
 		cmd->t_prot_sg = NULL;
 		cmd->t_prot_nents = 0;
 	}
@@ -2236,7 +2237,7 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		 * SG_TO_MEM_NOALLOC to function with COMPARE_AND_WRITE
 		 */
 		if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) {
-			transport_free_sgl(cmd->t_bidi_data_sg,
+			target_free_sgl(cmd->t_bidi_data_sg,
 					   cmd->t_bidi_data_nents);
 			cmd->t_bidi_data_sg = NULL;
 			cmd->t_bidi_data_nents = 0;
@@ -2246,11 +2247,11 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	}
 	transport_reset_sgl_orig(cmd);
 
-	transport_free_sgl(cmd->t_data_sg, cmd->t_data_nents);
+	target_free_sgl(cmd->t_data_sg, cmd->t_data_nents);
 	cmd->t_data_sg = NULL;
 	cmd->t_data_nents = 0;
 
-	transport_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
+	target_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
 	cmd->t_bidi_data_sg = NULL;
 	cmd->t_bidi_data_nents = 0;
 }
@@ -2324,20 +2325,22 @@ EXPORT_SYMBOL(transport_kunmap_data_sg);
 
 int
 target_alloc_sgl(struct scatterlist **sgl, unsigned int *nents, u32 length,
-		 bool zero_page)
+		 bool zero_page, bool chainable)
 {
 	struct scatterlist *sg;
 	struct page *page;
 	gfp_t zero_flag = (zero_page) ? __GFP_ZERO : 0;
-	unsigned int nent;
+	unsigned int nalloc, nent;
 	int i = 0;
 
-	nent = DIV_ROUND_UP(length, PAGE_SIZE);
-	sg = kmalloc(sizeof(struct scatterlist) * nent, GFP_KERNEL);
+	nalloc = nent = DIV_ROUND_UP(length, PAGE_SIZE);
+	if (chainable)
+		nalloc++;
+	sg = kmalloc_array(nalloc, sizeof(struct scatterlist), GFP_KERNEL);
 	if (!sg)
 		return -ENOMEM;
 
-	sg_init_table(sg, nent);
+	sg_init_table(sg, nalloc);
 
 	while (length) {
 		u32 page_len = min_t(u32, length, PAGE_SIZE);
@@ -2361,6 +2364,7 @@ out:
 	kfree(sg);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(target_alloc_sgl);
 
 /*
  * Allocate any required resources to execute the command.  For writes we
@@ -2376,7 +2380,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	if (cmd->prot_op != TARGET_PROT_NORMAL &&
 	    !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
 		ret = target_alloc_sgl(&cmd->t_prot_sg, &cmd->t_prot_nents,
-				       cmd->prot_length, true);
+				       cmd->prot_length, true, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
@@ -2401,13 +2405,13 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 
 			ret = target_alloc_sgl(&cmd->t_bidi_data_sg,
 					       &cmd->t_bidi_data_nents,
-					       bidi_length, zero_flag);
+					       bidi_length, zero_flag, false);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 
 		ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
-				       cmd->data_length, zero_flag);
+				       cmd->data_length, zero_flag, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	} else if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
@@ -2421,7 +2425,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 
 		ret = target_alloc_sgl(&cmd->t_bidi_data_sg,
 				       &cmd->t_bidi_data_nents,
-				       caw_length, zero_flag);
+				       caw_length, zero_flag, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 47fe94e..75cd854 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -563,7 +563,7 @@ static int target_xcopy_setup_pt_cmd(
 
 	if (alloc_mem) {
 		rc = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
-				      cmd->data_length, false);
+				      cmd->data_length, false, false);
 		if (rc < 0) {
 			ret = rc;
 			goto out;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 28ee5c2..d8ab510 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -85,7 +85,6 @@ extern struct configfs_attribute *passthrough_attrib_attrs[];
 void	*transport_kmap_data_sg(struct se_cmd *);
 void	transport_kunmap_data_sg(struct se_cmd *);
 /* core helpers also used by xcopy during internal command setup */
-int	target_alloc_sgl(struct scatterlist **, unsigned int *, u32, bool);
 sense_reason_t	transport_generic_map_mem_to_cmd(struct se_cmd *,
 		struct scatterlist *, u32, struct scatterlist *, u32);
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 8ff6d40..78d88f0 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -185,6 +185,10 @@ int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
 int	core_tpg_register(struct se_wwn *, struct se_portal_group *, int);
 int	core_tpg_deregister(struct se_portal_group *);
 
+int	target_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
+		u32 length, bool zero_page, bool chainable);
+void	target_free_sgl(struct scatterlist *sgl, int nents);
+
 /*
  * The LIO target core uses DMA_TO_DEVICE to mean that data is going
  * to the target (eg handling a WRITE) and DMA_FROM_DEVICE to mean
-- 
2.1.4
