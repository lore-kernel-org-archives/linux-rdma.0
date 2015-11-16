From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 4/9] IB: remove in-kernel support for memory windows
Date: Mon, 16 Nov 2015 19:41:10 +0100
Message-ID: <20151116184110.GA2015@lst.de>
References: <1447610762-3781-1-git-send-email-hch@lst.de> <1447610762-3781-5-git-send-email-hch@lst.de> <564A0B96.5010703@dev.mellanox.co.il> <20151116170258.GA32300@lst.de> <564A2187.3060000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564A2187.3060000-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Before we expose any new opcodes to userspace we need to actually
move the defintions of user visible opcodes to a uapi header.  Without
that we're doomed to regularly break the ABI.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
