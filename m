From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/core: Remove ib_uverbs_flow_spec structure from
 userspace
Date: Mon, 14 Oct 2013 18:26:40 +0300
Message-ID: <525C0D30.2050602@mellanox.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <f8673f302536d503cdeef005a67f4531706ae578.1381510045.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f8673f302536d503cdeef005a67f4531706ae578.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/10/2013 8:56 PM, Yann Droneaud wrote:
> The structure holding any types of flow_spec is of no use to userspace.
> It would be wrong for userspace to do:
>
>    struct ib_uverbs_flow_spec flow_spec;
>
>    flow_spec.type =B_FLOW_SPEC_TCP;
>    flow_spec.size =izeof(flow_spec);
>
> Instead, userspace should use the dedicated flow_spec structure for
>    - Ethernet : struct ib_uverbs_flow_spec_eth,
>    - IPv4     : struct ib_uverbs_flow_spec_ipv4,
>    - TCP/UDP  : struct ib_uverbs_flow_spec_tcp_udp.
>
> In other words, struct ib_uverbs_flow_spec is a "virtual"
> data structure that can only be use by the kernel as an alias
> to the other.
>
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Link: http://marc.info/?i=ver.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> ---
>   drivers/infiniband/core/uverbs.h  | 16 ++++++++++++++++
>   include/uapi/rdma/ib_user_verbs.h | 16 ----------------
>   2 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index d040b87..4ae0307 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -178,6 +178,22 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
>                               struct ib_event *event);
>   void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
>
> +struct ib_uverbs_flow_spec {
> +       union {
> +               union {
> +                       struct ib_uverbs_flow_spec_hdr hdr;
> +                       struct {
> +                               __u32 type;
> +                               __u16 size;
> +                               __u16 reserved;
> +                       };
> +               };
> +               struct ib_uverbs_flow_spec_eth     eth;
> +               struct ib_uverbs_flow_spec_ipv4    ipv4;
> +               struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
> +       };
> +};
> +
>   #define IB_UVERBS_DECLARE_CMD(name)                                    \
>          ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,           \
>                                   const char __user *buf, int in_len,    \
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index f7f233b5..93577fc 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -760,22 +760,6 @@ struct ib_uverbs_flow_spec_tcp_udp {
>          struct ib_uverbs_flow_tcp_udp_filter mask;
>   };
>
> -struct ib_uverbs_flow_spec {
> -       union {
> -               union {
> -                       struct ib_uverbs_flow_spec_hdr hdr;
> -                       struct {
> -                               __u32 type;
> -                               __u16 size;
> -                               __u16 reserved;
> -                       };
> -               };
> -               struct ib_uverbs_flow_spec_eth      eth;
> -               struct ib_uverbs_flow_spec_ipv4    ipv4;
> -               struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
> -       };
> -};
> -
>   struct ib_uverbs_flow_attr {
>          __u32 type;
>          __u16 size;
> --
> 1.8.3.1
>

Hi,

Nice catch - exposing struct ib_uverbs_flow_spec to userspace imposes 
another risk. Adding a spec that is larger than all previous specs will 
result in a larger  ib_uverbs_flow_spec structure. This in turn could 
lead to ABI breaks - something we definitely don't want. The ABI 
shouldn't include a "do-it-all" spec.

Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
