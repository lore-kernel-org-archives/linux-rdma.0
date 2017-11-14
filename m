From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 31/31] IB/cm: Refactor to avoid setting path
 record software only fields
Date: Tue, 14 Nov 2017 23:13:13 +0200
Message-ID: <CAJ3xEMhyZQM5dp2VKoiVDz3Q524d_kO=a0PUMJt_xmQK-nkPsg@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-32-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-32-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 2:52 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> When path ah_attr initialization from path record
> fails, ib_cm_send_rej() uses av.ah_attr fields to send out reject
> message. In such cases initialization of path record software fields
> is not needed. Code is simplified for same.

is "Code is simplified for same"  cut in the middle, I fail to
understand the sentence.


> Additionally in current code in cm_req_handler, when ib_get_cached_gid
> fails for a given sgid_index of the GID of the GRH of the incoming CM MAD,
> error code 12 is sent. This error code refers to primary GID in incoming
> CM REQ and not for the GID in in MAD packet.
> Therefore code is refactored to send code 5 (unsupported request) for such
> error.

You do two logical changes in one patch, doesn't seem right to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
