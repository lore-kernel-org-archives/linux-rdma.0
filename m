From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH 00/12] SELinux support for Infiniband RDMA
Date: Thu, 30 Jun 2016 11:18:44 -0400
Message-ID: <CAHC9VhR3c7S-D8siditL-AAnvn4PW_n9A3cx7KyrcxCf+=b5Fw@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhRKFmZ+thwqbq8JnGbj04+Uex4JM0CS=umjfUQB90k0VQ@mail.gmail.com> <DB6PR0501MB22611E2BA664DD033571AEDEC4230@DB6PR0501MB2261.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB6PR0501MB22611E2BA664DD033571AEDEC4230-wTfl6qNNZ1NK98U9gK7MJ8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 29, 2016 at 3:09 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 6/29/2016 12:33 PM, Paul Moore wrote:
>> I'm also wondering if QP revalidation on a security policy change is
>> worth the trouble; we've historically not been able to provide any
>> revoke guarantees so I'm not sure if it is worth a lot of added
>> complexity to gain this functionality just for Infiniband.  That said,
>> it would be *nice* to have revalidation/revocation working, even if
>> only for IB.  It may be that we need similar code to handle the
>> various corner cases, so we may be stuck with the complexity anyway, I
>> just thought it was worth bringing up as a topic of discussion.
>
> QP re-validation on policy change comes cheap because it's possible for the
> PKey table to change.  So a mechanism to recheck all the QPs is needed
> regardless.

Okay, if we need the mechanism anyway, let's keep it.  Revalidation is
nice as long as we can make it work without too much pain, and based
on my first pass through the patches it didn't look as bad as I feared
it might.

> During my testing it left a funny taste in my mouth when I had QPs that shouldn't be allowed continue to exist after setenforce 1.

Yeah, the general inability to revoke access is pretty annoying, but
in practice I don't believe it is very common as I don't believe
people change their security policy very frequently, especially in
production.

> On the other hand I'm not in love with the callback registration for policy
> change notification one off for Infiniband.  In on of the RFCs I used an
> LSM hook that ib/core would implement.  I think Casey commented on that,
> so I changed it to what you see now.

I can't say I'm in love with it either, but sometimes things are just
awkward.  I suspect I'll probably have some comments on the
notification mechanism too, but I'm not comfortable enough with your
patches yet to make any quality comments.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
