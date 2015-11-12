From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/9] staging/rdma/hfi1: Add function stubs for TID caching
Date: Thu, 12 Nov 2015 07:58:54 +0200
Message-ID: <CAJ3xEMiLz=kgeQhx07WFWtNzcPwy2ZL9fs0SZkSpVd6+reGUVA@mail.gmail.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
	<1446244918-12089-6-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446244918-12089-6-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 31, 2015 at 12:41 AM,  <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Add mmu notify helper functions and TID caching function stubs in preparation
> for the TID caching implementation.
>
> TID caching makes use of the MMU notifier to allow the driver to respond to the
> user freeing memory which is allocated to the HFI.
>
> This patch implements the basic MMU notifier functions to insert, find and
> remove buffer pages from memory based on the mmu_notifier being invoked.
>
> In addition it places stubs in place for the main entry points by follow on
> code.
>
> Follow up patches will complete the implementation of the interaction with user
> space and makes use of these functions.

So this is an wholy orthogonal mechanism for memory registrations or
de-registrations vs
what's supported by the upstream RDMA stack to which this driver
attempts to be a HW provider, right?

Ira, Mike - why do that?

2. Greg - I read an earlier comment you made that a driver in staging
need to be 1st
and most **fixed** with patches such that the TODO items to get it out
of staging are
addressed. I see here every day long train of features going into this
driver, should the
focus need to be elsewhere, according to the staging guidelines?

Or.


>  drivers/staging/rdma/hfi1/Kconfig        |   1 +
>  drivers/staging/rdma/hfi1/Makefile       |   2 +-
>  drivers/staging/rdma/hfi1/user_exp_rcv.c | 314 +++++++++++++++++++++++++++++++
>  drivers/staging/rdma/hfi1/user_exp_rcv.h |   8 +
>  4 files changed, 324 insertions(+), 1 deletion(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
