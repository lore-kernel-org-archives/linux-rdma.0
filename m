From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4: propagate node_description changes down to FW
Date: Sun, 3 Oct 2010 13:11:09 -0400
Message-ID: <AANLkTinhVqBxshfmdrzXPZeuxm2kXXagJ_addtjJgxtt@mail.gmail.com>
References: <4CA8A1BF.4050305@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443C180BA9AD@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443C180BA9AD-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yael Shenhav <yaeli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 3, 2010 at 12:01 PM, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org=
> wrote:
> I have not yet submitted the patch to the list. =C2=A0Without the pat=
ch, we have a race condition.
>
> Yevgeny, any ideas on scalability? What happens if opensm receives th=
e trap while it is performing a heavy sweep?

There's no requirement for a NodeDescription changed trap to cause a
"heavy" sweep at the SM so the scalability of this should be fine. The
mainstream OpenSM has implemented it this way for some months now.

-- Hal

>
> -Jack
>
> -----Original Message-----
> From: Or Gerlitz [mailto:ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org]
> Sent: Sunday, October 03, 2010 5:31 PM
> To: Jack Morgenstein; linux-rdma
> Subject: re: mlx4: propagate node_description changes down to FW
>
> Hi Jack,
>
> I just came across this patch of yours which was placed in ofed 1.5.2=
, I didn't see any track of it
> here @ linux-rdma (any specific reason for that?) - some questions/is=
sues to discuss -
>
> 1st and most, (say) for 1k node cluster, is it correct that for each =
node doing start/restart of the openibd
> service a trap will be sent to opensm and the latter will heavy sweep=
?! this doesn't sound very much scalable...
> have you tested it over large clusters? what was the impact?
>
> Or.
>
> mlx4: propagate node_description changes down to FW.
>
> The Node Description cannot be changed via MADs (it is read-only).
> Until now, it was changed in the driver, and the new Node Description
> was simply overwritten by the driver on MAD responses.
>
> The node description was modified in the driver by openibd via sysfs.
> However, that generated a race condition, where OpenSM could get the
> FW node description rather than the overwritten description if OpenSM
> queried the device before openibd had a chance to enter the new descr=
iption.
>
> The solution is a new FW command (SET_NODE) which allows passing the
> new node description to FW. When this command is invoked, FW issues
> a 144 trap to OpenSM. =C2=A0Upon receiving this trap, OpenSM initiate=
s a
> heavy sweep, thus updating the node description properly -- and elimi=
nating
> the race.
>
> This patch works whether or not the new FW command is available. =C2=A0=
If SET_NODE
> is not available, things work as before.
>
> Fixes FM82320
>
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>
> Index: ofed_kernel/drivers/infiniband/hw/mlx4/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- ofed_kernel.orig/drivers/infiniband/hw/mlx4/main.c =C2=A02010-09-=
27 17:20:54.069787000 +0200
> +++ ofed_kernel/drivers/infiniband/hw/mlx4/main.c =C2=A0 =C2=A0 =C2=A0=
 2010-09-27 17:21:15.074810000 +0200
