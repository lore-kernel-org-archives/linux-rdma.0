From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
 modifying QP
Date: Tue, 19 Nov 2013 10:08:54 -0800
Message-ID: <CAG4TOxOUFfPMU+q1yKy6S7v3QiLVgMQwxNC-_vw-7UeUb7LoBg@mail.gmail.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com> <1384381792-2023-8-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384381792-2023-8-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Existing user space applications provide only IBoE L3 address attributes
> to the kernel when they issue QP modify. To comply with them and let such
> apps to keep work transparently under the IBoE GID IP addressing changes,
> added Eth L2 address resolution in the user-kernel linking piece - uverbs.

I don't get why this belongs in uverbs.  In the current design serves
as a transport between userspace and kernel and the kernel verbs are
the same as user verbs.  The only exception to this that introduces
complexity is the stuff related to sharing XRCs and that makes sense
because multiple processes etc. is definitely a userspace-only
concern.

However in this case I don't see why address resolution is something
only userspace cares about.  Wouldn't it make sense to put this
resolution in core verbs?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
