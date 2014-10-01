From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 19/21] IB/iser: Add/Fix kernel doc style descriptions in iscsi_iser.h
Date: Wed,  1 Oct 2014 14:02:15 +0300
Message-ID: <1412161337-25285-20-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

- iser_hdr
- iser_data_buf
- iser_mem_reg
- iser_regd_buf
- iser_tx_desc
- iser_rx_desc
- iser_device
- iser_pi_context
- iser_conn
- ib_conn
- iser_comp
- iscsi_iser_task
- iser_global

While we're at it, change nit alignments in this file

This patch does not change any functionality

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |  235 ++++++++++++++++++++++++------
 1 files changed, 189 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index eedcbf2..5250a12 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -154,12 +154,22 @@
 #define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
 #define ISER_BEACON_WRID		0xfffffffffffffffeULL
 
+/**
+ * struct iser_hdr - iSER header
+ *
+ * @flags:        flags support (zbva, remote_inv)
+ * @rsvd:         reserved
+ * @write_stag:   write rkey
+ * @write_va:     write virtual address
+ * @reaf_stag:    read rkey
+ * @read_va:      read virtual address
+ */
 struct iser_hdr {
 	u8      flags;
 	u8      rsvd[3];
-	__be32  write_stag; /* write rkey */
+	__be32  write_stag;
 	__be64  write_va;
-	__be32  read_stag;  /* read rkey */
+	__be32  read_stag;
 	__be64  read_va;
 } __attribute__((packed));
 
@@ -203,15 +213,25 @@ enum iser_data_dir {
 	ISER_DIRS_NUM
 };
 
+/**
+ * struct iser_data_buf - iSER data buffer
+ *
+ * @buf:          pointer to the sg list
+ * @size:         num entries of this sg
+ * @data_len:     total beffer byte len
+ * @dma_nents:    returned by dma_map_sg
+ * @copy_buf:     allocated copy buf for SGs unaligned
+ *                for rdma which are copied
+ * @sg_single:    SG-ified clone of a non SG SC or
+ *                unaligned SG
+ */
 struct iser_data_buf {
-	void               *buf;      /* pointer to the sg list               */
-	unsigned int       size;      /* num entries of this sg               */
-	unsigned long      data_len;  /* total data len                       */
-	unsigned int       dma_nents; /* returned by dma_map_sg               */
-	char       	   *copy_buf; /* allocated copy buf for SGs unaligned *
-	                               * for rdma which are copied            */
-	struct scatterlist sg_single; /* SG-ified clone of a non SG SC or     *
-				       * unaligned SG                         */
+	void               *buf;
+	unsigned int       size;
+	unsigned long      data_len;
+	unsigned int       dma_nents;
+	char               *copy_buf;
+	struct scatterlist sg_single;
   };
 
 /* fwd declarations */
@@ -219,6 +239,16 @@ struct iser_device;
 struct iscsi_iser_task;
 struct iscsi_endpoint;
 
