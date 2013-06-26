From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/4] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Wed, 26 Jun 2013 06:05:16 -0700
Message-ID: <CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA@mail.gmail.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com> <1372251464-13394-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372251464-13394-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 26, 2013 at 5:57 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Add Infra-structure to support extended uverbs capabilities in a forward/backward
> manner. Uverbs command opcodes which are based on the verbs extensions approach should
> be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format
> and processed a bit differently.

I think you missed the feedback I gave to the previous version of this patch:

 This patch at least doesn't have a sufficient changelog.  I don't
 understand what "extended capabilities" are or why we need to change
 the header format.

 What is the "verbs extensions approach"?  Why does the kernel need to
 know about it?  What is different about the processing?  The only
 difference I see is that userspace now has a more complicated way to
 pass the size in, which the kernel seems to nearly ignore -- it just
 adds the sizes together and proceeds as before.

I'm still wondering why the flow steering uverbs commands can't be
normal uverbs commands.

[And BTW, "infrastructure" is a normal word with no need for
capitalization or hyphenation]

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
