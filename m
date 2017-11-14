From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is held
Date: Wed, 15 Nov 2017 00:21:08 +0200
Message-ID: <CAJ3xEMhdp_2BYPA+s+We5Qgatye8hNLUYGnZu0ZimpPb86U-VQ@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-29-leon@kernel.org>
 <CAJ3xEMixWZvCVDYTK1-2w0pYdy65HExvN2ae7y=hAkk6htrETg@mail.gmail.com> <VI1PR0502MB3008970D8D6034E4A2D952DED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008970D8D6034E4A2D952DED1280-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 12:16 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin l=
ock is
>>> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>>> In case of LAP are used for RoCE

>> AFAIK APM is not supported with RoCE, isn't that? if yes, on what HW/RoC=
E
>> mode and how do you test that?

> This particular patch in this series is not tested on RoCE.
> APM is not supported but injecting such frame in network is not impossibl=
e.
> We don=E2=80=99t have particular checks to reject such frame for RoCE.
> So I prefer to fix the issue before getting such hang/oops report when is=
sue is evident in code.

mentioning testing, in this series you did bunch of fixes for the IB
core, CM and CMA.

Would be good to add a section in the cover letter mentioning under which t=
ype
of testing the modified code has gone through.

Seems that you did a hell of hardening to the IB core, cool!!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
