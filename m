From: Steve Wise <swise-10udUCx4aRo@public.gmane.org>
Subject: rdma provider module references
Date: Wed, 15 Dec 2010 10:15:05 -0600
Message-ID: <4D08E989.5020307@aoot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

I notice that if I have a user rdma application running that has an rdma connection using iw_cxgb3, then the iw_cxgb3 
module reference count is bumped and thus it cannot be unloaded.  However when I have an NFSRDMA connection that 
utilizes iw_cxgb3, the module reference count is not bumped, and iw_cxgb3 can erroneously be unloaded while the NFSRDMA 
connection is still active, causing a crash.

My question is more of what is the right thing to do here.

Should the module refcnt be the way to prohibit a provider from being unloaded?

Thoughts?

Thanks,

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
