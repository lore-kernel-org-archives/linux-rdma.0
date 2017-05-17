From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Wed, 17 May 2017 17:23:38 -0400
Message-ID: <CAHC9VhTkOVN6KHQQY42QUTuBYO7D52A07aJjo_SiQs1o=Q0uzg@mail.gmail.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhSB6AORJf_8cBGt-AynMsEh3snKU5SpsmNXoy9hDSrGaA@mail.gmail.com>
 <VI1PR05MB167880A4D79F8FC3F8C740A9C4160@VI1PR05MB1678.eurprd05.prod.outlook.com>
 <CAHC9VhRE+bkPAnFgqOOQQQZwA8U0tSWHdeM5+LiadXfN63kS=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhRE+bkPAnFgqOOQQQZwA8U0tSWHdeM5+LiadXfN63kS=g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 4, 2017 at 11:51 AM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Wed, May 3, 2017 at 3:45 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>> On 5/3/2017 9:41 AM, Paul Moore wrote:
>>> On Wed, Nov 23, 2016 at 9:17 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> Infiniband applications access HW from user-space -- traffic is genera=
ted
>>>> directly by HW, bypassing the kernel. Consequently, Infiniband Partiti=
ons,
>>>> which are associated directly with HW transport endpoints, are a natur=
al
>>>> choice for enforcing granular mandatory access control for Infiniband.=
 QPs may
>>>> only send or receives packets tagged with the corresponding partition =
key
>>>> (PKey). The PKey is not a cryptographic key; it's a 16 bit number iden=
tifying
>>>> the partition ...
>>>>
>>> Hi Dan,
>>>
>>> I haven't heard anything from you in a while, where do things stand
>>> with this effort?  Unless I missed them, I believe we are still
>>> waiting on the userspace, SELinux reference policy, and
>>> selinux-testsuite patches.
>>>
>> Hi Paul,
>>
>>     I got distracted for a while.  I've just rebased the kernel and user=
space.  I'll do some testing and submit the userspace code in the next coup=
le days.  I still have to write the selinux-testsuite tests, I'll work on t=
hose concurrently with the userspace review cycle.
>
> Great, thanks for the update.  We'll look forward to the patches.

I took a closer look at the patchset and I think it looks fine,
coupled with the recent progress on the SELinux userspace and test
suite I think it would be good to get this into the selinux/next tree
so we can start playing with it.  Dan, I know there were some IB merge
conflicts with this patch could you do a respin against the current
selinux/next tree?

* git://git.infradead.org/users/pcmoore/selinux
* http://git.infradead.org/users/pcmoore/selinux

Thanks.

--=20
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
