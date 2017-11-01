From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] Registering non-contiguous memory
Date: Wed, 1 Nov 2017 11:11:42 +0000
Message-ID: <DB5PR05MB1270529922F451A2CACF7AE9B95F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB127817A311C332553E4391AFB9410-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We're planning to start the implementation soon - now is the last opportuni=
ty for input before we do.
Please let us know of any comments or suggestions you have.

-----Original Message-----
From: Alex Margolin=20
Sent: Sunday, February 05, 2017 6:46 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [RFC] Registering non-contiguous memory

Introduction
---------------------------------------------------------------------------=
-----
Numerous applications communicate buffers with a non-contiguous memory layo=
ut.
For example, HPC applications often work on a matrix, and require sending a=
 row or a column. Sending non-contiguous data requires specifying all the b=
uffers being transferred, along with potentially the same amount of memory =
keys (should the buffers be registered under different memory regions). Ext=
ended memory windows are proposed to address complex memory layouts, and al=
low the user to send and receive them in an efficient manner.
This RFC proposes an extension for memory windows for the use of non-contig=
uous buffers.

The problem
---------------------------------------------------------------------------=
-----
Currently, this is implemented using "sge_list" with an entry for each buff=
er, but sending a regular structure may cause a multitude of entries - whic=
h can easily be represented in a more compact way. For example, a matrix co=
lumn:
               M
          -----------
         | |X| | | | |
          -----------
         | |X| | | | |
          -----------   N
         | |X| | | | |
          -----------
         | |X| | | | |
          -----------

In the current implementation, sending such a column would require N scatte=
r- gather entries, each with the same length and within equal distance from=
 the previous one.

A similar case is data spanning across multiple memory regions:



                     ----------
                    |          |
                    |          |
                    | Memory   |
                   /| region #1|
     "Composite   / |          |
       region"   /  |          |
     ---------- /  -|          |
    |          |  / |          |
    |          | /   ----------
     ---------- <
    |          | \   ----------=20
    |          |  --|          |
    |          |    | Memory   |
    |          | ___| region #2|
     ---------- <   |          |
    |          | \   ----------
     ----------\  \_ ----------
                \   |          |
                 \  | Memory   |
                  \-| region #N|
                    |          |
                    |          |
                     ----------

Currently, sending such a "composite region" involves specifying all N regi=
ons it spans across.=20

The problem is that a large amount of information needs to be passed with t=
he WR to communicate a potentially small amount of data, causing significan=
t overhead.
This is especially true if the layout information does not fit in a single =
WR
(inline) and extra overhead is incurred. Also, applications tend to re-use =
the same layout over a multitude of network operations, thus aggravating th=
is problem.

Potentially, one may want to use more than one dimension of stride, like th=
e case of a side of a multi-dimensional cube (M * N * O):

                              O
                          ___ ___ ___
                        /_X_/_X_/_X_/|
                    N  /_X_/_X_/_X_/||
                      /_X_/_X_/_X /|/|
                     |   |   |   | /||
                     |___|___|___|/|/|
                  M  |   |   |   | /||
                     |___|___|___|/|/
                     |   |   |   | /
                     |___|___|___|/

Suggested Solution
---------------------------------------------------------------------------=
-----
The suggested solution is to extend the existing API of memory windows to a=
llow the user to describe a memory layout: a compact description of pattern=
s of memory - which can later be used to transfer buffers according to them=
.

For the aforementioned matrix example - the layout will include the size of=
 a single cell in the matrix, the distance between cells (M times that size=
) and the total amount of buffers (N). For the composite example, the layou=
t will simply contain the list of memory regions along with a base-pointer =
and length.

Suggested API Details
---------------------------------------------------------------------------=
-----
The main addition is the layout structure, composed of an array of entries.
Each entry refers to a previously created memory region or memory window, w=
hich allows the formation of multi-level memory windows for complex structu=
res.
Each entry can be a contiguous area, creating a composite, or a quantity of=
 equally-distanced buffers (but not a mixture of the two). The dimension of=
 the strides is accommodated by an variable-length array of item counts and=
 stride interval sizes. An additional per-entry field enables non-uniform i=
nterleaving, where the ratio is not 1:1, so we may take two items from the =
first entry for each item of the second entry.

The layout is "switched on" as a bind parameter with an additional access f=
lag, which is somewhat of a misuse, but since struct ibv_mw_bind_info is no=
t easily expandable in the functions using it, the alternative is an additi=
onal verb.

We do propose adding a verb for the allocation of such memory windows, whic=
h is required since the original memory window allocation function is not e=
asily extendable, and we require an additional parameter to determine the a=
mount of resources to allocate towards it (descriptors). In addition, this =
number is available for existing windows, in order to determine how to set =
this for a composite of two existing windows, or to keep track of resource =
use for it.

Finally, we add the option to obtain a local memory key for memory windows,=
 aside from the currently available remote key. This can be specified in an=
 SGE to send data out of a memory layout. This key will only be valid if lo=
cal access is requested in the access flags.



Signed-off-by: Alex Margolin <alexma@xxxxxxxxxxxx>
---
diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h inde=
x ea3dade..9ef3639 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -96,6 +96,20 @@ struct verbs_qp {
 	uint32_t		comp_mask;
 	struct verbs_xrcd       *xrcd;
 };
