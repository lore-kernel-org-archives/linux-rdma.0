From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib_uverbs: Fix pages leak when using XRC SRQs
Date: Tue, 14 Apr 2015 14:24:22 +0300
Message-ID: <552CF8E6.4030300@dev.mellanox.co.il>
References: <20150407132224.5f201e40@dingo>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150407132224.5f201e40@dingo>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?windows-1252?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue-BUmcmmAb0Fc@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/7/2015 2:22 PM, S=E9bastien Dugu=E9 wrote:
>
>    Hello,
>
>    When an application using XRCs abruptly terminates, the mmaped pag=
es
> of the CQ buffers are leaked.
>
>    This comes from the fact that when resources are released in
> ib_uverbs_cleanup_ucontext(), we fail to release the CQs because thei=
r
> refcount is not 0.
>
>    When creating an XRC SRQ, we increment the associated CQ refcount.
> This refcount is only decremented when the SRQ is released.
>
>    Therefore we need to release the SRQs prior to the CQs to make sur=
e
> that all references to the CQs are gone before trying to release thes=
e.
>
> Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
> ---
>   drivers/infiniband/core/uverbs_main.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index 259dcc7..88cce9b 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -246,6 +246,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_=
uverbs_file *file,
>   		kfree(uqp);
>   	}
>
> +	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
> +		struct ib_srq *srq =3D uobj->object;
> +		struct ib_uevent_object *uevent =3D
> +			container_of(uobj, struct ib_uevent_object, uobject);
> +
> +		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
> +		ib_destroy_srq(srq);
> +		ib_uverbs_release_uevent(file, uevent);
> +		kfree(uevent);
> +	}
> +
>   	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
>   		struct ib_cq *cq =3D uobj->object;
>   		struct ib_uverbs_event_file *ev_file =3D cq->cq_context;
> @@ -258,17 +269,6 @@ static int ib_uverbs_cleanup_ucontext(struct ib_=
uverbs_file *file,
>   		kfree(ucq);
>   	}
>
> -	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
> -		struct ib_srq *srq =3D uobj->object;
> -		struct ib_uevent_object *uevent =3D
> -			container_of(uobj, struct ib_uevent_object, uobject);
> -
> -		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
> -		ib_destroy_srq(srq);
> -		ib_uverbs_release_uevent(file, uevent);
> -		kfree(uevent);
> -	}
> -
>   	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
>   		struct ib_mr *mr =3D uobj->object;
>
>

Nice catch,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
