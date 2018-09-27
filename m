From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2] IB/mlx4: Avoid implicit enumerated type conversion
Date: Thu, 27 Sep 2018 13:53:48 -0700
Message-ID: <CAKwvOdncohhariVufRF=S1aZ9H9UJZhksBMGtM+FaU5xmT06JQ@mail.gmail.com>
References: <20180924195716.30848-1-natechancellor@gmail.com> <20180927204352.19569-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927204352.19569-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 1:44 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another.
>
> drivers/infiniband/hw/mlx4/mad.c:1811:41: warning: implicit conversion
> from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> type 'enum ib_qp_create_flags' [-Wenum-conversion]
>                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_TUNNEL_QP;
>                                                     ~ ^~~~~~~~~~~~~~~~~~~~~~~
>
> drivers/infiniband/hw/mlx4/mad.c:1819:41: warning: implicit conversion
> from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> type 'enum ib_qp_create_flags' [-Wenum-conversion]
>                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_SQP;
>                                                     ~ ^~~~~~~~~~~~~~~~~
>
> The type mlx4_ib_qp_flags explicitly provides supplemental values to the
> type ib_qp_create_flags. Make that clear to Clang by changing the
> create_flags type to int.
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> v1 -> v2:
>
> * Use int instead of u32 since enums are restricted to this range, as
>   suggested by Nick.

Thank you for making this change.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
>  include/rdma/ib_verbs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 0d822a9db300..e5ec04e844cd 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1151,7 +1151,7 @@ struct ib_qp_init_attr {
>         struct ib_qp_cap        cap;
>         enum ib_sig_type        sq_sig_type;
>         enum ib_qp_type         qp_type;
> -       enum ib_qp_create_flags create_flags;
> +       int                     create_flags;
>
>         /*
>          * Only needed for special QP types, or when using the RW API.
> --
> 2.19.0
>


-- 
Thanks,
~Nick Desaulniers
