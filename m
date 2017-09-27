From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] use setup_timer() helper function.
Date: Wed, 27 Sep 2017 09:43:01 -0400
Message-ID: <1506519781.82712.21.camel@redhat.com>
References: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506076036-16496-1-git-send-email-allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-22 at 15:57 +0530, Allen Pais wrote:
> This series uses setup_timer() helper function. The series
> addresses the files under drivers/infiniband/hw/*.
> 
> 
> Allen Pais (8):
>   infiniband: qib: use setup_timer() helper.
>   infiniband: nes: use setup_timer() helper.
>   infiniband: qib: use setup_timer() helper.
>   infiniband: mthca: use setup_timer() helper.
>   infiniband: nes: use setup_timer() helper.
>   infiniband: qib: use setup_timer() helper.
>   infiniband: nes: use setup_timer() helper.
>   infiniband: qib: use setup_timer() helper.
> 
>  drivers/infiniband/hw/mthca/mthca_catas.c | 4 +---
>  drivers/infiniband/hw/nes/nes_cm.c        | 3 +--
>  drivers/infiniband/hw/nes/nes_hw.c        | 9 +++------
>  drivers/infiniband/hw/nes/nes_nic.c       | 3 +--
>  drivers/infiniband/hw/qib/qib_driver.c    | 5 ++---
>  drivers/infiniband/hw/qib/qib_iba7220.c   | 5 ++---
>  drivers/infiniband/hw/qib/qib_mad.c       | 7 +++----
>  drivers/infiniband/hw/qib/qib_sd7220.c    | 5 ++---
>  8 files changed, 15 insertions(+), 26 deletions(-)

This patch series is rejected.  If you are doing a "thing", such as
update a driver to use setup_timer(), then you do one patch for an
entire driver, and on trivial items such as this, even better would be
just one patch for all of the drivers under infiniband/hw.  But you do
*not* do one patch per timer.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
