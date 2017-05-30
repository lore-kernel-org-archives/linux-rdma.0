From: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 2/9] IB/hfi1: Optimize cachelines for user SDMA
 request structure
Date: Tue, 30 May 2017 17:55:20 +0000
Message-ID: <5CDA63463B33C94CA80846587415F0770408CAF7@ORSMSX111.amr.corp.intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
 <20170526123517.8158.80658.stgit@scvm10.sc.intel.com>
 <20170529161657.GC17751@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170529161657.GC17751-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Out of curiosity, do you have pahole data before vs. after to share?

Yes, below is the pahole output for this patch.

Sebastian

---------

Before:


struct user_sdma_request {
	struct sdma_req_info       info;                 /*     0     8 */
	struct hfi1_user_sdma_pkt_q * pq;                /*     8     8 */
	struct hfi1_user_sdma_comp_q * cq;               /*    16     8 */
	struct hfi1_pkt_header     hdr;                  /*    24    64 */
	/* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
	struct sdma_engine *       sde;                  /*    88     8 */
	s8                         ahg_idx;              /*    96     1 */

	/* XXX 3 bytes hole, try to pack */

	u32                        ahg[9];               /*   100    36 */
	/* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
	u32                        koffset;              /*   136     4 */
	u32                        tidoffset;            /*   140     4 */
	unsigned int               data_iovs;            /*   144     4 */
	u32                        data_len;             /*   148     4 */
	unsigned int               iov_idx;              /*   152     4 */

	/* XXX 4 bytes hole, try to pack */

	struct user_sdma_iovec     iovs[8];              /*   160   512 */
	/* --- cacheline 10 boundary (640 bytes) was 32 bytes ago --- */
	u16                        n_tids;               /*   672     2 */

	/* XXX 6 bytes hole, try to pack */

	u32 *                      tids;                 /*   680     8 */
	u16                        tididx;               /*   688     2 */

	/* XXX 2 bytes hole, try to pack */

	u32                        sent;                 /*   692     4 */
	u64                        seqnum;               /*   696     8 */
	/* --- cacheline 11 boundary (704 bytes) --- */
	u64                        seqcomp;              /*   704     8 */
	u64                        seqsubmitted;         /*   712     8 */
	struct list_head           txps;                 /*   720    16 */
	long unsigned int          flags;                /*   736     8 */
	int                        status;               /*   744     4 */

	/* size: 752, cachelines: 12, members: 23 */
	/* sum members: 733, holes: 4, sum holes: 15 */
	/* padding: 4 */
	/* last cacheline: 48 bytes */
};

After:

struct user_sdma_request {
	struct hfi1_pkt_header     hdr;                  /*     0    64 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct hfi1_user_sdma_pkt_q * pq;                /*    64     8 */
	struct hfi1_user_sdma_comp_q * cq;               /*    72     8 */
	struct sdma_engine *       sde;                  /*    80     8 */
	struct sdma_req_info       info;                 /*    88     8 */
	u32 *                      tids;                 /*    96     8 */
	u32                        data_len;             /*   104     4 */
	u16                        n_tids;               /*   108     2 */
	u8                         data_iovs;            /*   110     1 */
	s8                         ahg_idx;              /*   111     1 */

	/* XXX 16 bytes hole, try to pack */

	/* --- cacheline 2 boundary (128 bytes) --- */
	u64                        seqcomp;              /*   128     8 */
	u64                        seqsubmitted;         /*   136     8 */
	long unsigned int          flags;                /*   144     8 */
	int                        status;               /*   152     4 */

	/* XXX 36 bytes hole, try to pack */

	/* --- cacheline 3 boundary (192 bytes) --- */
	struct list_head           txps;                 /*   192    16 */
	u64                        seqnum;               /*   208     8 */
	u32                        tidoffset;            /*   216     4 */
	u32                        koffset;              /*   220     4 */
	u32                        sent;                 /*   224     4 */
	u16                        tididx;               /*   228     2 */
	u8                         iov_idx;              /*   230     1 */

	/* XXX 1 byte hole, try to pack */

	struct user_sdma_iovec     iovs[8];              /*   232   512 */
	/* --- cacheline 11 boundary (704 bytes) was 40 bytes ago --- */

	/* size: 768, cachelines: 12, members: 22 */
	/* sum members: 691, holes: 3, sum holes: 53 */
	/* padding: 24 */
};
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
