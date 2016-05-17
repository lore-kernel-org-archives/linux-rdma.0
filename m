From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v1 1/1] [librdmacm] examples/rping.c: fix unwanted abort during qp creation
Date: Tue, 17 May 2016 11:18:43 -0500
Message-ID: <007601d1b057$c838bd20$58aa3760$@opengridcomputing.com>
References: <1462779876-9480-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462779876-9480-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Memset rping control block structure to 0 to avoid accessing garbage
> values in the upcoming checks in librdmacm causing unwanted abort during
> creation of qp.
> 
> Fixes: b873915aee7b ("librdmacm/rping: Persistent rping server")
> 
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Looks good.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Sean, does this look good to merge?

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
