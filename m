From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Sun, 8 Nov 2015 17:04:55 +0200
Message-ID: <CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
	<1446745208-17733-3-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446745208-17733-3-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 5, 2015 at 7:40 PM, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> When an extended verbs is an extension to a legacy verb, the original
> functionality is preserved. Hence we do not require each hardware driver
> to set the extended capability. This will allow to use the extended verb
> in its simple form with drivers that do not support the extended
> capability.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_main.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index e93ba9125198..1740a03e6ac6 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -672,6 +672,21 @@ out:
>         return ev_file;
>  }
>
> +static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
> +{
> +       u64 mask;
> +
> +       if (command <= IB_USER_VERBS_CMD_OPEN_QP)

I think using IB_USER_VERBS_CMD_THRESHOLD is clearer, but I don't
think we need two uverbs_cmd_mask vendor variables.
IMHO, a vendor shouldn't care if it's an extended/legacy uverb
command. Maybe we should replace uverbs_cmd_mask with a bitmap.

> +               mask = ib_dev->uverbs_cmd_mask;
> +       else
> +               mask = ib_dev->uverbs_ex_cmd_mask;
> +
> +       if (mask & ((u64)1 << command))
> +               return 0;
> +
> +       return -1;
> +}
> +
>  static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>                              size_t count, loff_t *pos)
>  {
> @@ -704,6 +719,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>         }
>
>         command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
> +       if (verify_command_mask(ib_dev, command)) {
> +               ret = -EINVAL;

Why did you replace ENOSYS with EINVAL?

> +               goto out;
> +       }
>
>         flags = (hdr.command &
>                  IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
> @@ -721,11 +740,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>                         goto out;
>                 }
>
> -               if (!(ib_dev->uverbs_cmd_mask & (1ull << command))) {
> -                       ret = -ENOSYS;
> -                       goto out;
> -               }
> -
>                 if (hdr.in_words * 4 != count) {
>                         ret = -EINVAL;
>                         goto out;
> @@ -753,11 +767,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
>                         goto out;
>                 }
>
> -               if (!(ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
> -                       ret = -ENOSYS;
> -                       goto out;
> -               }
> -
>                 if (count < (sizeof(hdr) + sizeof(ex_hdr))) {
>                         ret = -EINVAL;
>                         goto out;
> --
> 2.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