+/**
+ * struct iser_mem_reg - iSER memory registration info
+ *
+ * @lkey:         MR local key
+ * @rkey:         MR remote key
+ * @va:           MR start address (buffer va)
+ * @len:          MR length
+ * @mem_h:        pointer to registration context (FMR/Fastreg)
+ * @is_mr:        indicates weather we registered the buffer
+ */
 struct iser_mem_reg {
 	u32  lkey;
 	u32  rkey;
@@ -228,11 +258,20 @@ struct iser_mem_reg {
 	int  is_mr;
 };
 
+/**
+ * struct iser_regd_buf - iSER buffer registration desc
+ *
+ * @reg:          memory registration info
+ * @virt_addr:    virtual address of buffer
+ * @device:       reference to iser device
+ * @direction:    dma direction (for dma_unmap)
+ * @data_size:    data buffer size in bytes
+ */
 struct iser_regd_buf {
-	struct iser_mem_reg     reg;        /* memory registration info        */
+	struct iser_mem_reg     reg;
 	void                    *virt_addr;
-	struct iser_device      *device;    /* device->device for dma_unmap    */
-	enum dma_data_direction direction;  /* direction for dma_unmap	       */
+	struct iser_device      *device;
+	enum dma_data_direction direction;
 	unsigned int            data_size;
 };
 
@@ -242,19 +281,39 @@ enum iser_desc_type {
 	ISCSI_TX_DATAOUT
 };
 
+/**
+ * struct iser_tx_desc - iSER TX descriptor (for send wr_id)
+ *
+ * @iser_header:   iser header
+ * @iscsi_header:  iscsi header
+ * @type:          command/control/dataout
+ * @dam_addr:      header buffer dma_address
+ * @tx_sg:         sg[0] points to iser/iscsi headers
+ *                 sg[1] optionally points to either of immediate data
+ *                 unsolicited data-out or control
+ * @num_sge:       number sges used on this TX task
+ */
 struct iser_tx_desc {
 	struct iser_hdr              iser_header;
 	struct iscsi_hdr             iscsi_header;
 	enum   iser_desc_type        type;
 	u64		             dma_addr;
-	/* sg[0] points to iser/iscsi headers, sg[1] optionally points to either
-	of immediate data, unsolicited data-out or control (login,text) */
 	struct ib_sge		     tx_sg[2];
 	int                          num_sge;
 };
 
 #define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
 					sizeof(u64) + sizeof(struct ib_sge)))
+/**
+ * struct iser_rx_desc - iSER RX descriptor (for recv wr_id)
+ *
+ * @iser_header:   iser header
+ * @iscsi_header:  iscsi header
+ * @data:          received data segment
+ * @dma_addr:      receive buffer dma address
+ * @rx_sg:         ib_sge of receive buffer
+ * @pad:           for sense data TODO: Modify to maximum sense length supported
+ */
 struct iser_rx_desc {
 	struct iser_hdr              iser_header;
 	struct iscsi_hdr             iscsi_header;
@@ -288,13 +347,32 @@ struct iser_comp {
 	int                      active_qps;
 };
 
+/**
+ * struct iser_device - iSER device handle
+ *
+ * @ib_device:     RDMA device
+ * @pd:            Protection Domain for this device
+ * @dev_attr:      Device attributes container
+ * @mr:            Global DMA memory region
+ * @event_handler: IB events handle routine
+ * @ig_list:	   entry in devices list
+ * @refcount:      Reference counter, dominated by open iser connections
+ * @comps_used:    Number of completion contexts used, Min between online
+ *                 cpus and device max completion vectors
+ * @comps:         Dinamically allocated array of completion handlers
+ * Memory registration pool Function pointers (FMR or Fastreg):
+ *     @iser_alloc_rdma_reg_res: Allocation of memory regions pool
+ *     @iser_free_rdma_reg_res:  Free of memory regions pool
+ *     @iser_reg_rdma_mem:       Memory registration routine
+ *     @iser_unreg_rdma_mem:     Memory deregistration routine
+ */
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
 	struct ib_device_attr	     dev_attr;
 	struct ib_mr	             *mr;
 	struct ib_event_handler      event_handler;
-	struct list_head             ig_list; /* entry in ig devices list */
+	struct list_head             ig_list;
 	int                          refcount;
 	int			     comps_used;
 	struct iser_comp	     comps[ISER_MAX_CQ];
@@ -318,19 +396,33 @@ enum iser_reg_indicator {
 	ISER_FASTREG_PROTECTED	= 1 << 3,
 };
 
+/**
+ * struct iser_pi_context - Protection information context
+ *
+ * @prot_mr:        protection memory region
+ * @prot_frpl:      protection fastreg page list
+ * @sig_mr:         signature feature enabled memory region
+ */
 struct iser_pi_context {
 	struct ib_mr                   *prot_mr;
 	struct ib_fast_reg_page_list   *prot_frpl;
 	struct ib_mr                   *sig_mr;
 };
 
+/**
+ * struct fast_reg_descriptor - Fast registration descriptor
+ *
+ * @list:           entry in connection fastreg pool
+ * @data_mr:        data memory region
+ * @data_frpl:      data fastreg page list
+ * @pi_ctx:         protection information context
+ * @reg_indicators: fast registration indicators
+ */
 struct fast_reg_descriptor {
 	struct list_head		  list;
-	/* For fast registration - FRWR */
 	struct ib_mr			 *data_mr;
 	struct ib_fast_reg_page_list     *data_frpl;
 	struct iser_pi_context		 *pi_ctx;
-	/* registration indicators container */
 	u8				  reg_indicators;
 };
 
@@ -379,21 +471,49 @@ struct ib_conn {
 	};
 };
 