+
+enum verbs_mw_mask {
+	VERBS_MW_LKEY		=3D 1 << 0,
+	VERBS_MW_DESCRIPTOR_NUM	=3D 1 << 1,
+	VERBS_MW_RESERVED	=3D 1 << 2
+};
+
+struct verbs_mw {
+	struct ibv_mw		mw;
+	uint32_t		comp_mask;
+	uint32_t		lkey;
+	uint32_t		descriptor_num;
+};
+
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_=
path,
 						   int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_=
sys_path, diff --git a/include/infiniband/verbs.h b/include/infiniband/verb=
s.h index e994c21..748dc60 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -214,6 +214,23 @@ struct ibv_tso_caps {
 	uint32_t supported_qpts;
 };
=20
+struct ibv_ncm_caps {
+	uint64_t general_caps;
+	uint32_t max_mkey_ims_list_size;
+	uint32_t max_send_wqe_inline_cms;
+	uint32_t max_send_wqe_inline_ims;
+	uint32_t max_mw_recursion_depth;
+	uint32_t max_mw_stride_dimenson;
+};
+
+enum ibv_ncm_general_caps {
+	IBV_NCM_SUPPORT_COMPOSITE =3D 1 << 0,
+	IBV_NCM_SUPPORT_INTERLEAVED =3D 1 << 1,
+	IBV_NCM_SUPPORT_INTERLEAVED_REPETITION =3D 1 << 2,
+	IBV_NCM_SUPPORT_INTERLEAVED_NONUNIFORM_REPETITION =3D 1 << 3,
+	IBV_NCM_SUPPORT_INTERLEAVED_NONUNIFORM_TOTAL_ITEMS =3D 1 << 4, };
+
 /* RX Hash function flags */
 enum ibv_rx_hash_function_flags {
 	IBV_RX_HASH_FUNC_TOEPLITZ	=3D 1 << 0,
@@ -256,6 +273,7 @@ struct ibv_device_attr_ex {
 	struct ibv_tso_caps	tso_caps;
 	struct ibv_rss_caps     rss_caps;
 	uint32_t		max_wq_type_rq;
+	struct ibv_ncm_caps     ncm_caps;
 };
=20
 enum ibv_mtu {
@@ -472,13 +490,7 @@ enum ibv_access_flags {
 	IBV_ACCESS_MW_BIND		=3D (1<<4),
 	IBV_ACCESS_ZERO_BASED		=3D (1<<5),
 	IBV_ACCESS_ON_DEMAND		=3D (1<<6),
-};
-
-struct ibv_mw_bind_info {
-	struct ibv_mr	*mr;
-	uint64_t	 addr;
-	uint64_t	 length;
-	int		 mw_access_flags; /* use ibv_access_flags */
+	IBV_ACCESS_BIND_MW_NONCONTIG	=3D (1<<7),
 };
=20
 struct ibv_pd {
@@ -533,6 +545,61 @@ struct ibv_mw {
 	enum ibv_mw_type	type;
 };
=20
+struct ibv_mw_alloc_attr_ex {
+	unit32_t comp_mask;
+	struct ibv_pd *pd;
+	enum ibv_mw_type type;
+	int max_descriptors;
+};
+
+enum ibv_mw_entry_type {
+	IBV_MW_ENTRY_USE_MR =3D 0,
+	IBV_MW_ENTRY_USE_MW
+};
+
+struct ibv_mw_bind_layout_entry {
+	uint32_t comp_mask;
+	enum ibv_mw_entry_type mem_obj_type;
+	union mem_obj {
+		struct ibv_mr *mr;
+		struct ibv_mw *mw;
+	};
+	uint64_t addr;
+	uint64_t length;
+	struct {
+		uint64_t repeat_count;
+		uint32_t dimension_count;
+		struct {
+			uint64_t stride;
+			uint64_t count;
+		} *dimension;
+	} interleaved;
+};
+
+enum ibv_mw_bind_layout_type {
+	IBV_MW_BIND_LAYOUT_TYPE_COMPOSITE =3D 0,
+	IBV_MW_BIND_LAYOUT_TYPE_INTERLEAVED
+};
+
+struct ibv_mw_bind_layout {
+	uint32_t comp_mask;
+	enum ibv_mw_bind_layout_type type;
+	uint32_t entry_count;
+	struct ibv_mw_bind_info_entry *entries; };
+
+struct ibv_mw_bind_info {
+	union {
+		struct {
+			struct ibv_mr   *mr;
+			uint64_t        addr;
+			uint64_t        length;
+		};
+		struct ibv_mw_bind_layout *layout;
+	};
+	int		 mw_access_flags; /* use ibv_access_flags */
+};
+
 struct ibv_global_route {
 	union ibv_gid		dgid;
 	uint32_t		flow_label;
@@ -1411,11 +1478,13 @@ enum verbs_context_mask {
 	VERBS_CONTEXT_QP	=3D 1 << 2,
 	VERBS_CONTEXT_CREATE_FLOW =3D 1 << 3,
 	VERBS_CONTEXT_DESTROY_FLOW =3D 1 << 4,
-	VERBS_CONTEXT_RESERVED	=3D 1 << 5
+	VERBS_CONTEXT_ALLOC_MW	=3D 1 << 5,
+	VERBS_CONTEXT_RESERVED	=3D 1 << 6
 };
=20
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	struct ib_mw * (*alloc_mw_ex)(struct ibv_mw_alloc_attr=20
+*mw_alloc_attr);
 	int (*destroy_rwq_ind_table)(struct ibv_rwq_ind_table *rwq_ind_table);
 	struct ibv_rwq_ind_table *(*create_rwq_ind_table)(struct ibv_context *con=
text,
 							  struct ibv_rwq_ind_table_init_attr *init_attr);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
