From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] security: Add LSM hooks for Infiniband security
Date: Tue, 5 Apr 2016 01:52:58 +0300
Message-ID: <CAJ3xEMjFfcju=wCsSqsw=RDeXz=TfTg9XLaA95vMYxGJv5mP7w@mail.gmail.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
	<1459806504-16135-2-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459806504-16135-2-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 5, 2016 at 12:48 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -8,6 +8,7 @@
>   * Copyright (C) 2001 Silicon Graphics, Inc. (Trust Technology Group)
>   * Copyright (C) 2015 Intel Corporation.
>   * Copyright (C) 2015 Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
> + * Copyright (C) 2016 Mellanox Techonologies. <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Dan,

I don't see the point to use personal copyright credits in our
upstream development. AFAIK, we don't do that for the NIC side
patches, if you don't mind, lets avoid that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
