From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v3 5/9] selinux: Create policydb version for Infiniband support
Date: Wed, 31 Aug 2016 21:39:03 -0400
Message-ID: <CAHC9VhTF3erdxu+P3rZ3dn4dE+p4vgbyhKk1CmTwK333o-=-8g@mail.gmail.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com> <1469800416-125043-6-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469800416-125043-6-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 29, 2016 at 9:53 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Support for Infiniband requires the addition of two new object contexts,
> one for infiniband PKeys and another IB Ports. Added handlers to read
> and write the new ocontext types when reading or writing a binary policy
> representation.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> ---
> v2:
> - Shorten ib_end_port to ib_port. Paul Moore
> - Added bounds checking to port number. Paul Moore
> - Eliminated {} in OCON_PKEY case statement.  Yuval Shaia

Nit picky, but you still have some curly braces in ocontext_read()
that aren't strictly necessary.

> v3:
> - ib_port -> ib_endport. Paul Moore
>
>  security/selinux/include/security.h |   3 +-
>  security/selinux/ss/policydb.c      | 130 +++++++++++++++++++++++++++++++-----
>  security/selinux/ss/policydb.h      |  27 +++++---
>  3 files changed, 136 insertions(+), 24 deletions(-)

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
