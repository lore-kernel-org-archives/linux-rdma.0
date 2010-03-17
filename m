From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: adding path record wire format to libibverbs
Date: Wed, 17 Mar 2010 10:48:30 -0700
Message-ID: <77007DB2D13246B9A031DE3B0094C024@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Would you accept a patch to libibverbs sa.h to add the wire format for a path
record, shown below?  I'm not ready to submit a patch yet, just need to find a
place for this.

- Sean


#define IB_PATH_RECORD_REVERSIBLE 0x80

struct ib_path_record
{
	uint64_t        service_id;
	union ibv_gid   dgid;
	union ibv_gid   sgid;
	uint16_t        dlid;
	uint16_t        slid;
	uint32_t        flowlabel_hoplimit; /* resv-31:28 flow label-27:8 hop
limit-7:0*/
	uint8_t         tclass;
	uint8_t         reversible_numpath; /* reversible-7:7 num path-6:0 */
	uint16_t        pkey;
	uint16_t        qosclass_sl;        /* qos class-15:4 sl-3:0 */
	uint8_t         mtu;                /* mtu selector-7:6 mtu-5:0 */
	uint8_t         rate;               /* rate selector-7:6 rate-5:0 */
	uint8_t         packetlifetime;     /* lifetime selector-7:6
lifetime-5:0 */
	uint8_t         preference;
	uint8_t         reserved[6];
};

#define IB_PATH_FLAGS_CM              (1<<0)
#define IB_PATH_FLAGS_PRIMARY         (1<<1)
#define IB_PATH_FLAGS_ALTERNATE       (1<<2)
#define IB_PATH_FLAGS_OUTBOUND        (1<<3)
#define IB_PATH_FLAGS_INBOUND         (1<<4)
#define IB_PATH_FLAGS_INBOUND_REVERSE (1<<5)
#define IB_PATH_FLAGS_BIDIRECTIONAL   (IB_PATH_FLAGS_OUTBOUND |     \
                                       IB_PATH_FLAGS_INBOUND_REVERSE)

struct ib_path_data
{
	uint32_t              flags;
	uint32_t              reserved;
	struct ib_path_record path;
};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
