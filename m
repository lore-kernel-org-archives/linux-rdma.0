From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] amso1100: Add missing memset
Date: Wed, 21 Apr 2010 16:31:36 -0700
Message-ID: <ada39yoo013.fsf@roland-alpha.cisco.com>
References: <20100414142015.GA16260@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100414142015.GA16260@vlad-laptop> (Vladimir Sokolovsky's
	message of "Wed, 14 Apr 2010 17:20:15 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I think this patch is actually not needed.  c2_rnic_query() is only
called for the c2dev->props memory, and c2dev is allocated with
ib_alloc_device, which will always zero it out.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
