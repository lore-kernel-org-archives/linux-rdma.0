From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 09/23] verbs: Fix incorrect type of len
Date: Thu, 22 Sep 2016 16:02:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB08E091@ORSMSX109.amr.corp.intel.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474495729-17604-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-10-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> gcc remarks:
> 
> ../librdmacm/examples/udpong.c:301:11: warning: comparison of unsigned
> expression < 0 is always false [-Wtype-limits]
>    if (len < 0)
> 
> len is set by:
> 		len = svr_recv(&msg, sizeof msg, &addr, &addrlen);
> 
> And svr_recv returns:
> 
> static ssize_t svr_recv(struct message *msg, size_t size,
> 
> So clearly len is the wrong type, and the error test does
> not work.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
