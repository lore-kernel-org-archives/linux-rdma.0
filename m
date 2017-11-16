From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is held
Date: Thu, 16 Nov 2017 13:50:19 +0200
Message-ID: <CAJ3xEMhjV9b5-WVe4QOO41KniK0ogBRukXX1T1bjw-E+Z5QbDA@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-29-leon@kernel.org>
 <CAJ3xEMixWZvCVDYTK1-2w0pYdy65HExvN2ae7y=hAkk6htrETg@mail.gmail.com>
 <VI1PR0502MB3008970D8D6034E4A2D952DED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMhdp_2BYPA+s+We5Qgatye8hNLUYGnZu0ZimpPb86U-VQ@mail.gmail.com>
 <VI1PR0502MB300897A41317A06FFA5CC329D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMiQc_am=rqYg2TyNqU1s9uGSE-wcVxGmW244x8XJNDuyg@mail.gmail.com> <VI1PR0502MB30081717A7E8BEC1B7CFD471D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30081717A7E8BEC1B7CFD471D1290-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 1:10 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]

>> Please also add more info (and in the cover letter please) on IPv4 vs IPv6, unicast
>> vs multicast, etc.

> Is there a template that you can share that linux-rdma follows that I can use to mention what tests are done?
> Any example past cover letters that I can refer as reference?

I suggest you ask the sub-system maintainers (Doug, Jason) what do they expect
for such a heavy duty change set.


> Depending on how much information you expect in cover letter, this patchset can have many revisions just for cover letter.
> So it would be best for you to share the template that I can fill in for v1.

You are still on V0 and complaining on many revisions...

>> You touched the CMA and addr modules quite heavily on all these areas, need to
>> cover them in testing.

> Which are those tests that I should execute apart from above summary?

If there is rdma verification suit @ mlnx that runs rdma user/kernel cm/cma
based applications on ib/roce environments, can run through it.

>> did you test APM? I don't think it would be correct to change the CM APM code
>> without proper testing.

> As I already told this particular patch is not tested. All others are needless to say tested.
> I do not have APM setup to test this fix.
> I am ok to drop this patch and provide fix when crash occurs later on.

I suggest you ask the CM maintainer (Sean) for his opinion on that matter.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
