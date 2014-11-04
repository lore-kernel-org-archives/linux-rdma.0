From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 libibverbs 2/2] Add MR re-registeration
Date: Tue, 4 Nov 2014 20:44:18 +0200
Message-ID: <CAJ3xEMgOpAesxZ3wpgp0n2aTGV2OrkdUj+ueqmmTKfDShx8r_w@mail.gmail.com>
References: <1415113179-6699-1-git-send-email-matanb@mellanox.com>
	<1415113179-6699-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415113179-6699-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 4, 2014 at 4:59 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Memory re-registeration is a feature that enables one to change
> the attributes of a memory region, including PD, translation
> (address and length) and access flags.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/infiniband/driver.h   |  5 ++++
>  include/infiniband/kern-abi.h | 20 ++++++++++++++++
>  include/infiniband/verbs.h    |  9 ++++++-
>  src/cmd.c                     | 29 +++++++++++++++++++++++
>  src/libibverbs.map            |  1 +
>  src/verbs.c                   | 55 +++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 118 insertions(+), 1 deletion(-)


Wait, we've lost the man page on V2, please re-submit...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
