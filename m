From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 for-next 2/4] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Tue, 13 Aug 2013 12:18:51 -0700
Message-ID: <CAL1RGDXJtrc849M6_XNZT5xO1+ybKtLWGq6yg6LhoSsKpsmkYA@mail.gmail.com>
References: <1375873322-19384-1-git-send-email-ogerlitz@mellanox.com> <1375873322-19384-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375873322-19384-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Add Infra-structure to support extended uverbs capabilities in a forward/backward
> manner. Uverbs command opcodes which are based on the verbs extensions approach should
> be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format
> and processed a bit differently.

Previously I wrote the following about an earlier version of the
patch. (Quite a while before you sent the new version).  You seem to
have ignored it (and also ignored my correction about how to write
"infrastructure"):

  I think you missed the feedback I gave to the previous version of this patch:

   This patch at least doesn't have a sufficient changelog.  I don't
   understand what "extended capabilities" are or why we need to change
   the header format.

   What is the "verbs extensions approach"?  Why does the kernel need to
   know about it?  What is different about the processing?

Yes, you have tried to answer those questions separately but do you
think git writes changelogs magically when a patch is applied?  If you
don't supply a good enough changelog, you're expecting me to write it
for you.

> +struct ib_uverbs_cmd_hdr_ex {
> +       __u32 command;
> +       __u16 in_words;
> +       __u16 out_words;
> +       __u16 provider_in_words;
> +       __u16 provider_out_words;
> +       __u32 cmd_hdr_reserved;
> +};
> +

If I understand the vague explanations and the analogy to the
presentation about userspace, then cmd_hdr_reserved is supposed to be
used as a mask field.  Should a kernel that doesn't understand any
mask components make sure that this reserved field is 0, and return an
error if it isn't?  I don't see any code to do that, and it seems to
risk new userspace silently getting wrong answers on an old kernel.

Is there any reason not to name it as a mask field from the start?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
