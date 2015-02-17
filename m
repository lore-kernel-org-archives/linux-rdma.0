From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH FIXES for-3.19 0/2] iser initiator fixes for kernel 3.19
Date: Tue, 17 Feb 2015 14:21:14 -0500
Message-ID: <CAJ3xEMin6m7FZXMzBrZG80LokNCE_7H9iy2PoqJLxN_-AkCOng@mail.gmail.com>
References: <1421592667-4099-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421592667-4099-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 18, 2015 at 9:51 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> This set consist of two fixes error flows (cleanup resources).

Hi Roland, I see now that you started to pull the updates for 3.20,
please remember to take these two too they are @ your patchworks

Or.

>
> Ariel Nahum (1):
>   IB/iser: Release the iscsi endpoint if ep_disconnect wasn't called
>
> Sagi Grimberg (1):
>   IB/iser: Fix memory regions possible leak
>
>  drivers/infiniband/ulp/iser/iser_initiator.c |  4 ----
>  drivers/infiniband/ulp/iser/iser_verbs.c     | 27 ++++++++++++++++-----------
>  2 files changed, 16 insertions(+), 15 deletions(-)
>
> --
> 1.8.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
