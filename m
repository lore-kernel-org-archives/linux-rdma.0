From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V5 for-next 2/4] IB/core: Infrastructure to support verbs
 extensions through uverbs
Date: Thu, 15 Aug 2013 09:34:18 +0300
Message-ID: <520C766A.6090605@mellanox.com>
References: <1376477911-13828-1-git-send-email-ogerlitz@mellanox.com> <1376477911-13828-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376477911-13828-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/08/2013 13:58, Or Gerlitz wrote:
> From: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
>
> Add infra-structure to support extended uverbs capabilities in a forward/backward
> manner. Uverbs command opcodes which are based on the verbs extensions approach should
> be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format
> and processed a bit differently.
>
> Whenever a specific IB_USER_VERBS_CMD_XXX is extended, which practically means
> it needs to have additional arguments, we will be able to add them without creating
> a completely new IB_USER_VERBS_CMD_YYY command or bumping the uverbs ABI version.
>
> This patch for itself doesn't provide the whole scheme which is also dependent
> on adding a comp_mask field to each extended uverbs command struct.
>
> The new header framework allows for future extension of the CMD arguments
> (ib_uverbs_cmd_hdr.in_words, ib_uverbs_cmd_hdr.out_words) for an existing
> new command (that is a command that supports the new uverbs command header format
> suggested in this patch) w/o bumping ABI version and with maintaining backward
> and formward compatibility to new and old libibverbs versions.
>
> In the uverbs command we are passing both uverbs arguments and the provider arguments.
> We split the ib_uverbs_cmd_hdr.in_words to ib_uverbs_cmd_hdr.in_words which will now carry only uverbs input argument struct size and  ib_uverbs_cmd_hdr.provider_in_words that will carry the provider input argument size. Same goes for the response (the uverbs CMD output argument).

Roland,

So how's this change-log, clear enough?

Anything else re this patch set? its around since April 2013 and missed 
2-3 merged windows, lets make sure we get it in this time.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
