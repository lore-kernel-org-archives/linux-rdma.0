From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH wip/dl-for-next] RDMA/bnxt_re: Fix kbuild error
Date: Fri, 19 Jan 2018 10:45:54 +0530
Message-ID: <CANjDDBg=1PP4MGw03uC++UEedRtSnprXu4CY1z3PGV9JuSMZTg@mail.gmail.com>
References: <1516288665-11055-1-git-send-email-devesh.sharma@broadcom.com>
 <CANjDDBgnhRuroVEfGJ=gF9=dS47w7pcQh5hZsF=p5iF6mxmX9g@mail.gmail.com> <1516305246.3403.301.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516305246.3403.301.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 19, 2018 at 1:24 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2018-01-18 at 20:49 +0530, Devesh Sharma wrote:
>> Hello Doug,
>>
>> Please pull this in, hopefully this will fix the latest build failure
>> on your sub tree.
>>
>> -Regards
>> Devesh
>
> Hi Devesh,
>
> Given that the code had only landed in my wip/ area, I took your patch
> and squashed into the broken patch (which required a rebase) and then
> pushed a new branch (wip/dl-for-next-rebased).  We'll see if it passes
> the tests there (it passed build tests on my local system the first
> time, so just have to wait for the 0day results).

Thanks Doug.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