+/**
+ * struct iser_conn - iSER connection context
+ *
+ * @ib_conn:          connection RDMA resources
+ * @iscsi_conn:       link to matching iscsi connection
+ * @ep:               transport handle
+ * @state:            connection logical state
+ * @qp_max_recv_dtos: maximum number of data outs, corresponds
+ *                    to max number of post recvs
+ * @qp_max_recv_dtos_mask: (qp_max_recv_dtos - 1)
+ * @min_posted_rx:    (qp_max_recv_dtos >> 2)
+ * @name:             connection peer portal
+ * @release_work:     deffered work for release job
+ * @state_mutex:      protects iser onnection state
+ * @stop_completion:  conn_stop completion
+ * @ib_completion:    RDMA cleanup completion
+ * @up_completion:    connection establishment completed
+ *                    (state is ISER_CONN_UP)
+ * @conn_list:        entry in ig conn list
+ * @login_buf:        login data buffer (stores login parameters)
+ * @login_req_buf:    login request buffer
+ * @login_req_dma:    login request buffer dma address
+ * @login_resp_buf:   login response buffer
+ * @login_resp_dma:   login response buffer dma address
+ * @rx_desc_head:     head of rx_descs cyclic buffer
+ * @rx_descs:         rx buffers array (cyclic buffer)
+ * @num_rx_descs:     number of rx descriptors
+ */
 struct iser_conn {
 	struct ib_conn		     ib_conn;
 	struct iscsi_conn	     *iscsi_conn;
 	struct iscsi_endpoint	     *ep;
-	enum iser_conn_state	     state;	    /* rdma connection state   */
-	unsigned		     qp_max_recv_dtos; /* num of rx buffers */
-	unsigned		     qp_max_recv_dtos_mask; /* above minus 1 */
-	unsigned		     min_posted_rx; /* qp_max_recv_dtos >> 2 */
+	enum iser_conn_state	     state;
+	unsigned		     qp_max_recv_dtos;
+	unsigned		     qp_max_recv_dtos_mask;
+	unsigned		     min_posted_rx;
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct work_struct	     release_work;
 	struct mutex		     state_mutex;
 	struct completion	     stop_completion;
 	struct completion	     ib_completion;
 	struct completion	     up_completion;
-	struct list_head	     conn_list;       /* entry in ig conn list */
+	struct list_head	     conn_list;
 
 	char  			     *login_buf;
 	char			     *login_req_buf, *login_resp_buf;
@@ -403,18 +523,33 @@ struct iser_conn {
 	u32                          num_rx_descs;
 };
 
+/**
+ * struct iscsi_iser_task - iser task context
+ *
+ * @desc:     TX descriptor
+ * @iser_conn:        link to iser connection
+ * @status:           current task status
+ * @sc:               link to scsi command
+ * @command_sent:     indicate if command was sent
+ * @dir:              iser data direction
+ * @rdma_regd:        task rdma registration desc
+ * @data:             iser data buffer desc
+ * @data_copy:        iser data copy buffer desc (bounce buffer)
+ * @prot:             iser protection buffer desc
+ * @prot_copy:        iser protection copy buffer desc (bounce buffer)
+ */
 struct iscsi_iser_task {
 	struct iser_tx_desc          desc;
 	struct iser_conn	     *iser_conn;
 	enum iser_task_status 	     status;
 	struct scsi_cmnd	     *sc;
-	int                          command_sent;  /* set if command  sent  */
-	int                          dir[ISER_DIRS_NUM];      /* set if dir use*/
-	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];/* regd rdma buf */
-	struct iser_data_buf         data[ISER_DIRS_NUM];     /* orig. data des*/
-	struct iser_data_buf         data_copy[ISER_DIRS_NUM];/* contig. copy  */
-	struct iser_data_buf         prot[ISER_DIRS_NUM];     /* prot desc     */
-	struct iser_data_buf         prot_copy[ISER_DIRS_NUM];/* prot copy     */
+	int                          command_sent;
+	int                          dir[ISER_DIRS_NUM];
+	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];
+	struct iser_data_buf         data[ISER_DIRS_NUM];
+	struct iser_data_buf         data_copy[ISER_DIRS_NUM];
+	struct iser_data_buf         prot[ISER_DIRS_NUM];
+	struct iser_data_buf         prot_copy[ISER_DIRS_NUM];
 };
 
 struct iser_page_vec {
@@ -424,12 +559,20 @@ struct iser_page_vec {
 	int data_size;
 };
 
+/**
+ * struct iser_global: iSER global context
+ *
+ * @device_list_mutex:    protects device_list
+ * @device_list:          iser devices global list
+ * @connlist_mutex:       protects connlist
+ * @connlist:             iser connections global list
+ * @desc_cache:           kmem cache for tx dataout
+ */
 struct iser_global {
-	struct mutex      device_list_mutex;/*                   */
-	struct list_head  device_list;	     /* all iSER devices */
+	struct mutex      device_list_mutex;
+	struct list_head  device_list;
 	struct mutex      connlist_mutex;
-	struct list_head  connlist;		/* all iSER IB connections */
-
+	struct list_head  connlist;
 	struct kmem_cache *desc_cache;
 };
 
@@ -449,9 +592,9 @@ int iser_send_data_out(struct iscsi_conn *conn,
 		       struct iscsi_data *hdr);
 
 void iscsi_iser_recv(struct iscsi_conn *conn,
-		     struct iscsi_hdr       *hdr,
-		     char                   *rx_data,
-		     int                    rx_data_len);
+		     struct iscsi_hdr *hdr,
+		     char *rx_data,
+		     int rx_data_len);
 
 void iser_conn_init(struct iser_conn *iser_conn);
 
