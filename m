From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] IB/hfi1, rdmavt, qib: patches for next
 07/29/2017
Date: Mon, 31 Jul 2017 15:27:14 -0400
Message-ID: <1501529234.2725.6.camel@redhat.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-07-29 at 08:43 -0700, Dennis Dalessandro wrote:
> Hi Doug,
> 
> Here is the next set of patches our our drivers for 4.14.  There are
> a couple
> patches for link bugs and a bug fix from Mike for SGE compression.
> This fixes an
> issue in a previous commit that we sent for 4.14, since it's already
> in your
> tree on kernel.org I have included a fixes line. There are three
> other minor
> fixes as well.
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.14
> 
> ---
> 
> Alex Estrin (1):
>       IB/hfi1: Harden state transition to Armed and Active
> 
> Jan Sokolowski (2):
>       IB/hfi1: Do not enable disabled port on cable insert
>       IB/hfi1: Disambiguate corruption and uninitialized error cases
> 
> Michael J. Ruhl (1):
>       IB/hfi1: Only set fd pointer when base context is completely
> initialized
> 
> Mike Marciniszyn (1):
>       IB/{rdmavt, hfi1, qib}: Fix panic with post receive and SGE
> compression
> 
> Sebastian Sanchez (3):
>       IB/hfi1: Create workqueue for link events
>       IB/hfi1: Prevent link down request double queuing
>       IB/hfi1: Always perform offline transition
> 
> 
>  drivers/infiniband/hw/hfi1/chip.c         |  112 +++++++++++++++--
> ------------
>  drivers/infiniband/hw/hfi1/chip.h         |    5 +
>  drivers/infiniband/hw/hfi1/driver.c       |    2 -
>  drivers/infiniband/hw/hfi1/file_ops.c     |   55 ++++++++------
>  drivers/infiniband/hw/hfi1/firmware.c     |    8 ++
>  drivers/infiniband/hw/hfi1/hfi.h          |    2 +
>  drivers/infiniband/hw/hfi1/init.c         |   26 +++++++
>  drivers/infiniband/hw/hfi1/pio.c          |    2 -
>  drivers/infiniband/hw/hfi1/platform.c     |   14 ++--
>  drivers/infiniband/hw/hfi1/ruc.c          |    6 +-
>  drivers/infiniband/hw/hfi1/sdma.c         |    2 -
>  drivers/infiniband/hw/hfi1/user_exp_rcv.c |    4 +
>  drivers/infiniband/hw/hfi1/user_exp_rcv.h |    3 +
>  drivers/infiniband/hw/hfi1/user_sdma.c    |    4 +
>  drivers/infiniband/hw/hfi1/user_sdma.h    |    3 +
>  drivers/infiniband/hw/qib/qib_ruc.c       |    6 +-
>  drivers/infiniband/sw/rdmavt/mr.c         |    8 +-
>  drivers/infiniband/sw/rdmavt/qp.c         |   16 ++--
>  18 files changed, 166 insertions(+), 112 deletions(-)
> 

Hi Denny,

Series applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
