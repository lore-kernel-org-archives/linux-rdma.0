From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/12] SELinux support for Infiniband RDMA
Date: Wed, 29 Jun 2016 19:09:18 +0000
Message-ID: <DB6PR0501MB22611E2BA664DD033571AEDEC4230@DB6PR0501MB2261.eurprd05.prod.outlook.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhRKFmZ+thwqbq8JnGbj04+Uex4JM0CS=umjfUQB90k0VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/29/2016 12:33 PM, Paul Moore wrote:
> On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> When destroying a QP the ib_qp structure is freed by the hardware driver
>> if the destroy is successful.  This requires storing security related
>> information in a separate structure. When a destroy request is in process
>> the ib_qp structure is in an undefined state so if there are changes to the
>> security policy or PKey table the security checks cannot reset the QP if it
>> doesn't have permission for the new setting.  If the destroy fails security
>> for that QP must be enforced again, and its status in the list restored.
>> If the destroy succeeds the security info can be cleaned up and freed.
> Perhaps I'll end up answering this for myself as I work my way through
> the patches, but hopefully you are handling the case where a destroy
> operation fails and the QP needs to be revalidated?

Yes, if the destroy fails the security is checked again.  You can see
this in security.c
ib_destroy_qp_security_abort which is added in "[PATCH 09/12] IB/core:
Enforce PKey
security on QPs"

> I'm also wondering if QP revalidation on a security policy change is
> worth the trouble; we've historically not been able to provide any
> revoke guarantees so I'm not sure if it is worth a lot of added
> complexity to gain this functionality just for Infiniband.  That said,
> it would be *nice* to have revalidation/revocation working, even if
> only for IB.  It may be that we need similar code to handle the
> various corner cases, so we may be stuck with the complexity anyway, I
> just thought it was worth bringing up as a topic of discussion.

QP re-validation on policy change comes cheap because it's possible for the
PKey table to change.  So a mechanism to recheck all the QPs is needed
regardless.  I'd be fine with getting rid of it if you think that's
best.  In a
production environment SELinux will always be enforcing so it's probably not
really needed.  During my testing it left a funny taste in my mouth when
I had
QPs that shouldn't be allowed continue to exist after setenforce 1.  On
the other
hand I'm not in love with the callback registration for policy change
notification
one off for Infiniband.  In on of the RFCs I used an LSM hook that
ib/core would
implement.  I think Casey commented on that, so I changed it to what you see
now.

Thank you for reviewing this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
