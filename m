From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] IB/netlink: Allow multiple clients to register under the same family
Date: Wed, 4 May 2016 14:14:39 -0400
Message-ID: <20160504181438.GA2072@phlsvsds.ph.intel.com>
References: <1462376518-6725-1-git-send-email-leon@kernel.org> <1462376518-6725-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462376518-6725-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 06:41:56PM +0300, Leon Romanovsky wrote:
>From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>This commit adds the ability for multiple clients to register to the same
>family. We will allow this only if there isn't an overlap between them.
>If there is an overlap, we will fail the latest client registration.

Can you expand on why we need to do this and what you mean by "overlap"?

Maybe I'm not clear on the terminology. I thought the "family" was something 
like NETLINK_RDMA, which we already allow multiple "clients" to register with.

These things:

enum {
        RDMA_NL_RDMA_CM = 1,
        RDMA_NL_IWCM,
        RDMA_NL_RSVD,
        RDMA_NL_LS,     /* RDMA Local Services */
        RDMA_NL_I40IW,
        RDMA_NL_NUM_CLIENTS
};

It seems what you are trying to do is allow the same "client" to register 
multiple times, but with differing numbers of ops?

Is there a reason to not just have another client index?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
