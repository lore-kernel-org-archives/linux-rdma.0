From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
Date: Fri, 13 Nov 2015 10:47:52 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB1857D86D@CRSMSX101.amr.corp.intel.com>
References: <2807E5FD2F6FDA4886F6618EAC48510E1CBD4369@CRSMSX101.amr.corp.intel.com>
 <1447400547-11490-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447400547-11490-1-git-send-email-saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I don't think so. 

The following patch has rendered this patch unnecessary:

https://patchwork.kernel.org/patch/7526811/

Kaike

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Saurabh Sengar
> Sent: Friday, November 13, 2015 2:42 AM
> To: Weiny, Ira; Wan, Kaike
> Cc: Hefty, Sean; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
> 
> On Wed, 28 Oct 2015  at 04:30:10 +0000, Weiny, Ira wrote:
> > Until we can remove the spinlock the current proposed patch should be
> > applied in the interim.  Sorry for the noise before.
> 
> > Reviewed-By: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Hi,
> 
> is this patch expected to be applied ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
