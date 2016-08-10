From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] IB/hfi1: Using kfree_rcu() to simplify the code
Date: Wed, 10 Aug 2016 17:07:50 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2D09FFB2@fmsmsx120.amr.corp.intel.com>
References: <1470649818-30040-1-git-send-email-weiyj.lk@gmail.com>
 <1470798844-30421-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470798844-30421-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Wei Yongjun [mailto:weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Subject: [PATCH v2] IB/hfi1: Using kfree_rcu() to simplify the code
> 
> The callback function of call_rcu() just calls a kfree(), so we can use
> kfree_rcu() instead of call_rcu() + callback function.
> 
> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[resent, didn't make the list]

Tested-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
