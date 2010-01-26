From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/uverbs: Support for XRC
Date: Tue, 26 Jan 2010 16:39:41 +0200
Message-ID: <4B5EFEAD.9040702@Voltaire.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com> <1264446094-4460-3-git-send-email-rolandd@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1264446094-4460-3-git-send-email-rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Add support for core userspace XRC operations (alloc/dealloc XRC domain,
> create XRC SRQ), including adding an ABI for marshalling requests and responses.
> +++ b/include/rdma/ib_user_verbs.h
> @@ -81,7 +81,10 @@ enum {
> -	IB_USER_VERBS_CMD_POST_SRQ_RECV
> +	IB_USER_VERBS_CMD_POST_SRQ_RECV,
> +	IB_USER_VERBS_CMD_CREATE_XRC_SRQ,
> +	IB_USER_VERBS_CMD_OPEN_XRCD,
> +	IB_USER_VERBS_CMD_CLOSE_XRCD

Jack,Roland I believe that adding entries to this enum means ABI change towards libibverbs or eventually cause ABI change between libibverbs and its consumers, (e.g change in size/content of the verbs context structure, etc), correct? 

I'd like to use this ABI change and introduce/expose also the ib_modify_cq verb to user space. Basically, the related patches should be quite simple (uverbs, libibverbs, libmlx4), still, I'll be glad if you tell/coach me against what code base to do that. 

One more thing I'd like to add to libibverbs and some device driver libraries is send-with-invalidate, but this is only user space patch set without any kernel/user, lib/app ABI change, correct?

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