> @@ -421,14 +421,34 @@ out:
> =C2=A0static int mlx4_ib_modify_device(struct ib_device *ibdev, int m=
ask,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ib_device_modify *pro=
ps)
> =C2=A0{
> + =C2=A0 =C2=A0 =C2=A0 struct mlx4_cmd_mailbox *mailbox;
> + =C2=A0 =C2=A0 =C2=A0 int err;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mask & ~IB_DEVICE_MODIFY_NODE_DESC)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EOPNOT=
SUPP;
>
> - =C2=A0 =C2=A0 =C2=A0 if (mask & IB_DEVICE_MODIFY_NODE_DESC) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&to_mdev=
(ibdev)->sm_lock);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(ibdev->node=
_desc, props->node_desc, 64);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&to_md=
ev(ibdev)->sm_lock);
> - =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (!(mask & IB_DEVICE_MODIFY_NODE_DESC))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock(&to_mdev(ibdev)->sm_lock);
> + =C2=A0 =C2=A0 =C2=A0 memcpy(ibdev->node_desc, props->node_desc, 64)=
;
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock(&to_mdev(ibdev)->sm_lock);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* if possible, pass node desc to FW, so it ca=
n generate
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* a 144 trap. If cmd fails, just ignore.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 mailbox =3D mlx4_alloc_cmd_mailbox(to_mdev(ibd=
ev)->dev);
> + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(mailbox))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 memset(mailbox->buf, 0, 256);
> + =C2=A0 =C2=A0 =C2=A0 memcpy(mailbox->buf, props->node_desc, 64);
> + =C2=A0 =C2=A0 =C2=A0 err =3D mlx4_cmd(to_mdev(ibdev)->dev, mailbox-=
>dma, 1, 0,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A);
> + =C2=A0 =C2=A0 =C2=A0 if (err)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlx4_ib_dbg("SET_N=
ODE command failed (%d)", err);
> +
> + =C2=A0 =C2=A0 =C2=A0 mlx4_free_cmd_mailbox(to_mdev(ibdev)->dev, mai=
lbox);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
> Index: ofed_kernel/include/linux/mlx4/cmd.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- ofed_kernel.orig/include/linux/mlx4/cmd.h =C2=A0 2010-09-27 17:20=
:40.519054000 +0200
> +++ ofed_kernel/include/linux/mlx4/cmd.h =C2=A0 =C2=A0 =C2=A0 =C2=A02=
010-09-27 17:21:15.081799000 +0200
> @@ -58,6 +58,7 @@ enum {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MLX4_CMD_SENSE_PORT =C2=A0 =C2=A0 =C2=A0=3D=
 0x4d,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MLX4_CMD_HW_HEALTH_CHECK =3D 0x50,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MLX4_CMD_SET_PORT =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D 0xc,
> + =C2=A0 =C2=A0 =C2=A0 MLX4_CMD_SET_NODE =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 0x5a,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MLX4_CMD_ACCESS_DDR =C2=A0 =C2=A0 =C2=A0=3D=
 0x2e,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MLX4_CMD_MAP_ICM =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D 0xffa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MLX4_CMD_UNMAP_ICM =C2=A0 =C2=A0 =C2=A0 =3D=
 0xff9,
> Index: ofed_kernel/drivers/net/mlx4/cmd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- ofed_kernel.orig/drivers/net/mlx4/cmd.c =C2=A0 =C2=A0 2010-09-27 =
17:20:32.995814000 +0200
> +++ ofed_kernel/drivers/net/mlx4/cmd.c =C2=A02010-09-27 17:21:15.0887=
92000 +0200
> @@ -242,8 +242,11 @@ static int mlx4_cmd_poll(struct mlx4_dev
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0__raw_readl(hcr + HCR_OUT_PARAM_OFFSET + 4));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0stat =3D be32_to_cpu((__force __be32) __ra=
w_readl(hcr + HCR_STATUS_OFFSET)) >> 24;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D mlx4_status_to_errno(stat);
> - =C2=A0 =C2=A0 =C2=A0 if (err)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlx4_err(dev, "com=
mand 0x%x failed: fw status =3D 0x%x\n", op, stat);
> + =C2=A0 =C2=A0 =C2=A0 if (err) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (op !=3D MLX4_C=
MD_SET_NODE || stat !=3D CMD_STAT_BAD_OP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mlx4_err(dev, "command 0x%x failed: fw status =3D 0x%x\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op, stat);
> + =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0up(&priv->cmd.poll_sem);
> @@ -296,8 +299,9 @@ static int mlx4_cmd_wait(struct mlx4_dev
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D context->result;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlx4_err(dev, "com=
mand 0x%x failed: fw status =3D 0x%x\n",
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0op, context->fw_status);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (op !=3D MLX4_C=
MD_SET_NODE || context->fw_status !=3D CMD_STAT_BAD_OP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mlx4_err(dev, "command 0x%x failed: fw status =3D 0x%x\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op, context->fw_status);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
