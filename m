From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Tue, 6 Sep 2016 09:06:46 +0300
Message-ID: <CAJ3xEMiuuCTGiWbefAFLRYART4h8YypsvGqxT69cTpkbrDdx1g@mail.gmail.com>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
 <1473077359-11546-2-git-send-email-leon@kernel.org> <CAJ3xEMiBpGRy-JGuJ=P4eUF5zyz+2bm43F-jqPHtwm=3Uz9YYA@mail.gmail.com>
 <CAJ3xEMidqQRMqP6u+SJSJVbq0weREAtAJN=eXsA_zzS0KnQ_7Q@mail.gmail.com> <20160906050518.GJ21847@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906050518.GJ21847-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 6, 2016 at 8:05 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Sep 05, 2016 at 10:21:15PM +0300, Or Gerlitz wrote:

>> Hi Yoni, in this case, the trace contributes practically nothing to the
>> driver and kernel maintainers, please remove it.

> 1. We got this call stack from external user and he wants to know that
> it is fixed.

good to know, Yoni - we should give them credit! add Reported-by: line
after your author S.O.B line

> 2. I'm looking on the oops posted to the list to get better
> understanding if such cases exist in other places too.

for both (1) and (2) you can put the track trace after the --- line of
the submitted patch,
such that when the maintainer does git am, we don't carry that forever
in the kernel logs.

> 3. We are in late -rc stage and kernel trace shows that it is real issue
> which justifies late acceptance/pull request.

You can solve it with two words "kernel crash" in the change log

The crash originates from small wrongish behaviour of the rxe driver, not from
sophisticated and complex bug. The crash trace doesn't contribute
anything to future
maintainship of the driver and/or the IB subsystem.

> I like your self-confident.
> In this case, I asked from Yoni to add this call trace for a number of reasons:

$ ./scripts/get_maintainer.pl drivers/infiniband/sw/rxe

Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (supporter:SOFT-ROCE DRIVER (rxe))
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:SOFT-ROCE DRIVER (rxe))
linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
