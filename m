From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] security: Add LSM hooks for Infiniband security
Date: Thu, 30 Jun 2016 16:33:56 -0400
Message-ID: <CAGH-KgtcpKPciy-1-KhQDw2xA5-35t_W9TKCf3z9tj=Vg_hjsg@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-2-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <1466711578-64398-2-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add nine new hooks
>  1. Allocate security contexts for Infiniband QPs.
>  2. Free security contexts for Infiniband QPs.
>  3. Allocate security contexts for Infiniband MAD agents.
>  4. Free security contexts for Infiniband MAD agents.
>  5. Enforce QP access to Pkeys
>  6. Enforce MAD agent access to Pkeys
>  7. Enforce MAD agent access to Infiniband End Ports for sending Subnet
>     Management Packets (SMP)
>  8. A hook to register a callback to receive notifications of
>     security policy or enforcement changes.  Restricting a QPs access to
>     a pkey will be done during setup and not on a per packet basis
>     access must be enforced again.
>  9. A hook to unregister the callback.
>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/lsm_hooks.h | 71 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/security.h  | 63 +++++++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h   |  4 +++
>  security/Kconfig          |  9 +++++
>  security/security.c       | 83 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 230 insertions(+)

...

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 432bed5..3f6780b 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1428,6 +1428,10 @@ struct ib_srq {
>         } ext;
>  };
>
> +struct ib_qp_security {
> +       void *q_security;
> +};

Sorry, I missed this earlier and didn't realize it until I was going
through 4/12 ... why both with ib_qp_security?  Why not just use a
straight void pointer?

-- 
paul moore
security @ redhat
_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
