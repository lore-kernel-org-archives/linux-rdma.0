From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for v3.13 0/7] create_flow/destroy_flow fixes for v3.13
Date: Wed, 27 Nov 2013 10:34:47 +0200
Message-ID: <5295AEA7.6060902@mellanox.com>
References: <cover.1385501822.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/11/2013 12:02 AM, Yann Droneaud wrote:
> Hi,
>
> Please find a patchset against create_flow/destroy_flow and
> associated extended command scheme.
>
> These are fixes that must be applied before making the new uverbs
> widely available.
>
> This patchset gather some patches already sent independently:
> - The first two patches were already sent[1] to address a warning
>    reported by sparse.
> - The next patch was already sent[2] to handle an uncommon type
>    of extended command.
>
> The three patches ensure that commands will be extensible:
> - One patch add a missing check of comp_mask
> - Two patches add checks on reserved fields
>    following advice from an article read today[3].
>
> The last patches fix an error path.
>
> Please review and apply for v3.13.
>
> Regards.
>
> [1] [PATCH for-next 0/2] Fix "drivers/infiniband/core/uverbs_main.c:683:17: sparse: Using plain integer as NULL pointer" warning
>      http://marc.info/?i=cover.1384869925.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>
> [2] [PATCH for-next] IB/uverbs: set ucore.outbuf to NULL if core response space is omitted
>      http://marc.info/?i=1384872527-26154-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>
> [3] "Botching up ioctls" by Daniel Vetter
>      http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
>
> Yann Droneaud (7):
>    IB/core: const'ify inbuf in struct ib_udata
>    IB/uverbs: remove implicit cast in INIT_UDATA()
>    IB/uverbs: set outbuf to NULL when no core response space is provided
>    IB/uverbs: check reserved field in extended command header
>    IB/uverbs: check comp_mask in destroy_flow
>    IB/uverbs: check reserved fields in create_flow
>    IB/uverbs: set error code when fail to consume all flow_spec items
>
>   drivers/infiniband/core/uverbs.h      | 12 ++++++------
>   drivers/infiniband/core/uverbs_cmd.c  | 31 +++++++++++++++++++++----------
>   drivers/infiniband/core/uverbs_main.c | 16 +++++++++++-----
>   include/rdma/ib_verbs.h               |  2 +-
>   4 files changed, 39 insertions(+), 22 deletions(-)
>

Hi,

Great series Yann. Thanks for your contribution.

Best regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
