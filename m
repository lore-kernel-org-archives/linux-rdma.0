From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 13:16:47 -0600
Message-ID: <CAANLjFrSH498ZSbemHeOicX5m+=t+aKt9NwqJtPtHVXLraHbGg@mail.gmail.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464602994-21226-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I know that there has been quite a discussion about this. I just want
to report back that this patch does resolve the issue for me. I had to
remove the IB_DEVICE_RAW_SCATTER_FCS lines from the patch for it to
apply to the 4.6.0 tarball from kernel.org.

We now return to our regularly scheduled discussion...
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, May 30, 2016 at 4:09 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> ib_device_cap_flags 64-bit expansion caused a possible caps overlapping
> (depending on machine endianness) and made consumers read wrong device
> capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by the
> iser driver causing it to use a non-existing capability. Fix this by
> casting ib_device_cap_flags enumerations to ULL.
>
> Fixes: 45686f2d6535 ('IB/core: Add Raw Scatter FCS device capability')
> Fixes: 50174a7f2c24 ('IB/core: Add interfaces to control VF attributes')
> Fixes: f5aa9159a418 ('IB/core: Add arbitrary sg_list support')
> Fixes: fb532d6a79b9 ('IB/{core, ulp} Support above 32 possible device capability flags')
> Reported-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> [v4.6+]
> Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h |   66 +++++++++++++++++++++++-----------------------
>  1 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 432bed5..8bb97dc 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -156,21 +156,21 @@ enum rdma_link_layer {
>  };
>
>  enum ib_device_cap_flags {
> -       IB_DEVICE_RESIZE_MAX_WR                 = (1 << 0),
> -       IB_DEVICE_BAD_PKEY_CNTR                 = (1 << 1),
> -       IB_DEVICE_BAD_QKEY_CNTR                 = (1 << 2),
> -       IB_DEVICE_RAW_MULTI                     = (1 << 3),
> -       IB_DEVICE_AUTO_PATH_MIG                 = (1 << 4),
> -       IB_DEVICE_CHANGE_PHY_PORT               = (1 << 5),
> -       IB_DEVICE_UD_AV_PORT_ENFORCE            = (1 << 6),
> -       IB_DEVICE_CURR_QP_STATE_MOD             = (1 << 7),
> -       IB_DEVICE_SHUTDOWN_PORT                 = (1 << 8),
> -       IB_DEVICE_INIT_TYPE                     = (1 << 9),
> -       IB_DEVICE_PORT_ACTIVE_EVENT             = (1 << 10),
> -       IB_DEVICE_SYS_IMAGE_GUID                = (1 << 11),
> -       IB_DEVICE_RC_RNR_NAK_GEN                = (1 << 12),
> -       IB_DEVICE_SRQ_RESIZE                    = (1 << 13),
> -       IB_DEVICE_N_NOTIFY_CQ                   = (1 << 14),
> +       IB_DEVICE_RESIZE_MAX_WR                 = (1ULL << 0),
> +       IB_DEVICE_BAD_PKEY_CNTR                 = (1ULL << 1),
> +       IB_DEVICE_BAD_QKEY_CNTR                 = (1ULL << 2),
> +       IB_DEVICE_RAW_MULTI                     = (1ULL << 3),
> +       IB_DEVICE_AUTO_PATH_MIG                 = (1ULL << 4),
> +       IB_DEVICE_CHANGE_PHY_PORT               = (1ULL << 5),
> +       IB_DEVICE_UD_AV_PORT_ENFORCE            = (1ULL << 6),
> +       IB_DEVICE_CURR_QP_STATE_MOD             = (1ULL << 7),
> +       IB_DEVICE_SHUTDOWN_PORT                 = (1ULL << 8),
> +       IB_DEVICE_INIT_TYPE                     = (1ULL << 9),
> +       IB_DEVICE_PORT_ACTIVE_EVENT             = (1ULL << 10),
> +       IB_DEVICE_SYS_IMAGE_GUID                = (1ULL << 11),
> +       IB_DEVICE_RC_RNR_NAK_GEN                = (1ULL << 12),
> +       IB_DEVICE_SRQ_RESIZE                    = (1ULL << 13),
> +       IB_DEVICE_N_NOTIFY_CQ                   = (1ULL << 14),
>
>         /*
>          * This device supports a per-device lkey or stag that can be
> @@ -179,9 +179,9 @@ enum ib_device_cap_flags {
>          * instead of use the local_dma_lkey flag in the ib_pd structure,
>          * which will always contain a usable lkey.
>          */
> -       IB_DEVICE_LOCAL_DMA_LKEY                = (1 << 15),
> -       IB_DEVICE_RESERVED /* old SEND_W_INV */ = (1 << 16),
> -       IB_DEVICE_MEM_WINDOW                    = (1 << 17),
> +       IB_DEVICE_LOCAL_DMA_LKEY                = (1ULL << 15),
> +       IB_DEVICE_RESERVED /* old SEND_W_INV */ = (1ULL << 16),
> +       IB_DEVICE_MEM_WINDOW                    = (1ULL << 17),
>         /*
>          * Devices should set IB_DEVICE_UD_IP_SUM if they support
>          * insertion of UDP and TCP checksum on outgoing UD IPoIB
> @@ -189,9 +189,9 @@ enum ib_device_cap_flags {
>          * incoming messages.  Setting this flag implies that the
>          * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
>          */
> -       IB_DEVICE_UD_IP_CSUM                    = (1 << 18),
> -       IB_DEVICE_UD_TSO                        = (1 << 19),
> -       IB_DEVICE_XRC                           = (1 << 20),
> +       IB_DEVICE_UD_IP_CSUM                    = (1ULL << 18),
> +       IB_DEVICE_UD_TSO                        = (1ULL << 19),
> +       IB_DEVICE_XRC                           = (1ULL << 20),
>
>         /*
>          * This device supports the IB "base memory management extension",
> @@ -202,25 +202,25 @@ enum ib_device_cap_flags {
>          * IB_WR_RDMA_READ_WITH_INV verb for RDMA READs that invalidate the
>          * stag.
>          */
> -       IB_DEVICE_MEM_MGT_EXTENSIONS            = (1 << 21),
> -       IB_DEVICE_BLOCK_MULTICAST_LOOPBACK      = (1 << 22),
> -       IB_DEVICE_MEM_WINDOW_TYPE_2A            = (1 << 23),
> -       IB_DEVICE_MEM_WINDOW_TYPE_2B            = (1 << 24),
> -       IB_DEVICE_RC_IP_CSUM                    = (1 << 25),
> -       IB_DEVICE_RAW_IP_CSUM                   = (1 << 26),
> +       IB_DEVICE_MEM_MGT_EXTENSIONS            = (1ULL << 21),
> +       IB_DEVICE_BLOCK_MULTICAST_LOOPBACK      = (1ULL << 22),
> +       IB_DEVICE_MEM_WINDOW_TYPE_2A            = (1ULL << 23),
> +       IB_DEVICE_MEM_WINDOW_TYPE_2B            = (1ULL << 24),
> +       IB_DEVICE_RC_IP_CSUM                    = (1ULL << 25),
> +       IB_DEVICE_RAW_IP_CSUM                   = (1ULL << 26),
>         /*
>          * Devices should set IB_DEVICE_CROSS_CHANNEL if they
>          * support execution of WQEs that involve synchronization
>          * of I/O operations with single completion queue managed
>          * by hardware.
>          */
> -       IB_DEVICE_CROSS_CHANNEL         = (1 << 27),
> -       IB_DEVICE_MANAGED_FLOW_STEERING         = (1 << 29),
> -       IB_DEVICE_SIGNATURE_HANDOVER            = (1 << 30),
> -       IB_DEVICE_ON_DEMAND_PAGING              = (1 << 31),
> +       IB_DEVICE_CROSS_CHANNEL         = (1ULL << 27),
> +       IB_DEVICE_MANAGED_FLOW_STEERING         = (1ULL << 29),
> +       IB_DEVICE_SIGNATURE_HANDOVER            = (1ULL << 30),
> +       IB_DEVICE_ON_DEMAND_PAGING              = (1ULL << 31),
>         IB_DEVICE_SG_GAPS_REG                   = (1ULL << 32),
> -       IB_DEVICE_VIRTUAL_FUNCTION              = ((u64)1 << 33),
> -       IB_DEVICE_RAW_SCATTER_FCS               = ((u64)1 << 34),
> +       IB_DEVICE_VIRTUAL_FUNCTION              = (1ULL << 33),
> +       IB_DEVICE_RAW_SCATTER_FCS               = (1ULL << 34),
>  };
>
>  enum ib_signature_prot_cap {
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
