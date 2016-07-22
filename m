From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v2 5/9] selinux: Create policydb version for Infiniband support
Date: Fri, 22 Jul 2016 12:29:25 -0400
Message-ID: <CAHC9VhTRQ_jvdOPn-eszzHkb1+HL7ySaM5qK2pgX=9GFdjOcpg@mail.gmail.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com> <1468537011-20407-6-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468537011-20407-6-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 14, 2016 at 6:56 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
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

We had a discussion about this in the last patchset and I think things
may have gotten confused.  From what I remember, according to the IB
developers the proper term is "end port"; if that is true, we probably
should use "end port", but I would prefer if we drop the underscore in
most of the places, e.g. "ib_endport" instead of "ib_end_port".

Sorry for the continuing nit pickiness.

> - Added bounds checking to port number. Paul Moore
> - Eliminated {} in OCON_PKEY case statement.  Yuval Shaia
> ---
>  security/selinux/include/security.h |    3 +-
>  security/selinux/ss/policydb.c      |  130 +++++++++++++++++++++++++++++++----
>  security/selinux/ss/policydb.h      |   27 +++++--
>  3 files changed, 136 insertions(+), 24 deletions(-)

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
