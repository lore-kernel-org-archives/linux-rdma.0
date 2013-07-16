From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/4] IB/core: Infra-structure to support verbs
 extensions through uverbs
Date: Tue, 16 Jul 2013 06:33:42 +0300
Message-ID: <CAJZOPZLkF9+VJDYFCjcKMV9uQ3eJ1+mSDyOG7J_UBqAP3mWjcw@mail.gmail.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com>
	<1372251464-13394-3-git-send-email-ogerlitz@mellanox.com>
	<CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA@mail.gmail.com>
	<CACZyyF8=dzjktGYAWfHkXdNQycdkP5x0t=rYckTypxj7GLznzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACZyyF8=dzjktGYAWfHkXdNQycdkP5x0t=rYckTypxj7GLznzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 9, 2013 at 6:00 PM, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 26/06/2013 16:05, Roland Dreier wrote:
>  >> I don't understand what "extended capabilities" are or why we nee=
d
> to change the header format.
>
> First let me clarify the target of *this* patch - allow extending
> uverbs new commands input and output variables. Whenever a specific
> IB_USER_VERBS_CMD_XXX is extended =3D=3D needs to have additional
> arguments, we will be able to add them without creating a completely
> new IB_USER_VERBS_CMD_YYY command or bumping the uverbs ABI version.
> This patch alone doesn=92t provide the whole scheme which is also
> dependent on adding comp_mask to the extended uverbs structs - see my
> explanation below, and do let me know if an actual use case is more o=
f
> self-explaining.
>
> On 26/06/2013 16:05, Roland Dreier wrote:
>  >> What is the "verbs extensions approach"?
>
> Similar to the scheme built with Sean and Jason for user verbs
> extension support in libibverbs, that can be reviewed in the XRC
> patches Sean submitted, we=92d like to build a scheme for the kernel
> uverbs as well.
>
> On 26/06/2013 16:05, Roland Dreier wrote:
>  >> Why does the kernel need to know about it?
>
> The kernel uverbs are the ones that we wish to add extension
> capability in this patch (vs. the user verbs which exisit in an
> orthogonal patch).
>
> On 26/06/2013 16:05, Roland Dreier wrote:
>  >> What is different about the processing?
>
> Ok, so we want to allow future extension of the CMD arguments
> (ib_uverbs_cmd_hdr.in_words, ib_uverbs_cmd_hdr.out_words) for an
> existing new command (=3D a command that supports the new uverbs comm=
and
> header format suggested in this patch) w/o bumping ABI ver and with
> maintaining backward and formward compatibility to new and old
> libibverbs versions.
> In the uverbs command we are passing both uverbs arguments and the
> provider arguments (mlx4_ib in our case), for example take the
> create_cq call:
> Uverbs gets struct ibv_create_cq, mlx4_ib gets struct mlx4_create_cq
> (which includes struct ibv_create_cq), and In_words =3D
> sizeof(mlx4_create_cq)/4.
> Thus ib_uverbs_cmd_hdr.in_words carry both uverbs plus mlx4_ib input
> argument sizes, where uverbs assumes it knows the size of its input
> argument - struct ibv_create_cq.
> Now, if we wish to add a variable to struct ibv_create_cq, we can add
> a comp_mask field to the struct which is basically bit field
> indicating which fields exists in the struct (as done for the
> libibverbs API extension), but we need a way to tell what is the tota=
l
> size of the struct and not assume the struct size is predefined (sinc=
e
> we may get different struct sizes from different user libibverbs
> vers), so we know at which point the provider input argument (struct
> mlx4_create_cq ) begins. Same goes for extending the provider struct
> mlx4_create_cq. Thus we split the ib_uverbs_cmd_hdr.in_words to
> ib_uverbs_cmd_hdr.in_words which will now carry only uverbs input
> argument struct size and ib_uverbs_cmd_hdr.provider_in_words that wil=
l
> carry the provider (mlx4_ib) input argument size. Same goes for the
> response (the uverbs CMD output argument).
>
> Tzahi

Roland,

Does the above helps to address your question/concerns on the matter?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
