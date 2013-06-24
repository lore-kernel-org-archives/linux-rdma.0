From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 4/6] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Mon, 24 Jun 2013 14:06:08 -0700
Message-ID: <CAL1RGDXBO6yNWmwg=B=uMknwSU_dwjSabasxy21h=+4q8qX6Cg@mail.gmail.com>
References: <1371628031-17546-1-git-send-email-ogerlitz@mellanox.com> <1371628031-17546-5-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371628031-17546-5-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 19, 2013 at 12:47 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> Add Infra-structure to support extended uverbs capabilities in a forward/backward
> manner. Uverbs command opcodes which are based on the verbs extensions approach should
> be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format
> and processed a bit differently.

This patch at least doesn't have a sufficient changelog.  I don't
understand what "extended capabilities" are or why we need to change
the header format.

What is the "verbs extensions approach"?  Why does the kernel need to
know about it?  What is different about the processing?  The only
difference I see is that userspace now has a more complicated way to
pass the size in, which the kernel seems to nearly ignore -- it just
adds the sizes together and proceeds as before.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
