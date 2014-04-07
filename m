From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] NFS-RDMA: fix qp pointer validation checks
Date: Mon, 7 Apr 2014 23:45:38 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FDE9AE4@CMEXMB1.ad.emulex.com>
References: <d4afd436-8e14-4729-9bc1-71ab9079a246@CMEXHTCAS1.ad.emulex.com>
 <61E8946F-3722-4707-A948-065D395C365A@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <61E8946F-3722-4707-A948-065D395C365A-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi
Inline Below:

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org] 
Sent: Tuesday, April 08, 2014 4:58 AM
To: Devesh Sharma
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] NFS-RDMA: fix qp pointer validation checks


On Apr 7, 2014, at 18:30, devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:

> From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> 
> If the rdma_create_qp fails to create qp due to device firmware being 
> in invalid state xprtrdma still tries to destroy the non-existant qp 
> and ends up in a NULL pointer reference crash.
> Adding proper checks for vaidating QP pointer avoids this to happen.
> 

As far as I can see, rdma_create_qp() only sets id->qp on success. Otherwise it is left with the same value as it had on entry (i.e. NULL). What am I missing?
[DS]: If you focus on rpcrdma_ep_connect() function and assume that rdma_create_qp() has failed with some valid error code, then this callback function will return ep->rep_connected = some non-zero.
Eventually xprt_rdma_connect_worker() will call rpcrdma_ep_connect() again and rpcrdma_ep_connect will try to free-up all the resources, now rdma_destroy_qp() will be called with invalid QP (which is NULL) pointer
And hence kernel will panic. Please correct me if I am worng.

_________________________________
Trond Myklebust
Linux NFS client maintainer, PrimaryData trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
