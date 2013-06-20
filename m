From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 20 Jun 2013 17:09:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD358BC@ORSMSX109.amr.corp.intel.com>
References: <1371502807-17026-1-git-send-email-jsquyres@cisco.com>
 <20130618184928.GE2204@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6939C5@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6939C5-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I used the name "num_to_ibv_mtu" because it is in the spirit of the other enum-
> to-int/int-to-enum function pair naming conventions:
> 
> int ibv_rate_to_mult(enum ibv_rate rate);
> enum ibv_rate mult_to_ibv_rate(int mult);
> 
> int ibv_rate_to_mbps(enum ibv_rate rate);
> enum ibv_rate mbps_to_ibv_rate(int mbps);

libibverbs uses the "ibv_" prefix for pretty much everything.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
