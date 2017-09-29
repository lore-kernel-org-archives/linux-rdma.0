From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] IB/hfi1: IOCTL cleanup and refactoring
Date: Fri, 29 Sep 2017 11:07:12 -0400
Message-ID: <1506697632.2919.13.camel@redhat.com>
References: <20170926140201.16637.45981.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926140201.16637.45981.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 07:03 -0700, Dennis Dalessandro wrote:
> Hi Doug,
> 
> Here is a set of patches that does some code rework to our IOCTL
> handling from
> Mike. I have bundled it as a separate series to make handling review
> feedback
> easier.
> 
> The HFI1 ioctl() function is long and complex. To reduce that
> complexity the
> following patch set refactors each IOCTL into a common pattern, and
> where
> necessary calls an associated function to handle the specific IOCTL.
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.15
> 
> ---
> 
> Michael J. Ruhl (9):
>       IB/hfi1: Refactor assign_ctxt() IOCTL
>       IB/hfi1: Refactor get_ctxt_info
>       IB/hfi1: Fix parenthesis alignment issues
>       IB/hfi1: Refactor get_base_info
>       IB/hfi1: Refactor hfi_user_exp_rcv_setup() IOCTL
>       IB/hfi1: Refactor hfi_user_exp_rcv_clear() IOCTLs
>       IB/hfi1: Refactor hfi_user_exp_rcv_invalid() IOCTLs
>       IB/hfi1: Refactor get_user() IOCTLs
>       IB/hfi1: Refactor reset_ctxt() IOCTL
> 
> 
>  drivers/infiniband/hw/hfi1/file_ops.c     |  463 +++++++++++++++++
> ------------
>  drivers/infiniband/hw/hfi1/user_exp_rcv.c |    3 
>  2 files changed, 272 insertions(+), 194 deletions(-)

Hi Denny,

These all look sane, pulling them in today, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
