From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v7 2/9] IB/core: Enforce PKey security on QPs
Date: Mon, 22 May 2017 16:59:15 -0400
Message-ID: <CAHC9VhS-W6NaraJB9uCzpAQvUq1+XL+f6YUnqOzAPa6Q56b0FQ@mail.gmail.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
 <1495198139-69993-3-git-send-email-danielj@mellanox.com> <alpine.LRH.2.20.1705220959450.3502@namei.org>
 <VI1PR05MB167814F66EEF8A1BD77C793AC4F80@VI1PR05MB1678.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB167814F66EEF8A1BD77C793AC4F80-79XLn2atqDOzmZAjKwT+HdqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Chris Wright <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 22, 2017 at 6:42 AM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 5/21/2017 7:13 PM, James Morris wrote:
>> On Fri, 19 May 2017, Dan Jurgens wrote:
>>
>>> security/security.c                  | 385 ++++++++++++++++++++++
>> This looks wrong -- merge problem?
>
> Yes, it was a merge problem.  I added back the per field initialization of the security head hooks.  Paul stripped this (and the same problem in patch 0004) himself before merging.
>
>>
>>
>>> +    if (pps->alt.state != IB_PORT_PKEY_NOT_VALID) {
>>> +            get_pkey_and_subnet_prefix(&pps->alt,
>>> +                                       &pkey,
>>> +                                       &subnet_prefix);
>>> +
>>> +            ret = enforce_qp_pkey_security(pkey,
>>> +                                           subnet_prefix,
>>> +                                           sec);
>>> +    }
>>> +
>>> +    if (ret)
>>> +            goto out;
>> The above if/goto is unnecessary.
>
> Right.
>
> Paul, do you want me to fix this with a new patch?

Since this isn't a build or runtime failure, just a style correction,
I'll leave it up to you: either post a 10/9 patch which converts all
the jumps-to-return to just return, or respin/resubmit the patches.
If you do the latter, just resubmit the affected patches and not the
whole patchset.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
