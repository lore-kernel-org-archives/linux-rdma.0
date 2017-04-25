From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 00/10] ODP Fixes and Improvements
Date: Tue, 25 Apr 2017 15:41:13 -0400
Message-ID: <1493149273.3041.93.camel@redhat.com>
References: <20170405062359.26623-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405062359.26623-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-05 at 09:23 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> Please find the following patch set from Artemy. This patch set fixes
> and extends ODP support.
> 
> This patch set has the following steps:
> 
> 1. Code simplification for all IB drivers.
> 2. Three fixes to existing ODP code.
> 3. Adds generic infrastructure for regions consisting of physically
>    contiguous chunks of arbitrary order. Utilizing this
> infrastructure
>    added specific treatment to ODP MRs allocated with MAP_HUGETLB.
> 4. Adds ODP suport to Memory Windows (MW). Memory windows allow the
>    application to have more flexible control over access to its
> memory.
>    The operation of associating an MW with an MR is called binding.
> When
>    MW is bound to ODP MR it may cause page fault which should be
>    properly handled.
> 
> Thanks

Series applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
