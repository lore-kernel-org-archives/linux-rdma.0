From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Allow legacy verbs through extended interfaces
Date: Thu, 05 Nov 2015 11:41:57 +0100
Message-ID: <1446720117.10170.35.camel@opteya.com>
References: <20151104193621.GA30146@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104193621.GA30146-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 04 novembre 2015 =C3=A0 21:36 +0200, Eli Cohen a =C3=A9crit=
 :
> When an extended verbs is an extension to a legacy verb, the original
> functionality is preserved. Hence we do not require each hardware=20
> driver to set the extended capability. This will allow to use the=20
> extended verb in its simple form with drivers that do not support the=
=20
> extended capability.
>=20
> In addition, avoid code duplication by moving sanity checks to a
> common
> area.
>=20

Those checks were written with the assumption the command and flags
masks could be different between the legacy and the new verb format.

But since it did happen (yet), it's ok to avoid the duplication (I
would have prefer a separate preliminary patch for this).


> Change-Id: Iedba714224fa07b85325c146621c07e0dbf349fb
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_main.c | 30 ++++++++++---------------
> -----
>  1 file changed, 10 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_main.c
> b/drivers/infiniband/core/uverbs_main.c
> index e3ef28861be6..0ae934d81b04 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -678,6 +678,7 @@ static ssize_t ib_uverbs_write(struct file *filp,
> const char __user *buf,
>  	struct ib_uverbs_file *file =3D filp->private_data;
>  	struct ib_device *ib_dev;
>  	struct ib_uverbs_cmd_hdr hdr;
> +	__u32 command;
>  	__u32 flags;
>  	int srcu_key;
>  	ssize_t ret;
> @@ -699,17 +700,15 @@ static ssize_t ib_uverbs_write(struct file
> *filp, const char __user *buf,
>  	flags =3D (hdr.command &
>  		 IB_USER_VERBS_CMD_FLAGS_MASK) >>
> IB_USER_VERBS_CMD_FLAGS_SHIFT;
> =20
> -	if (!flags) {
> -		__u32 command;
> -
> -		if (hdr.command &
> ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> -					 =20
>  IB_USER_VERBS_CMD_COMMAND_MASK)) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> +	if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> +				   IB_USER_VERBS_CMD_COMMAND_MASK))
> {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> =20
> -		command =3D hdr.command &
> IB_USER_VERBS_CMD_COMMAND_MASK;
> +	command =3D hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
> =20
> +	if (!flags) {
>  		if (command >=3D ARRAY_SIZE(uverbs_cmd_table) ||
>  		    !uverbs_cmd_table[command]) {
>  			ret =3D -EINVAL;
> @@ -738,21 +737,11 @@ static ssize_t ib_uverbs_write(struct file
> *filp, const char __user *buf,
>  						 hdr.out_words * 4);
> =20
>  	} else if (flags =3D=3D IB_USER_VERBS_CMD_FLAG_EXTENDED) {
> -		__u32 command;
> -
>  		struct ib_uverbs_ex_cmd_hdr ex_hdr;
>  		struct ib_udata ucore;
>  		struct ib_udata uhw;
>  		size_t written_count =3D count;
> =20
> -		if (hdr.command &
> ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
> -					 =20
>  IB_USER_VERBS_CMD_COMMAND_MASK)) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> -
> -		command =3D hdr.command &
> IB_USER_VERBS_CMD_COMMAND_MASK;
> -
>  		if (command >=3D ARRAY_SIZE(uverbs_ex_cmd_table) ||
>  		    !uverbs_ex_cmd_table[command]) {
>  			ret =3D -ENOSYS;
> @@ -764,7 +753,8 @@ static ssize_t ib_uverbs_write(struct file *filp,
> const char __user *buf,
>  			goto out;
>  		}
> =20
> -		if (!(ib_dev->uverbs_ex_cmd_mask & (1ull <<
> command))) {
> +		if ((command > IB_USER_VERBS_CMD_OPEN_QP) &&

What about IB_USER_VERBS_CMD_THRESHOLD instead of
 IB_USER_VERBS_CMD_OPEN_QP ?

> +		    !(ib_dev->uverbs_ex_cmd_mask & (1ull <<
> command))) {
>  			ret =3D -ENOSYS;
>  			goto out;
>  		}


uverbs_ex_cmd_table[] has already been looked up at this point, so that
can only work if uverbs_ex_cmd_table[] is extended to support the
legacy verbs.

Currently there's only two verbs with dual implementation

  IB_USER_VERBS_EX_CMD_QUERY_DEVICE
  IB_USER_VERBS_EX_CMD_CREATE_CQ


If we want to have a 1:1 mapping legacy verbs as extended verbs, then I
would suggest to check the legacy mask to not allow a legacy verb not
supported by the hw provider to be called:

	if (! (((command <=3D IB_USER_VERBS_CMD_OPEN_QP) ?
		 ib_dev->uverbs_cmd_mask :
		 ib_dev->uverbs_ex_cmd_mask) & (1 ull << command))) {
		ret =3D -ENOSYS;
		goto out;
	}

Perhaps we could drop uverbs_ex_cmd_mask and set bit for extended verbs
in uverbs_cmd_mask instead. Then, there will be no need to check againt
the command threshold.

Anyway, this is a new assumption that extended verbs will have to be
somewhat retro compatible with the legacy hw provider implementation
used by the legacy verbs they intend to replace: an extended verbs
matching a legacy one will need to be written in such way it will not
be calling into a hw provider function pointer that can be NULL (in
case there's new function pointer is added for an updated verbs in
struct ib_device  while we keep in place the legacy one ... but for in
-kernel drivers that should never happen: it usual better to replace
the previous one by the newer and the existing drivers have to be
updated to provide the new function and remove the previous one, so I
think it's quite safe).

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
