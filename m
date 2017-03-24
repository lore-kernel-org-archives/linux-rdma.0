From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: Fix alignment of mmap cookies to support
 VIPT caching
Date: Fri, 24 Mar 2017 16:51:26 -0400
Message-ID: <1490388686.2404.25.camel@redhat.com>
References: <20170310183420.GA7410@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170310183420.GA7410-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-03-10 at 11:34 -0700, Jason Gunthorpe wrote:
> When vmalloc_user is used to create memory that is supposed to be
> mmap'd
> to user space, it is necessary for the mmap cookie (eg the offset) to
> be
> aligned to SHMLBA.
> 
> This creates a situation where all virtual mappings of the same
> physical
> page share the same virtual cache index and guarantees VIPT
> coherence.
> Otherwise the cache is non-coherent and the kernel will not see
> writes
> by userspace when reading the shared page (or vice-versa).
> 
> Reported-by: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 

Thanks, applied for -rc.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
