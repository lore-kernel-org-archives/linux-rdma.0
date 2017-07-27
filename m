From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel oops
Date: Thu, 27 Jul 2017 14:44:37 -0600
Message-ID: <20170727204437.GA16986@obsidianresearch.com>
References: <20170724211606.GA1705@obsidianresearch.com>
 <CAAKD3BAdB2aRk3WGdbeDYof6dUfkEwhQf27cG0FWe5DRuQ15NQ@mail.gmail.com>
 <CAAKD3BDFrTMMgX0nErD50rp2je=HC9zeaYWHDKf0mqQwc5fM9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDFrTMMgX0nErD50rp2je=HC9zeaYWHDKf0mqQwc5fM9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 27, 2017 at 03:54:07PM +0300, Matan Barak wrote:

> Digging a bit, we found a fix that might be related to this issue.
> I would be happy if you could try that and report if it solved this problem.
> We plan to send it soon.

Yep this looks like it.

FWIW, it causes random kernel memory corruption and failures in my
experience, I was very lucky to get such a clean oops the first time..

> commit 1d4ecbf034193f000fe6686586c40ab4b2a95da1
> Author: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Thu Jul 27 15:49:00 2017 +0200
> 
>     IB/uverbs: Fix device cleanup
> 
>     Uverbs device should be cleaned up only when there is no
>     potential usage of.
> 
>     As part of ib_uverbs_remove_one which might be triggered upon reset flow
>     the device reference count is decreased as expected and leave the final
>     cleanup to the FDs that were opened.
> 
>     Current code increases reference count upon opening a new command FD and
>     decreases it upon closing the file. The event FD is opened internally
>     and rely on the command FD by taking on it a reference count.
> 
>     In case that the command FD was closed and just later the event FD we
>     may ensure that the device resources as of srcu are still alive as they
>     are still in use.
> 
>     Fixing the above by moving the reference count decreasing to the place
>     where the command FD is really freed instead of doing that when it was
>     just closed.
> 
>     Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Please add a fixes line

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
