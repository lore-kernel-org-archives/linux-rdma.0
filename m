From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 00/15 ibacm] ACM Cache Preloading (and some cosmetic
 cleanups)
Date: Fri, 28 Jun 2013 01:46:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD37549@ORSMSX109.amr.corp.intel.com>
References: <51C43267.1030301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C43267.1030301-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Patches 1-9 clean up documentation and sample config files.

Rather than trying to keep the sample ibacm_addr/opts files in sync, I elected to remove them from the git tree.  There's really no use for them, and I don't think they're included with the released package anyway.

Doing this drops patches 2, 4, 5, 6, and part of 7.  I applied 1, 8, 9, and the remainder of 7.  I'll comment on 3 separately.  Patches 10-15 are still pending.

Thanks,
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
