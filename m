From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma\hfi1 - coding style issues cleanup
Date: Thu, 28 Apr 2016 08:14:23 -0400
Message-ID: <20160428121422.GA9685@phlsvsds.ph.intel.com>
References: <1461835354-3077-1-git-send-email-omer.dagan@tandemg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461835354-3077-1-git-send-email-omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 12:22:34PM +0300, omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org wrote:
>From: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
>
>Signed-off-by: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
>---
> drivers/staging/rdma/hfi1/aspm.h         |  6 +++---
> drivers/staging/rdma/hfi1/chip.c         | 30 +++++++++++++++---------------
> drivers/staging/rdma/hfi1/chip.h         |  8 ++++----
> drivers/staging/rdma/hfi1/file_ops.c     | 32 ++++++++++++++++----------------
> drivers/staging/rdma/hfi1/hfi.h          | 14 +++++++-------
> drivers/staging/rdma/hfi1/init.c         | 16 ++++++++--------
> drivers/staging/rdma/hfi1/iowait.h       |  4 ++--
> drivers/staging/rdma/hfi1/mad.c          | 14 +++++++-------
> drivers/staging/rdma/hfi1/pio.c          |  4 ++--
> drivers/staging/rdma/hfi1/qp.c           | 12 ++++++------
> drivers/staging/rdma/hfi1/qp.h           |  2 +-
> drivers/staging/rdma/hfi1/qsfp.h         |  2 +-
> drivers/staging/rdma/hfi1/rc.c           |  8 ++++----
> drivers/staging/rdma/hfi1/ruc.c          |  4 ++--
> drivers/staging/rdma/hfi1/sdma.c         | 28 ++++++++++++++--------------
> drivers/staging/rdma/hfi1/sdma.h         | 10 +++++-----
> drivers/staging/rdma/hfi1/trace.h        | 24 ++++++++++++------------
> drivers/staging/rdma/hfi1/ud.c           |  6 +++---
> drivers/staging/rdma/hfi1/user_exp_rcv.c | 30 +++++++++++++++---------------
> drivers/staging/rdma/hfi1/user_pages.c   |  2 +-
> drivers/staging/rdma/hfi1/user_sdma.c    | 30 +++++++++++++++---------------
> drivers/staging/rdma/hfi1/user_sdma.h    |  6 +++---
> drivers/staging/rdma/hfi1/verbs.c        |  6 +++---
> drivers/staging/rdma/hfi1/verbs.h        |  2 +-
> 24 files changed, 150 insertions(+), 150 deletions(-)

It looks like you sent this patch twice, or is this somehow a V2?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
