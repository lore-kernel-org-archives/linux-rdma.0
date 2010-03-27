From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port	reservation to support AF_IB
Date: Fri, 26 Mar 2010 18:01:13 -0700
Message-ID: <426B041531C140BFB9CACD9C584C601B@amr.corp.intel.com>
References: <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com> <20100325202924.GO29129@obsidianresearch.com> <AC26D518E7AE4BE6BA3BDFC11480F8DB@amr.corp.intel.com> <20100325220435.GP29129@obsidianresearch.com> <C70579E21917462C89AAEAE3C225A58B@amr.corp.intel.com> <FD7DFBFAF86D4EA99F82836CBCA8AB33@amr.corp.intel.com> <20100326040809.GD9769@obsidianresearch.com> <57287E48AAAD47A4BD50719B889F4596@amr.corp.intel.com> <350558935FCC47B6A5ABA8402109746C@amr.corp.intel.com> <0F1BE18DBBF74165AEA2B3283B01F338@amr.corp.intel.com> <20100327004440.GE9769@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100327004440.GE9769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>How does UD operation work with the SID anyhow?

Not sure what you mean here.  The passive side listens on a SID.  Either a REQ
or SIDR REQ can match with that.  For UD, the expectation is that it will be a
SIDR REQ.  (The rdma cm needs a changed to reject whichever is unexpected.)

>So where does ai_qp_type get stuffed in user space?

Right now, there's a new call:

int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr);

Based on whether RAI_PASSIVE flag is set and the input parameters, this provides
functionality similar to:

rdma_create_id / rdma_bind_addr 
or
rdma_create_id / rdma_resolve_addr / rdma_resolve_route / rdma_create_qp

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
