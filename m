From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: IB/ipoib: fix dangling pointer reference to ipoib_neigh and ipoib_path
 -when will it go upstream?
Date: Sun, 11 Jul 2010 21:57:06 -0700
Message-ID: <4C3AA0A2.3090406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

I realize that the following patch: 

https://patchwork.kernel.org/patch/97243/

is queued in your backlog of patches and unlikely that it will go into 2.6.35.
What are the chances that it will make it into 2.6.36? This patch has fixed a
a rarely seen crash and we would like it to go upstream ASAP.

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
