From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc 0/7] IB/hfi1: Fixes for RC
Date: Wed, 27 Sep 2017 11:15:54 -0400
Message-ID: <1506525354.33755.0.camel@redhat.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926130434.31476.81826.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 06:05 -0700, Dennis Dalessandro wrote:
> Here are our first batch of patches for 4.14 RC cycle. These all fix
> bugs and
> most are pretty straight forward.
> 
> However, of note is a revert by Alex for an IPoIB patch. This has
> been marked
> stable as well. 
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.14
> 
> ---
> 
> Alex Estrin (1):
>       Revert "IB/ipoib: Update broadcast object if PKey value was
> changed in index 0"
> 
> Harish Chegondi (1):
>       IB/hfi1: Unsuccessful PCIe caps tuning should not fail driver
> load
> 
> Jan Sokolowski (1):
>       IB/hfi1: Check eeprom config partition validity
> 
> Kamenee Arumugam (1):
>       IB/hfi1: Return correct value in general interrupt handler
> 
> Michael J. Ruhl (1):
>       IB/hfi1: On error, fix use after free during user context setup
> 
> Sebastian Sanchez (2):
>       IB/hfi1: Turn off AOC TX after offline substates
>       IB/hfi1: Only reset QSFP after link up and turn off AOC TX
> 
> 
>  drivers/infiniband/hw/hfi1/chip.c       |  101
> ++++++++++++++++++++++++-------
>  drivers/infiniband/hw/hfi1/chip.h       |    3 +
>  drivers/infiniband/hw/hfi1/eprom.c      |   20 +++++-
>  drivers/infiniband/hw/hfi1/file_ops.c   |   41 +++++++------
>  drivers/infiniband/hw/hfi1/pcie.c       |   50 ++++++---------
>  drivers/infiniband/hw/hfi1/platform.c   |    4 +
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c |   13 ----
>  7 files changed, 141 insertions(+), 91 deletions(-)

Series applied to -rc, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
