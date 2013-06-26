From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/4] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Wed, 26 Jun 2013 18:17:07 +0300
Message-ID: <51CB05F3.3040409@mellanox.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com> <1372251464-13394-3-git-send-email-ogerlitz@mellanox.com> <CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/06/2013 16:05, Roland Dreier wrote:
> On Wed, Jun 26, 2013 at 5:57 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Add Infra-structure to support extended uverbs capabilities in a forward/backward manner. Uverbs command opcodes which are based on the verbs extensions approach should be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format and processed a bit differently.
> I think you missed the feedback I gave to the previous version of this patch:
>
>   This patch at least doesn't have a sufficient changelog.  I don't
>   understand what "extended capabilities" are or why we need to change
>   the header format.
>
>   What is the "verbs extensions approach"?  Why does the kernel need to
>   know about it?  What is different about the processing?  The only
>   difference I see is that userspace now has a more complicated way to
>   pass the size in, which the kernel seems to nearly ignore -- it just
>   adds the sizes together and proceeds as before.

Roland, you provided the comment to this patch indeed, but it was on 
another series where the patch was posted, the RoCE IP based addressing 
one. I posted it twice since its an infrastructure (...) patch used by 
both series, I wanted to post V2 of the flow steering patches to make 
sure I addressed your comment on the void pointer OK, and take things 
from there, never mind.

To the point, the uverbs extensions construct is basically made from two 
building blocks

1. extended header which explicitly specifies the in/out verbs data size 
and in/out provider data size

2. a bit mask ("comp mask") which allows to specify what fields in the 
uverbs command structure are used.

The combination of 1 + 2 will allow to extend commands which are 
provided along these building blocks without a need to bump the uverbs ABI.

Today, the kernel uverbs layer assumes a given size for each command, so 
for example, the provider udata IN size is in_words - size_of_cmd.

For commands added along this framework, the kernel could support all 
the previous "versions" towards user space in parallel, say we added new 
command cmdX, to both user and kernel, where v0 is the initial version, 
and later we added few fields to  and have cmdX_v1 and later on more 
fields and have cmdX_v2


> +struct ib_uverbs_cmd_hdr_ex {
> +	__u32 command;
> +	__u16 in_words;
> +	__u16 out_words;
> +	__u16 provider_in_words;
> +	__u16 provider_out_words;
> +	__u32 cmd_hdr_reserved;
> +};
> +
>

Based on the bits set in the comp mask and the in_words field value, the 
kernel which has cmdX_v2 can work towards older user space 
libraries/applications e.g cmdX_v1 and cmdX_v0

The comp mask is not part of the header, but rather the 1st field of 
every uverbs command and response, here, in this series, it was added in 
patch 3/4 for the uverbs flow-steering structures which are cmdX_v0 in 
this context.

If we only used (in_words - size_of_cmd) we can't achieve that support.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
