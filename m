From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Tue, 6 Sep 2016 12:21:34 +0300
Message-ID: <CAJ3xEMhTf1kD4s4xLzL9VgvLSozwrxSMK7Zmtok_=xJrp19BRA@mail.gmail.com>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
 <1473077359-11546-2-git-send-email-leon@kernel.org> <CAJ3xEMiBpGRy-JGuJ=P4eUF5zyz+2bm43F-jqPHtwm=3Uz9YYA@mail.gmail.com>
 <CAJ3xEMidqQRMqP6u+SJSJVbq0weREAtAJN=eXsA_zzS0KnQ_7Q@mail.gmail.com>
 <20160906050518.GJ21847@leon.nu> <CAJ3xEMiuuCTGiWbefAFLRYART4h8YypsvGqxT69cTpkbrDdx1g@mail.gmail.com>
 <20160906085943.GL21847@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906085943.GL21847-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 6, 2016 at 11:59 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Sep 06, 2016 at 09:06:46AM +0300, Or Gerlitz wrote:
>> On Tue, Sep 6, 2016 at 8:05 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> > On Mon, Sep 05, 2016 at 10:21:15PM +0300, Or Gerlitz wrote:
>>
>> >> Hi Yoni, in this case, the trace contributes practically nothing to the
>> >> driver and kernel maintainers, please remove it.
>>
>> > 1. We got this call stack from external user and he wants to know that
>> > it is fixed.
>>
>> good to know, Yoni - we should give them credit! add Reported-by: line
>> after your author S.O.B line
>
> Internally, It was asked too, and we decided to skip it.
> It is uncommon to put jenkins bot name.

I couldn't realize from your email that it was a robot finding that
and not a human, you
can skip the robot name or creditize the person that read the robot's
email, if this is
the author of the patch, no need for double credit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
