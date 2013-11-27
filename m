From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for v3.13 2/7] IB/uverbs: remove implicit cast in INIT_UDATA()
Date: Wed, 27 Nov 2013 10:21:44 +0200
Message-ID: <5295AB98.8080205@mellanox.com>
References: <cover.1385501822.git.ydroneaud@opteya.com> <471895ee06633a624e934cf501c7a460755fe4a4.1385501822.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <471895ee06633a624e934cf501c7a460755fe4a4.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/11/2013 12:02 AM, Yann Droneaud wrote:
> Currently, INIT_UDATA() does an implicit cast to a pointer,
> so that 'response' address, eg. output buffer, can be used
> as is to initialize a struct ib_udata:
>
>          do {                                                    \
>                  (udata)->inbuf  =3D (void __user *) (ibuf);       \
>                  (udata)->outbuf =3D (void __user *) (obuf);       \
>                  (udata)->inlen  =3D (ilen);                       \
>                  (udata)->outlen =3D (olen);                       \
>          } while (0)
>
> ...
>
>          INIT_UDATA(&udata, buf + sizeof cmd,
>                     (unsigned long) cmd.response + sizeof resp,
>                     in_len - sizeof cmd, out_len - sizeof  resp);
>
> ...
>
> Hidding the integer to pointer conversion is prone to error
> that won't be catched by compiler/static analyzer is some case.
>
> In the other hand, sparse reports an error if literal 0 is used
> to initialize inbuf or outbuf, for example in:
>
>          INIT_UDATA(&ucore,
>                     (hdr.in_words) ? buf : 0,
>                     (unsigned long)ex_hdr.response,
>                     hdr.in_words * 8,
>                     hdr.out_words * 8);
>
> It was reported by kbuild test robot in message[1]:
>
>    From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>    Subject: "drivers/infiniband/core/uverbs_main.c:683:17:
>        sparse: Using plain integer as NULL pointer",
>    Message-Id: <528b3984.SVGs20ZWpcuR/Jls%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> This patch fixes the warnings reported by sparse and allows the compi=
ler
> to report a warning in case a plain integer get used to initialize
> a udata pointer.
>
> This patch requires struct ib_udata to be modified to have a
> const void __user *inbuf field[2], otherwise compiler will report war=
nings
> regarding const to non const conversion:
>
> drivers/infiniband/core/uverbs_main.c: In function =E2=80=98ib_uverbs=
_write=E2=80=99:
> drivers/infiniband/core/uverbs_main.c:682:24: attention : assignment =
discards =E2=80=98const=E2=80=99 qualifier from pointer target type [en=
abled by default]
> drivers/infiniband/core/uverbs_main.c:688:22: attention : assignment =
discards =E2=80=98const=E2=80=99 qualifier from pointer target type [en=
abled by default]
> drivers/infiniband/core/uverbs_cmd.c: In function =E2=80=98ib_uverbs_=
get_context=E2=80=99:
> drivers/infiniband/core/uverbs_cmd.c:307:23: attention : assignment d=
iscards =E2=80=98const=E2=80=99 qualifier from pointer target type [ena=
bled by default]
> drivers/infiniband/core/uverbs_cmd.c: In function =E2=80=98ib_uverbs_=
alloc_pd=E2=80=99:
> drivers/infiniband/core/uverbs_cmd.c:516:23: attention : assignment d=
iscards =E2=80=98const=E2=80=99 qualifier from pointer target type [ena=
bled by default]
> ...
>
> [1] https://lists.01.org/pipermail/kbuild-all/2013-November/002120.ht=
ml
>
> [2] https://patchwork.kernel.org/patch/2846202/
>      http://marc.info/?i=3D3050a98379b4342ea59d59aeaf1ce162171df928.1=
376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>
> Link: http://marc.info/?i=3Dcover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/core/uverbs.h      | 12 ++++++------
>   drivers/infiniband/core/uverbs_cmd.c  | 20 ++++++++++----------
>   drivers/infiniband/core/uverbs_main.c | 13 ++++++++-----
>   3 files changed, 24 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/co=
re/uverbs.h
> index 9879568aed8c..0dca1975d59d 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -47,12 +47,12 @@
>   #include <rdma/ib_umem.h>
>   #include <rdma/ib_user_verbs.h>
>
> -#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
> -	do {								\
> -		(udata)->inbuf  =3D (const void __user *) (ibuf);		\
> -		(udata)->outbuf =3D (void __user *) (obuf);		\
> -		(udata)->inlen  =3D (ilen);				\
> -		(udata)->outlen =3D (olen);				\
> +#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)	\
> +	do {						\
> +		(udata)->inbuf  =3D (ibuf);		\
> +		(udata)->outbuf =3D (obuf);		\
> +		(udata)->inlen  =3D (ilen);		\
> +		(udata)->outlen =3D (olen);		\
>   	} while (0)
>
>   /*
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 65f6e7dc380c..d9d91c412628 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -305,7 +305,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_fi=
le *file,
>   	}
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,

The response field is already __u64 and casting to (void __user *)=20
should match the machine's pointer type size. Why do we have to cast to=
=20
(unsigned long) and then cast to (void __user *) ?

>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	ucontext =3D ibdev->alloc_ucontext(ibdev, &udata);
> @@ -514,7 +514,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file =
*file,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	uobj =3D kmalloc(sizeof *uobj, GFP_KERNEL);
> @@ -711,7 +711,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file=
 *file,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof  resp);
>
>   	mutex_lock(&file->device->xrcd_tree_mutex);
> @@ -923,7 +923,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *f=
ile,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	if ((cmd.start & ~PAGE_MASK) !=3D (cmd.hca_va & ~PAGE_MASK))
> @@ -1215,7 +1215,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_fi=
le *file,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	if (cmd.comp_vector >=3D file->device->num_comp_vectors)
> @@ -1311,7 +1311,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_fi=
le *file,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	cq =3D idr_read_cq(cmd.cq_handle, file->ucontext, 0);
> @@ -1513,7 +1513,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_fi=
le *file,
>   		return -EPERM;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	obj =3D kzalloc(sizeof *obj, GFP_KERNEL);
> @@ -1700,7 +1700,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file=
 *file,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	obj =3D kmalloc(sizeof *obj, GFP_KERNEL);
> @@ -2976,7 +2976,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_f=
ile *file,
>   	xcmd.srq_limit	 =3D cmd.srq_limit;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	ret =3D __uverbs_create_xsrq(file, &xcmd, &udata);
> @@ -3001,7 +3001,7 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_=
file *file,
>   		return -EFAULT;
>
>   	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>   		   in_len - sizeof cmd, out_len - sizeof resp);
>
>   	ret =3D __uverbs_create_xsrq(file, &cmd, &udata);
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index 34386943ebcf..14d864371050 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -635,6 +635,7 @@ static ssize_t ib_uverbs_write(struct file *filp,=
 const char __user *buf,
>   		__u32 command;
>
>   		struct ib_uverbs_ex_cmd_hdr ex_hdr;
> +		char __user *response;
>   		struct ib_udata ucore;
>   		struct ib_udata uhw;
>   		int err;
> @@ -668,7 +669,9 @@ static ssize_t ib_uverbs_write(struct file *filp,=
 const char __user *buf,
>   		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 !=3D count)
>   			return -EINVAL;
>
> -		if (ex_hdr.response) {
> +		response =3D (char __user *)(unsigned long)ex_hdr.response;
> +
> +		if (response) {
>   			if (!hdr.out_words && !ex_hdr.provider_out_words)
>   				return -EINVAL;
>   		} else {
> @@ -677,14 +680,14 @@ static ssize_t ib_uverbs_write(struct file *fil=
p, const char __user *buf,
>   		}
>
>   		INIT_UDATA(&ucore,
> -			   (hdr.in_words) ? buf : 0,
> -			   (unsigned long)ex_hdr.response,
> +			   (hdr.in_words) ? buf : NULL,
> +			   response,
>   			   hdr.in_words * 8,
>   			   hdr.out_words * 8);
>
>   		INIT_UDATA(&uhw,
> -			   (ex_hdr.provider_in_words) ? buf + ucore.inlen : 0,
> -			   (ex_hdr.provider_out_words) ? (unsigned long)ex_hdr.response +=
 ucore.outlen : 0,
> +			   (ex_hdr.provider_in_words) ? buf + ucore.inlen : NULL,
> +			   (ex_hdr.provider_out_words) ? response + ucore.outlen : NULL,
>   			   ex_hdr.provider_in_words * 8,
>   			   ex_hdr.provider_out_words * 8);
>
>

Best regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
