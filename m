From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and ipoib_path -when will it go upstream?
Date: Mon, 12 Jul 2010 14:21:25 -0700
Message-ID: <adapqysxup6.fsf@roland-alpha.cisco.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3AA0A2.3090406-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> (Pradeep Satyanarayana's
	message of "Sun, 11 Jul 2010 21:57:06 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I realize that the following patch: 
 > 
 > https://patchwork.kernel.org/patch/97243/
 > 
 > is queued in your backlog of patches and unlikely that it will go into 2.6.35.
 > What are the chances that it will make it into 2.6.36? This patch has fixed a
 > a rarely seen crash and we would like it to go upstream ASAP.

How much testing and/or review have you done for this patch?  What is
the impact of the bug in the cases you have seen?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
