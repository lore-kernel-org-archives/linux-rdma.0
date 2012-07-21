From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: uverbs message alignment
Date: Sat, 21 Jul 2012 05:15:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A6BE19@ORSMSX101.amr.corp.intel.com>
References: <5009D0AF.1090409@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5009D0AF.1090409-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> struct c4iw_create_raw_qp_req {
>          struct ibv_create_qp ibv_req;
>          __u32 port;
>          __u32 vlan_pri;
>          __u32 nfids;
> };

struct ibv_create_qp contains a u64, which will force the size of the structure to 64-bit.  You should to add an additional 32-bits of padding.

> struct ibv_create_qp {
>          __u32 command;
>          __u16 in_words;
>          __u16 out_words;
>          __u64 response;
>          __u64 user_handle;

these last two fields force the alignment

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
