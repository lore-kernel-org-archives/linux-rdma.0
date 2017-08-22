From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 13/16] IB/hfi1: Move structure and MACRO
 definitions in user_sdma.c to user_sdma.h
Date: Tue, 22 Aug 2017 18:40:25 +0300
Message-ID: <20170822154025.GD1724@mtr-leonro.local>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
 <20170822012728.32701.38661.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c1qHkdEbEbCG94PZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170822012728.32701.38661.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--c1qHkdEbEbCG94PZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2017 at 06:27:29PM -0700, Dennis Dalessandro wrote:
> From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Clean up user_sdma.c by moving the structure and MACRO definitions into
> the header file user_sdma.h
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/user_sdma.c |  168 --------------------------------
>  drivers/infiniband/hw/hfi1/user_sdma.h |  166 ++++++++++++++++++++++++++++++++
>  2 files changed, 166 insertions(+), 168 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
> index 8a1653a..dacb0fc 100644
> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
> @@ -74,176 +74,8 @@
>  module_param_named(sdma_comp_size, hfi1_sdma_comp_ring_size, uint, S_IRUGO);
>  MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 128");
>
> -/* The maximum number of Data io vectors per message/request */
> -#define MAX_VECTORS_PER_REQ 8
> -/*
> - * Maximum number of packet to send from each message/request
> - * before moving to the next one.
> - */
> -#define MAX_PKTS_PER_QUEUE 16
> -
> -#define num_pages(x) (1 + ((((x) - 1) & PAGE_MASK) >> PAGE_SHIFT))
> -
> -#define req_opcode(x) \
> -	(((x) >> HFI1_SDMA_REQ_OPCODE_SHIFT) & HFI1_SDMA_REQ_OPCODE_MASK)
> -#define req_version(x) \
> -	(((x) >> HFI1_SDMA_REQ_VERSION_SHIFT) & HFI1_SDMA_REQ_OPCODE_MASK)
> -#define req_iovcnt(x) \
> -	(((x) >> HFI1_SDMA_REQ_IOVCNT_SHIFT) & HFI1_SDMA_REQ_IOVCNT_MASK)
> -
> -/* Number of BTH.PSN bits used for sequence number in expected rcvs */
> -#define BTH_SEQ_MASK 0x7ffull
> -
> -#define AHG_KDETH_INTR_SHIFT 12
> -#define AHG_KDETH_SH_SHIFT   13
> -#define AHG_KDETH_ARRAY_SIZE  9
> -
> -#define PBC2LRH(x) ((((x) & 0xfff) << 2) - 4)
> -#define LRH2PBC(x) ((((x) >> 2) + 1) & 0xfff)
> -
> -#define AHG_HEADER_SET(arr, idx, dw, bit, width, value)			\
> -	do {								\
> -		if ((idx) < ARRAY_SIZE((arr)))				\
> -			(arr)[(idx++)] = sdma_build_ahg_descriptor(	\
> -				(__force u16)(value), (dw), (bit),	\
> -							(width));	\
> -		else							\
> -			return -ERANGE;					\
> -	} while (0)
> -
> -/* Tx request flag bits */
> -#define TXREQ_FLAGS_REQ_ACK   BIT(0)      /* Set the ACK bit in the header */
> -#define TXREQ_FLAGS_REQ_DISABLE_SH BIT(1) /* Disable header suppression */
> -
> -#define SDMA_PKT_Q_INACTIVE BIT(0)
> -#define SDMA_PKT_Q_ACTIVE   BIT(1)
> -#define SDMA_PKT_Q_DEFERRED BIT(2)
> -
> -/*
> - * Maximum retry attempts to submit a TX request
> - * before putting the process to sleep.
> - */
> -#define MAX_DEFER_RETRY_COUNT 1
> -
>  static unsigned initial_pkt_count = 8;
>
> -#define SDMA_IOWAIT_TIMEOUT 1000 /* in milliseconds */
> -
> -struct sdma_mmu_node;
> -
> -struct user_sdma_iovec {
> -	struct list_head list;
> -	struct iovec iov;
> -	/* number of pages in this vector */
> -	unsigned npages;
> -	/* array of pinned pages for this vector */
> -	struct page **pages;
> -	/*
> -	 * offset into the virtual address space of the vector at
> -	 * which we last left off.
> -	 */
> -	u64 offset;
> -	struct sdma_mmu_node *node;
> -};
> -
> -struct sdma_mmu_node {
> -	struct mmu_rb_node rb;
> -	struct hfi1_user_sdma_pkt_q *pq;
> -	atomic_t refcount;
> -	struct page **pages;
> -	unsigned npages;
> -};
> -
> -/* evict operation argument */
> -struct evict_data {
> -	u32 cleared;	/* count evicted so far */
> -	u32 target;	/* target count to evict */
> -};
> -
> -struct user_sdma_request {
> -	/* This is the original header from user space */
> -	struct hfi1_pkt_header hdr;
> -
> -	/* Read mostly fields */
> -	struct hfi1_user_sdma_pkt_q *pq ____cacheline_aligned_in_smp;
> -	struct hfi1_user_sdma_comp_q *cq;
> -	/*
> -	 * Pointer to the SDMA engine for this request.
> -	 * Since different request could be on different VLs,
> -	 * each request will need it's own engine pointer.
> -	 */
> -	struct sdma_engine *sde;
> -	struct sdma_req_info info;
> -	/* TID array values copied from the tid_iov vector */
> -	u32 *tids;
> -	/* total length of the data in the request */
> -	u32 data_len;
> -	/* number of elements copied to the tids array */
> -	u16 n_tids;
> -	/*
> -	 * We copy the iovs for this request (based on
> -	 * info.iovcnt). These are only the data vectors
> -	 */
> -	u8 data_iovs;
> -	s8 ahg_idx;
> -
> -	/* Writeable fields shared with interrupt */
> -	u64 seqcomp ____cacheline_aligned_in_smp;
> -	u64 seqsubmitted;
> -	/* status of the last txreq completed */
> -	int status;
> -
> -	/* Send side fields */
> -	struct list_head txps ____cacheline_aligned_in_smp;
> -	u64 seqnum;
> -	/*
> -	 * KDETH.OFFSET (TID) field
> -	 * The offset can cover multiple packets, depending on the
> -	 * size of the TID entry.
> -	 */
> -	u32 tidoffset;
> -	/*
> -	 * KDETH.Offset (Eager) field
> -	 * We need to remember the initial value so the headers
> -	 * can be updated properly.
> -	 */
> -	u32 koffset;
> -	u32 sent;
> -	/* TID index copied from the tid_iov vector */
> -	u16 tididx;
> -	/* progress index moving along the iovs array */
> -	u8 iov_idx;
> -	u8 done;
> -	u8 has_error;
> -
> -	struct user_sdma_iovec iovs[MAX_VECTORS_PER_REQ];
> -} ____cacheline_aligned_in_smp;
> -
> -/*
> - * A single txreq could span up to 3 physical pages when the MTU
> - * is sufficiently large (> 4K). Each of the IOV pointers also
> - * needs it's own set of flags so the vector has been handled
> - * independently of each other.
> - */
> -struct user_sdma_txreq {
> -	/* Packet header for the txreq */
> -	struct hfi1_pkt_header hdr;
> -	struct sdma_txreq txreq;
> -	struct list_head list;
> -	struct user_sdma_request *req;
> -	u16 flags;
> -	unsigned busycount;
> -	u64 seqnum;
> -};
> -
> -#define SDMA_DBG(req, fmt, ...)				     \
> -	hfi1_cdbg(SDMA, "[%u:%u:%u:%u] " fmt, (req)->pq->dd->unit, \
> -		 (req)->pq->ctxt, (req)->pq->subctxt, (req)->info.comp_idx, \
> -		 ##__VA_ARGS__)
> -#define SDMA_Q_DBG(pq, fmt, ...)			 \
> -	hfi1_cdbg(SDMA, "[%u:%u:%u] " fmt, (pq)->dd->unit, (pq)->ctxt, \
> -		 (pq)->subctxt, ##__VA_ARGS__)
> -
>  static int user_sdma_send_pkts(struct user_sdma_request *req,
>  			       unsigned maxpkts);
>  static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status);
> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
> index 84c199d..6c10484 100644
> --- a/drivers/infiniband/hw/hfi1/user_sdma.h
> +++ b/drivers/infiniband/hw/hfi1/user_sdma.h
> @@ -53,6 +53,67 @@
>  #include "iowait.h"
>  #include "user_exp_rcv.h"
>
> +/* The maximum number of Data io vectors per message/request */
> +#define MAX_VECTORS_PER_REQ 8
> +/*
> + * Maximum number of packet to send from each message/request
> + * before moving to the next one.
> + */
> +#define MAX_PKTS_PER_QUEUE 16
> +
> +#define num_pages(x) (1 + ((((x) - 1) & PAGE_MASK) >> PAGE_SHIFT))
> +
> +#define req_opcode(x) \
> +	(((x) >> HFI1_SDMA_REQ_OPCODE_SHIFT) & HFI1_SDMA_REQ_OPCODE_MASK)
> +#define req_version(x) \
> +	(((x) >> HFI1_SDMA_REQ_VERSION_SHIFT) & HFI1_SDMA_REQ_OPCODE_MASK)
> +#define req_iovcnt(x) \
> +	(((x) >> HFI1_SDMA_REQ_IOVCNT_SHIFT) & HFI1_SDMA_REQ_IOVCNT_MASK)
> +
> +/* Number of BTH.PSN bits used for sequence number in expected rcvs */
> +#define BTH_SEQ_MASK 0x7ffull
> +
> +#define AHG_KDETH_INTR_SHIFT 12
> +#define AHG_KDETH_SH_SHIFT   13
> +#define AHG_KDETH_ARRAY_SIZE  9
> +
> +#define PBC2LRH(x) ((((x) & 0xfff) << 2) - 4)
> +#define LRH2PBC(x) ((((x) >> 2) + 1) & 0xfff)
> +
> +#define AHG_HEADER_SET(arr, idx, dw, bit, width, value)			\
> +	do {								\
> +		if ((idx) < ARRAY_SIZE((arr)))				\
> +			(arr)[(idx++)] = sdma_build_ahg_descriptor(	\
> +				(__force u16)(value), (dw), (bit),	\
> +							(width));	\
> +		else							\
> +			return -ERANGE;					\
> +	} while (0)

I know that this was in original code, but it violates Documentation/process/coding-style.rst
 687 12) Macros, Enums and RTL
