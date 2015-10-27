From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libibverbs 4/7] Add timestmap support to extended poll_cq verb
Date: Tue, 27 Oct 2015 19:05:59 +0200
Message-ID: <CAAKD3BD6HjA6GuNCHrzTdFgbH=CGVQiMr1mDVMUf7d3aW9KwKA@mail.gmail.com>
References: <1445964755-13371-1-git-send-email-matanb@mellanox.com>
	<1445964755-13371-5-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964755-13371-5-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 6:52 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Adding support to the extended version of poll_cq verb to read
> completion timestamp. Reading timestamp isn't supported with reading
> IBV_WC_EX_WITH_SL and IBV_WC_EX_WITH_SLID.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/cq.c    | 10 ++++++++++
>  src/mlx4.h  | 25 ++++++++++++++++++++-----
>  src/verbs.c |  3 ++-
>  3 files changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/src/cq.c b/src/cq.c
> index c86e824..7f40f12 100644
> --- a/src/cq.c
> +++ b/src/cq.c
> @@ -399,6 +399,16 @@ static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
>         if (err != CQ_CONTINUE)
>                 return err;
>
> +       if (wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP) {
> +               uint16_t timestamp_0_15 = cqe->timestamp_0_7 |
> +                       cqe->timestamp_8_15 << 8;
> +
> +               wc_flags_out |= IBV_WC_EX_WITH_COMPLETION_TIMESTAMP;
> +               *wc_buffer.b64++ = (((uint64_t)ntohl(cqe->timestamp_16_47)
> +                                            + !timestamp_0_15) << 16) |
> +                                          (uint64_t)timestamp_0_15;
> +       }
> +
>         if (is_send) {
>                 switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
>                 case MLX4_OPCODE_RDMA_WRITE_IMM:
> diff --git a/src/mlx4.h b/src/mlx4.h
> index e22f879..2465298 100644
> --- a/src/mlx4.h
> +++ b/src/mlx4.h
> @@ -312,14 +312,29 @@ struct mlx4_cqe {
>         uint32_t        vlan_my_qpn;
>         uint32_t        immed_rss_invalid;
>         uint32_t        g_mlpath_rqpn;
> -       uint8_t         sl_vid;
> -       uint8_t         reserved1;
> -       uint16_t        rlid;
> -       uint32_t        status;
> +       union {
> +               struct {
> +                       union {
> +                               struct {
> +                                       uint8_t   sl_vid;
> +                                       uint8_t   reserved1;
> +                                       uint16_t  rlid;
> +                               };
> +                               uint32_t  timestamp_16_47;
> +                       };
> +                       uint32_t  status;
> +               };
> +               struct {
> +                       uint16_t reserved2;
> +                       uint8_t  smac[6];
> +               };
> +       };
>         uint32_t        byte_cnt;
>         uint16_t        wqe_index;
>         uint16_t        checksum;
> -       uint8_t         reserved3[3];
> +       uint8_t         reserved3;
> +       uint8_t         timestamp_8_15;
> +       uint8_t         timestamp_0_7;
>         uint8_t         owner_sr_opcode;
>  };
>
> diff --git a/src/verbs.c b/src/verbs.c
> index 0dcdc87..a8d6bd7 100644
> --- a/src/verbs.c
> +++ b/src/verbs.c
> @@ -286,7 +286,8 @@ enum {
>  };
>
>  enum {
> -       CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS
> +       CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS    |
> +                                      IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
>  };
>
>  static struct ibv_cq *create_cq(struct ibv_context *context,
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This should have libmlx4 prefix.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
