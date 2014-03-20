From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/8] Misc. fixes for iw_cxgb4
Date: Thu, 20 Mar 2014 13:34:43 -0500
Message-ID: <011501cf446b$0ff18670$2fd49350$@opengridcomputing.com>
References: <1395231285-4495-1-git-send-email-hariprasad@chelsio.com> <CAL1RGDUXDjLGuwe9Z5V+cci9gya9NgdLNtJErH0mW-Z12++0rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUXDjLGuwe9Z5V+cci9gya9NgdLNtJErH0mW-Z12++0rA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Kumar SANGHVI' <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Thanks, applied all except
> 
>   iw_cxgb4: use the BAR2/WC path for kernel QPs and T5 devices
> 
> which doesn't apply to my tree (seems to depend on patches only in net-next).

Perhaps you can hang onto this patch and apply it once net-next gets merged into Linus'
tree?  Then it will apply cleanly.

Thanks,

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
