From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 05/10] iw_cxgb4: Add connection management functions.
Date: Wed, 07 Apr 2010 16:49:45 -0500
Message-ID: <4BBCFDF9.70306@opengridcomputing.com>
References: <20100402192346.14117.92767.stgit@build.ogc.int>	<20100402192413.14117.56138.stgit@build.ogc.int> <adaljcz0x0g.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaljcz0x0g.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > +int peer2peer = 0;
>  > +module_param(peer2peer, int, 0644);
>  > +MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=0)");
>
> If you build iw_cxgb3 and iw_cxgb4 into the kernel, the peer2peer symbol
> names clash.  (Same problem occurs if you try to load cxgb3 and cxgb4
> modules at the same time, I think).  


Both iw_cxgb3 and iw_cxgb4 load ok concurrently when compiled as modules.


The option was originally intended to be used in more than just cm.c.  
So there's a piece of code missing in qp.c.  I'll clean this up.   I 
might make an attribute in c4iw_endpoint that indicates this mode.  Then 
the qp code won't need the global option and can key off the endpoint 
attribute.   So I can make this a static as you suggest.


> We can fix it here in cxgb4 by just
> making peer2peer static (and deleting the extern declaration).
>
> However peer2peer is not that great of a name for a global symbol; might
> be good to add a patch to cxgb3 to rename peer2peer to something like
> iwch_peer2peer and using module_param_named()... 
>   


I'll do this for cxgb3.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
