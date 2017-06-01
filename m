From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: change PCI bar addr assignments to Linux API
 functions
Date: Thu, 01 Jun 2017 18:06:37 -0400
Message-ID: <1496354797.7171.55.camel@redhat.com>
References: <1494446293-60448-1-git-send-email-robers97@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494446293-60448-1-git-send-email-robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-10 at 14:58 -0500, Steven L. Roberts wrote:
> The Omni-path adapter driver fails to load the ppc64le platform
> due to invalid PCI setup.
> 
> This patch makes the PCI configuration more robust and will
> fix 64 bit addressing for ppc64le.
> 
> Signed-off-by: Steven L Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
