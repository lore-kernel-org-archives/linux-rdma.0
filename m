From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and ipoib_path -when will it go upstream?
Date: Tue, 13 Jul 2010 07:45:48 -0700
Message-ID: <adaeif7xwwz.fsf@roland-alpha.cisco.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com>
	<adapqysxup6.fsf@roland-alpha.cisco.com>
	<4C3C02B2.9040408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3C02B2.9040408-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> (Pradeep Satyanarayana's
	message of "Mon, 12 Jul 2010 23:07:46 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I guess I came to a premature conclusion. One set of tests ran fine and I made that
 > conclusion. Another set of tests caused the following crash:

I don't really know how to interpret this.  Is this crash new, or is it
the same crash you were hoping this patch fixed?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
