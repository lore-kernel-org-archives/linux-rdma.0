From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/12] IB/hfi1: Optimize devdata cachelines
Date: Mon, 17 Oct 2016 04:19:35 -0700
Message-ID: <20161017111935.7934.23337.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Profiling shows hot path struct members that need
to be in a minimum set of cachelines.

Group these struct member in the same cacheline:
	sc2vl_lock
	sc2vl
	rhf_rcv_function_map
	rcv_limit
	rhf_offset

Group these struct member in the same cacheline:
	process_pio_send
	process_dma_send
	pport
	rcd
	int_counter
	flags
	num_pports
	first_user_ctxt

Fill holes in struct hfi1_devdata revealed by pahole.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h |  111 +++++++++++++++++++-------------------
 1 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 87847cc..bec4607 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -852,32 +852,29 @@ struct hfi1_devdata {
 	u8 __iomem *kregend;
 	/* physical address of chip for io_remap, etc. */
 	resource_size_t physaddr;
-	/* receive context data */
-	struct hfi1_ctxtdata **rcd;
+	/* Per VL data. Enough for all VLs but not all elements are set/used. */
+	struct per_vl_data vld[PER_VL_SEND_CONTEXTS];
 	/* send context data */
 	struct send_context_info *send_contexts;
 	/* map hardware send contexts to software index */
 	u8 *hw_to_sw;
 	/* spinlock for allocating and releasing send context resources */
 	spinlock_t sc_lock;
-	/* Per VL data. Enough for all VLs but not all elements are set/used. */
-	struct per_vl_data vld[PER_VL_SEND_CONTEXTS];
 	/* lock for pio_map */
 	spinlock_t pio_map_lock;
+	/* Send Context initialization lock. */
+	spinlock_t sc_init_lock;
+	/* lock for sdma_map */
+	spinlock_t                          sde_map_lock;
 	/* array of kernel send contexts */
 	struct send_context **kernel_send_context;
 	/* array of vl maps */
 	struct pio_vl_map __rcu *pio_map;
-	/* seqlock for sc2vl */
-	seqlock_t sc2vl_lock;
-	u64 sc2vl[4];
-	/* Send Context initialization lock. */
-	spinlock_t sc_init_lock;
+	/* default flags to last descriptor */
+	u64 default_desc1;
 
 	/* fields common to all SDMA engines */
 
-	/* default flags to last descriptor */
-	u64 default_desc1;
 	volatile __le64                    *sdma_heads_dma; /* DMA'ed by chip */
 	dma_addr_t                          sdma_heads_phys;
 	void                               *sdma_pad_dma; /* DMA'ed by chip */
@@ -888,8 +885,6 @@ struct hfi1_devdata {
 	u32                                 chip_sdma_engines;
 	/* num used */
 	u32                                 num_sdma;
-	/* lock for sdma_map */
-	spinlock_t                          sde_map_lock;
 	/* array of engines sized by num_sdma */
 	struct sdma_engine                 *per_sdma;
 	/* array of vl maps */
@@ -898,14 +893,11 @@ struct hfi1_devdata {
 	wait_queue_head_t		  sdma_unfreeze_wq;
 	atomic_t			  sdma_unfreeze_count;
 
+	u32 lcb_access_count;		/* count of LCB users */
+
 	/* common data between shared ASIC HFIs in this OS */
 	struct hfi1_asic_data *asic_data;
 
-	/* hfi1_pportdata, points to array of (physical) port-specific
-	 * data structs, indexed by pidx (0..n-1)
-	 */
-	struct hfi1_pportdata *pport;
-
 	/* mem-mapped pointer to base of PIO buffers */
 	void __iomem *piobase;
 	/*
@@ -922,20 +914,13 @@ struct hfi1_devdata {
 	/* send context numbers and sizes for each type */
 	struct sc_config_sizes sc_sizes[SC_MAX];
 
-	u32 lcb_access_count;		/* count of LCB users */
-
 	char *boardname; /* human readable board info */
 
-	/* device (not port) flags, basically device capabilities */
-	u32 flags;
-
 	/* reset value */
 	u64 z_int_counter;
 	u64 z_rcv_limit;
 	u64 z_send_schedule;
-	/* percpu int_counter */
-	u64 __percpu *int_counter;
-	u64 __percpu *rcv_limit;
+
 	u64 __percpu *send_schedule;
 	/* number of receive contexts in use by the driver */
 	u32 num_rcv_contexts;
@@ -950,6 +935,7 @@ struct hfi1_devdata {
 	/* base receive interrupt timeout, in CSR units */
 	u32 rcv_intr_timeout_csr;
 
+	u32 freezelen; /* max length of freezemsg */
 	u64 __iomem *egrtidbase;
 	spinlock_t sendctrl_lock; /* protect changes to SendCtrl */
 	spinlock_t rcvctrl_lock; /* protect changes to RcvCtrl */
@@ -971,7 +957,6 @@ struct hfi1_devdata {
 	 * IB link status cheaply
 	 */
 	struct hfi1_status *status;
-	u32 freezelen; /* max length of freezemsg */
 
 	/* revision register shadow */
 	u64 revision;
@@ -999,6 +984,8 @@ struct hfi1_devdata {
 	u16 rcvegrbufsize_shift;
 	/* both sides of the PCIe link are gen3 capable */
 	u8 link_gen3_capable;
+	/* default link down value (poll/sleep) */
+	u8 link_default;
 	/* localbus width (1, 2,4,8,16,32) from config space  */
 	u32 lbus_width;
 	/* localbus speed in MHz */
@@ -1034,8 +1021,6 @@ struct hfi1_devdata {
 	u8 hfi1_id;
 	/* implementation code */
 	u8 icode;
-	/* default link down value (poll/sleep) */
-	u8 link_default;
 	/* vAU of this device */
 	u8 vau;
 	/* vCU of this device */
@@ -1046,27 +1031,17 @@ struct hfi1_devdata {
 	u16 vl15_init;
 
 	/* Misc small ints */
-	/* Number of physical ports available */
-	u8 num_pports;
-	/* Lowest context number which can be used by user processes */
-	u8 first_user_ctxt;
 	u8 n_krcv_queues;
 	u8 qos_shift;
-	u8 qpn_mask;
 
-	u16 rhf_offset; /* offset of RHF within receive header entry */
 	u16 irev;	/* implementation revision */
 	u16 dc8051_ver; /* 8051 firmware version */
 
+	spinlock_t hfi1_diag_trans_lock; /* protect diag observer ops */
 	struct platform_config platform_config;
 	struct platform_config_cache pcfg_cache;
 
 	struct diag_client *diag_client;
-	spinlock_t hfi1_diag_trans_lock; /* protect diag observer ops */
-
-	u8 psxmitwait_supported;
-	/* cycle length of PS* counters in HW (in picoseconds) */
-	u16 psxmitwait_check_rate;
 
 	/* MSI-X information */
 	struct hfi1_msix_entry *msix_entries;
@@ -1081,6 +1056,9 @@ struct hfi1_devdata {
 
 	struct rcv_array_data rcv_entries;
 
+	/* cycle length of PS* counters in HW (in picoseconds) */
+	u16 psxmitwait_check_rate;
+
 	/*
 	 * 64 bit synthetic counters
 	 */
@@ -1113,11 +1091,11 @@ struct hfi1_devdata {
 	struct err_info_rcvport err_info_rcvport;
 	struct err_info_constraint err_info_rcv_constraint;
 	struct err_info_constraint err_info_xmit_constraint;
-	u8 err_info_uncorrectable;
-	u8 err_info_fmconfig;
 
 	atomic_t drop_packet;
 	u8 do_drop;
+	u8 err_info_uncorrectable;
+	u8 err_info_fmconfig;
 
 	/*
 	 * Software counters for the status bits defined by the
@@ -1140,51 +1118,74 @@ struct hfi1_devdata {
 	u64 sw_cce_err_status_aggregate;
 	/* Software counter that aggregates all bypass packet rcv errors */
 	u64 sw_rcv_bypass_packet_errors;
-	/* receive interrupt functions */
-	rhf_rcv_function_ptr *rhf_rcv_function_map;
+	/* receive interrupt function */
 	rhf_rcv_function_ptr normal_rhf_rcv_functions[8];
 
+	/* Save the enabled LCB error bits */
+	u64 lcb_err_en;
+
 	/*
 	 * Handlers for outgoing data so that snoop/capture does not
 	 * have to have its hooks in the send path
 	 */
-	send_routine process_pio_send;
+	send_routine process_pio_send ____cacheline_aligned_in_smp;
 	send_routine process_dma_send;
 	void (*pio_inline_send)(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 				u64 pbc, const void *from, size_t count);
+	/* hfi1_pportdata, points to array of (physical) port-specific
+	 * data structs, indexed by pidx (0..n-1)
+	 */
+	struct hfi1_pportdata *pport;
+	/* receive context data */
+	struct hfi1_ctxtdata **rcd;
+	u64 __percpu *int_counter;
+	/* device (not port) flags, basically device capabilities */
+	u16 flags;
+	/* Number of physical ports available */
+	u8 num_pports;
+	/* Lowest context number which can be used by user processes */
+	u8 first_user_ctxt;
+	/* adding a new field here would make it part of this cacheline */
+
+	/* seqlock for sc2vl */
+	seqlock_t sc2vl_lock ____cacheline_aligned_in_smp;
+	u64 sc2vl[4];
+	/* receive interrupt functions */
+	rhf_rcv_function_ptr *rhf_rcv_function_map;
+	u64 __percpu *rcv_limit;
+	u16 rhf_offset; /* offset of RHF within receive header entry */
+	/* adding a new field here would make it part of this cacheline */
 
 	/* OUI comes from the HW. Used everywhere as 3 separate bytes. */
 	u8 oui1;
 	u8 oui2;
 	u8 oui3;
+	u8 dc_shutdown;
+
 	/* Timer and counter used to detect RcvBufOvflCnt changes */
 	struct timer_list rcverr_timer;
-	u32 rcv_ovfl_cnt;
 
 	wait_queue_head_t event_queue;
 
-	/* Save the enabled LCB error bits */
-	u64 lcb_err_en;
-	u8 dc_shutdown;
-
 	/* receive context tail dummy address */
 	__le64 *rcvhdrtail_dummy_kvaddr;
 	dma_addr_t rcvhdrtail_dummy_dma;
 
-	bool eprom_available;	/* true if EPROM is available for this device */
-	bool aspm_supported;	/* Does HW support ASPM */
-	bool aspm_enabled;	/* ASPM state: enabled/disabled */
+	u32 rcv_ovfl_cnt;
 	/* Serialize ASPM enable/disable between multiple verbs contexts */
 	spinlock_t aspm_lock;
 	/* Number of verbs contexts which have disabled ASPM */
 	atomic_t aspm_disabled_cnt;
 	/* Keeps track of user space clients */
 	atomic_t user_refcount;
+	struct hfi1_affinity *affinity;
 	/* Used to wait for outstanding user space clients before dev removal */
 	struct completion user_comp;
-
-	struct hfi1_affinity *affinity;
+	bool eprom_available;	/* true if EPROM is available for this device */
+	bool aspm_supported;	/* Does HW support ASPM */
+	bool aspm_enabled;	/* ASPM state: enabled/disabled */
 	struct rhashtable sdma_rht;
+
 	struct kobject kobj;
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