....
 713 Things to avoid when using macros:
 714
 715 1) macros that affect control flow:
 716
 717 .. code-block:: c
 718
 719         #define FOO(x)                                  \
 720                 do {                                    \
 721                         if (blah(x) < 0)                \
 722                                 return -EBUGGERED;      \
 723                 } while (0)
 724
 725 is a **very** bad idea.  It looks like a function call but exits the ``calling``
 726 function; don't break the internal parsers of those who will read the code.



> +
> +/* Tx request flag bits */
> +#define TXREQ_FLAGS_REQ_ACK   BIT(0)      /* Set the ACK bit in the header */
> +#define TXREQ_FLAGS_REQ_DISABLE_SH BIT(1) /* Disable header suppression */
> +
> +#define SDMA_PKT_Q_INACTIVE BIT(0)
> +#define SDMA_PKT_Q_ACTIVE   BIT(1)
> +#define SDMA_PKT_Q_DEFERRED BIT(2)
> +
> +/*
> + * Maximum retry attempts to submit a TX request
> + * before putting the process to sleep.
> + */
> +#define MAX_DEFER_RETRY_COUNT 1
> +
> +#define SDMA_IOWAIT_TIMEOUT 1000 /* in milliseconds */
> +
> +#define SDMA_DBG(req, fmt, ...)				     \
> +	hfi1_cdbg(SDMA, "[%u:%u:%u:%u] " fmt, (req)->pq->dd->unit, \
> +		 (req)->pq->ctxt, (req)->pq->subctxt, (req)->info.comp_idx, \
> +		 ##__VA_ARGS__)
> +#define SDMA_Q_DBG(pq, fmt, ...)			 \
> +	hfi1_cdbg(SDMA, "[%u:%u:%u] " fmt, (pq)->dd->unit, (pq)->ctxt, \
> +		 (pq)->subctxt, ##__VA_ARGS__)
> +
>  extern uint extended_psn;
>
>  struct hfi1_user_sdma_pkt_q {
> @@ -79,6 +140,111 @@ struct hfi1_user_sdma_comp_q {
>  	struct hfi1_sdma_comp_entry *comps;
>  };
>
> +struct sdma_mmu_node {
> +	struct mmu_rb_node rb;
> +	struct hfi1_user_sdma_pkt_q *pq;
> +	atomic_t refcount;
> +	struct page **pages;
> +	unsigned int npages;
> +};
> +
> +struct user_sdma_iovec {
> +	struct list_head list;
> +	struct iovec iov;
> +	/* number of pages in this vector */
> +	unsigned int npages;
> +	/* array of pinned pages for this vector */
> +	struct page **pages;
> +	/*
> +	 * offset into the virtual address space of the vector at
> +	 * which we last left off.
> +	 */
> +	u64 offset;
> +	struct sdma_mmu_node *node;
> +};
> +
> +/* evict operation argument */
> +struct evict_data {
> +	u32 cleared;	/* count evicted so far */
> +	u32 target;	/* target count to evict */
> +};
> +
> +struct user_sdma_request {
> +	/* This is the original header from user space */
> +	struct hfi1_pkt_header hdr;
> +
> +	/* Read mostly fields */
> +	struct hfi1_user_sdma_pkt_q *pq ____cacheline_aligned_in_smp;
> +	struct hfi1_user_sdma_comp_q *cq;
> +	/*
> +	 * Pointer to the SDMA engine for this request.
> +	 * Since different request could be on different VLs,
> +	 * each request will need it's own engine pointer.
> +	 */
> +	struct sdma_engine *sde;
> +	struct sdma_req_info info;
> +	/* TID array values copied from the tid_iov vector */
> +	u32 *tids;
> +	/* total length of the data in the request */
> +	u32 data_len;
> +	/* number of elements copied to the tids array */
> +	u16 n_tids;
> +	/*
> +	 * We copy the iovs for this request (based on
> +	 * info.iovcnt). These are only the data vectors
> +	 */
> +	u8 data_iovs;
> +	s8 ahg_idx;
> +
> +	/* Writeable fields shared with interrupt */
> +	u64 seqcomp ____cacheline_aligned_in_smp;
> +	u64 seqsubmitted;
> +	/* status of the last txreq completed */
> +	int status;
> +
> +	/* Send side fields */
> +	struct list_head txps ____cacheline_aligned_in_smp;
> +	u64 seqnum;
> +	/*
> +	 * KDETH.OFFSET (TID) field
> +	 * The offset can cover multiple packets, depending on the
> +	 * size of the TID entry.
> +	 */
> +	u32 tidoffset;
> +	/*
> +	 * KDETH.Offset (Eager) field
> +	 * We need to remember the initial value so the headers
> +	 * can be updated properly.
> +	 */
> +	u32 koffset;
> +	u32 sent;
> +	/* TID index copied from the tid_iov vector */
> +	u16 tididx;
> +	/* progress index moving along the iovs array */
> +	u8 iov_idx;
> +	u8 done;
> +	u8 has_error;
> +
> +	struct user_sdma_iovec iovs[MAX_VECTORS_PER_REQ];
> +} ____cacheline_aligned_in_smp;
> +
> +/*
> + * A single txreq could span up to 3 physical pages when the MTU
> + * is sufficiently large (> 4K). Each of the IOV pointers also
> + * needs it's own set of flags so the vector has been handled
> + * independently of each other.
> + */
> +struct user_sdma_txreq {
> +	/* Packet header for the txreq */
> +	struct hfi1_pkt_header hdr;
> +	struct sdma_txreq txreq;
> +	struct list_head list;
> +	struct user_sdma_request *req;
> +	u16 flags;
> +	unsigned int busycount;
> +	u64 seqnum;
> +};
> +
>  int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
>  				struct hfi1_filedata *fd);
>  int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--c1qHkdEbEbCG94PZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmcUGkACgkQ5GN7iDZy
WKd4jw/9FIwnc3GV1v619pOTtYub6NTveB9bZ6bUx14vTaxhu0eG3PQCoIMOH4zC
S86YP8cCqbb0yk+wdjaGwZsNAhakn1fQny8aWcE2zQCAfw1yGi7ZrtUZlWYnAieb
FY84u1i3098vrtJNBKxwJFtNyV7sKjhJMnTX0yMlefVuNiIIP8ObvVXOEq82lEG0
RhMulsGNuFT9oJoSdMOwelbZrG5mP6yEctDvluqjVXx9EysFrrVr22I+hWRgWr5N
lrwaSQciXlXhfVH3hj8Eq+MVr2QNbipyecOCcj2QNM69mBhJwkJX7hm+z8kC3kBf
sTTL5/MDOQHHj0GQvqcy0nrxADEfhpqWWZASNkslRIt7/oB79WM+nZYg4K+r3rbv
PKdD37pAku8Lwy4neGtNVd6JWkxaa2aFn9uZaSES3pY0Qf+vabgcsnisd/qujmKW
yG6JwsWLPMbbIty2TJB9sSnhwCMMz38AitXZDj+AGsMSfV7CyjnJoOnEPtnK2z2i
9kzYWRbrNrWyXxEkJGg5mx+f7zKxPTP9ebwgWtTjdJFnGywB0kC9WyWB0OHdnBo8
+a8391efEQF2hj5Gy9jMo7ppeSahifJY/2xoPi2glTkyL6gtyYMgW69aOH4HdQfN
VNurbQqs6/Cfaik2bpRCJYe42R8QKbReLR8XSZO4d5XbLT1PXKQ=
=dz8f
-----END PGP SIGNATURE-----

--c1qHkdEbEbCG94PZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
