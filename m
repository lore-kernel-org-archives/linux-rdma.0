From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: change PCI bar addr assignments to Linux API
 functions
Date: Wed, 10 May 2017 15:20:42 -0400
Message-ID: <c68176e5-cfa0-ea39-e52f-5fe8ba974d5f@intel.com>
References: <1494442093-3590-1-git-send-email-robers97@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494442093-3590-1-git-send-email-robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/10/2017 2:48 PM, Steven L. Roberts wrote:
> From: "Steven L. Roberts" <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> The Ominpath adapter driver fails to load the ppc64le platform
> due to invalid PCI setup.

Omnipath -> Omni-Path


> This patch makes the PCI configuration more robust and will
> fixes 64 bit addressing for ppc64le.

fixes -> fix

> Signed-off-by: Steven L Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Please touch up those two typos and add:

Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks for the patch!

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
