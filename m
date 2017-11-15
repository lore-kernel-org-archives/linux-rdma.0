From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 31/31] IB/cm: Refactor to avoid setting path
 record software only fields
Date: Wed, 15 Nov 2017 09:56:37 +0200
Message-ID: <CAJ3xEMjQZgRBugy79xRZOFJOonPJzxyXv=+hAZ-+vHM7KemZ4w@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-32-leon@kernel.org>
 <CAJ3xEMhyZQM5dp2VKoiVDz3Q524d_kO=a0PUMJt_xmQK-nkPsg@mail.gmail.com> <VI1PR0502MB3008CEF7DF9257A4D6AFBD1FD1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008CEF7DF9257A4D6AFBD1FD1280-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 12:11 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]

>> On Tue, Nov 14, 2017 at 2:52 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >
>> > When path ah_attr initialization from path record fails,
>> > ib_cm_send_rej() uses av.ah_attr fields to send out reject message. In
>> > such cases initialization of path record software fields is not
>> > needed. Code is simplified for same.
>>
>> is "Code is simplified for same"  cut in the middle, I fail to understand the
>> sentence.
>>
> Code is simplified to avoid such initialization.

so fix  that in the next version, ok?

>> You do two logical changes in one patch, doesn't seem right to me.

> Both logical changes are in same function few lines apart around GID check.
> So Hal and I continued to have in one patch.


As long as it's not terribly problematic, patch has to carry one logical change,
I don't see why not apply this practice here too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
