From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next v3 00/24] RDMA core, drivers and
 IPoIB fixes
Date: Thu, 24 Aug 2017 16:52:16 -0400
Message-ID: <1503607936.78641.56.camel@redhat.com>
References: <20170817125055.31424-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> Hi,
> 
> This is bunch of fixes to the RDMA stack which we found during code
> review,
> static checkers cleanups and by various code inspections.
> 
> There is one exception to this batch - patch from Feras to add
> statistics support to SRIOV VF in IPoIB.
> 
> However, the diff stat of that change is so small and I didn't find
> other batch to attach it.
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> Thanks

Modulo the notes I sent on the individual patches, I've pulled this
series in.  But, I would note that our trees were well out of sync on
this one and that led to a lot of hand fixes and merges.  Not that I
can't do it, but it makes me nervous that what I fix up won't be right
for the new patch in some way.  So please double check the mellanox
branch on github to make sure that you're happy with how I fixed
everything up.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
