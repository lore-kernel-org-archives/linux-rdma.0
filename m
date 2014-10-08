From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rsocket: Return ECONNRESET when socket in recv is
 disconnected
Date: Wed, 8 Oct 2014 23:38:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DE77F8@ORSMSX109.amr.corp.intel.com>
References: <1412806773-23776-1-git-send-email-sean.hefty@intel.com>
 <20141008232827.GA16102@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141008232827.GA16102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> stackoverflow suggets:
> 
> http://stackoverflow.com/questions/2974021/what-does-econnreset-mean-in-
> the-context-of-an-af-local-socket
> 
> Which looks reasonable to me and matches my experience with socket
> programming on Linux. The Steven's book might have some authoritative
> clarifications on the subject as well.
> 
> It certainly is not correct to unconditionally return ECONNRESET for
> reads on far-end-closed sockets, they should typically return 0.

Thanks for the info. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
