From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 1/9] IB/mlx4: Set traffic class in AH
Date: Fri, 11 Nov 2016 11:11:40 +0200
Message-ID: <CAJ3xEMgebjWMNmxpMxFpbdpGR9kmNj9HhiFEL3QyE0gd2EGihQ@mail.gmail.com>
References: <1478770261-5775-1-git-send-email-leon@kernel.org> <1478770261-5775-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 10, 2016 at 11:30 AM, Leon Romanovsky wrote:

> Set traffic class within sl_tclass_flowlabel when create iboe AH.
> Without this the TOS value will be empty when running VLAN tagged
> traffic, because the TOS value is taken from the traffic class in the
> address handle attributes.

How is the IP TOS field modeled in RoCE V2 spec and/or the upstream
rdma stack? E.g in RoCE V1 the 802.1q vlan priority is derived from
the SL.

> Fixes: 9106c4106974 ('IB/mlx4: Fix SL to 802.1Q priority-bits mapping for IBoE')

This commit was when the upstream kernel didn't support Routable RoCE
and hence the IP TOS value was irrelevant. Hence, I don't see why
claiming to fix it, please explain what you find wrong in that commit.

Also when you fix someone commit, the usual habit is to cc him/her on
the fix so they can have a chance to comment, how you expected people
to review your fixes to their commits if you don't give them heads-up?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