@@ -462,7 +605,7 @@ int iser_conn_terminate(struct iser_conn *iser_conn);
 void iser_release_work(struct work_struct *work);
 
 void iser_rcv_completion(struct iser_rx_desc *desc,
-			 unsigned long    dto_xfer_len,
+			 unsigned long dto_xfer_len,
 			 struct ib_conn *ib_conn);
 
 void iser_snd_completion(struct iser_tx_desc *desc,
@@ -484,14 +627,14 @@ int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
 int  iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *task,
 			       enum iser_data_dir cmd_dir);
 
-int  iser_connect(struct iser_conn   *iser_conn,
-		  struct sockaddr    *src_addr,
-		  struct sockaddr    *dst_addr,
-		  int                non_blocking);
+int  iser_connect(struct iser_conn *iser_conn,
+		  struct sockaddr *src_addr,
+		  struct sockaddr *dst_addr,
+		  int non_blocking);
 
 int  iser_reg_page_vec(struct ib_conn *ib_conn,
 		       struct iser_page_vec *page_vec,
-		       struct iser_mem_reg  *mem_reg);
+		       struct iser_mem_reg *mem_reg);
 
 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 			enum iser_data_dir cmd_dir);
@@ -504,9 +647,9 @@ int  iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 		    bool signal);
 
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
-			    struct iser_data_buf       *data,
-			    enum   iser_data_dir       iser_dir,
-			    enum   dma_data_direction  dma_dir);
+			   struct iser_data_buf *data,
+			   enum iser_data_dir iser_dir,
+			   enum dma_data_direction dma_dir);
 
 void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 			      struct iser_data_buf *data);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
