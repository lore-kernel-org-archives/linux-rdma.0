From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 2/4] IB/rxe: Fix duplicate atomic request handling
Date: Wed, 7 Sep 2016 14:16:00 +0300
Message-ID: <CAJ3xEMjjB=GtAnbxan6y2oC0_Dqw+NBSAN3dtMRyEK_47qJRJQ@mail.gmail.com>
References: <1473246247-16536-1-git-send-email-leon@kernel.org> <1473246247-16536-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473246247-16536-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 7, 2016 at 2:04 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> When handling ack for atomic opcodes like "fetch&add"
> or "cmp&swp", the method send_atomic_ack() saves the ack
> before sending it, in case it gets lost and never reach the
> requester. In which case the method duplicate_request()
> will need to find it using the duplicated request.psn.
> But send_atomic_ack() used a wrong psn value and thus
> the above ack was never found.
> This fix uses the ack.psn to locate the ack in case
> its needed.
> This fix also copies the ack packet to the skb's control buffer
> since duplicate_request() will need it when calling rxe_xmit_packet()

Are you using tiny screen? any special  reason to limit the change-log lines
to be ~55 chars long and not 70 or 80?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
