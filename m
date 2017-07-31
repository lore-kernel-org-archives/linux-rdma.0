From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/13] IB/hfi1: patches for next 07/24/2017
Date: Mon, 31 Jul 2017 15:20:54 -0400
Message-ID: <1501528854.2725.3.camel@redhat.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-24 at 07:45 -0700, Dennis Dalessandro wrote:
> Hi Doug,
> 
> Here is a set of patches for 4.14. These apply on top of the others I
> have sent
> previously. This fixes some performance centric bugs like using write
> combining
> for bar0 mapping and a fix for not starving an iowait list. There are
> also a few
> patches related to improving the code involving user contexts. A bug
> to fix
> sending MAD traps until repressed is also included as well as some
> general code
> cleanups. 
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.14
> 
> ---
> 
> Alex Estrin (1):
>       IB/hfi1: Verify port data VLs credits on transition to Armed
> 
> Bartlomiej Dudek (1):
>       IB/hfi1: Move saving PCI values to a separate function
> 
> Byczkowski, Jakub (1):
>       IB/hfi1: Fix initialization failure for debug firmware
> 
> Jan Sokolowski (1):
>       IB/hfi1: Fix code consistency for if/else blocks in chip.c
> 
> Kaike Wan (1):
>       IB/hfi1: Serve the most starved iowait entry first
> 
> Michael J. Ruhl (7):
>       IB/hfi1: Assign context does not clean up file descriptor
> correctly on error
>       IB/hfi1: Remove unused user context data members
>       IB/hfi1: Size rcd array index correctly and consistently
>       IB/hfi1: Use context pointer rather than context index
>       IB/hfi1: Pass the context pointer rather than the index
>       IB/hfi1: Send MAD traps until repressed
>       IB/hfi1: Split copy_to_user data copy for better security
> 
> Mike Marciniszyn (1):
>       IB/hfi1: Fix bar0 mapping to use write combining


Series applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
