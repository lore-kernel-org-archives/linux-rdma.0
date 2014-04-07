From: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH] NFS-RDMA: fix qp pointer validation checks
Date: Mon, 7 Apr 2014 19:27:57 -0400
Message-ID: <61E8946F-3722-4707-A948-065D395C365A@primarydata.com>
References: <d4afd436-8e14-4729-9bc1-71ab9079a246@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d4afd436-8e14-4729-9bc1-71ab9079a246-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Apr 7, 2014, at 18:30, devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:

> From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> 
> If the rdma_create_qp fails to create qp due to device firmware being in invalid state
> xprtrdma still tries to destroy the non-existant qp and ends up in a NULL pointer reference
> crash.
> Adding proper checks for vaidating QP pointer avoids this to happen.
> 

As far as I can see, rdma_create_qp() only sets id->qp on success. Otherwise it is left with the same value as it had on entry (i.e. NULL). What am I missing?

_________________________________
Trond Myklebust
Linux NFS client maintainer, PrimaryData
trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
