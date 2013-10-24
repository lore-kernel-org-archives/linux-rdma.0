From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/9] IB/core: extended command: an improved infrastructure
 for uverbs commands
Date: Thu, 24 Oct 2013 03:34:28 +0300
Message-ID: <CAJZOPZJPCW_DRxP9JJZCwXKPPskWa8YRDXPwMzvecWYHWC_uNA@mail.gmail.com>
References: <cover.1381510045.git.ydroneaud@opteya.com>
	<0b84e20b204eb0fc67db9ca9106d6bf753a12ae3.1381510045.git.ydroneaud@opteya.com>
	<525C0FF2.5040905@mellanox.com>
	<525FF724.5050601@mellanox.com>
	<f45595bcb4399ea2cb81d99a914dd9a0@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f45595bcb4399ea2cb81d99a914dd9a0-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 17, 2013 at 6:05 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> w=
rote:
> Hi,
>
> Le 17.10.2013 16:41, Matan Barak a =E9crit :
>
>> On 14/10/2013 6:38 PM, Matan Barak wrote:
>>>
>>> On 11/10/2013 8:57 PM, Yann Droneaud wrote:
>>>>
>>>> Commit 400dbc9 added an infrastructure for extensible uverbs
>>>> commands while later commit 436f2ad exported
>>>> ib_create_flow()/ib_destroy_flow()
>>>> functions using this new infrastructure.
>>>>
>
>>>> diff --git a/drivers/infiniband/core/uverbs_main.c
>>>> b/drivers/infiniband/core/uverbs_main.c
>>>> index 75ad86c..4f00654 100644
>>>> --- a/drivers/infiniband/core/uverbs_main.c
>>>> +++ b/drivers/infiniband/core/uverbs_main.c
>>>> @@ -587,6 +592,7 @@ static ssize_t ib_uverbs_write(struct file *fi=
lp,
>>>> @@ -594,41 +600,104 @@ static ssize_t ib_uverbs_write(struct file
>>>> *filp, const char __user *buf,
>>>>          if (copy_from_user(&hdr, buf, sizeof hdr))
>>>>                  return -EFAULT;
>>>>
>>>> -       if (hdr.command >=3DRRAY_SIZE(uverbs_cmd_table) ||
>>>> -           !uverbs_cmd_table[hdr.command])
>>>> -               return -EINVAL;
>>>> +       flags =3Dhdr.command &
>>>> +                IB_USER_VERBS_CMD_FLAGS_MASK) >>
>>>> IB_USER_VERBS_CMD_FLAGS_SHIFT;
>>>>
>>>> -       if (!file->ucontext &&
>>>> -           hdr.command !=3DB_USER_VERBS_CMD_GET_CONTEXT)
>>>> -               return -EINVAL;
>>>> +       if (!flags) {
>>>> +               __u32 command;
>>>>
>>>> -       if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull <<
>>>> hdr.command)))
>>>> -               return -ENOSYS;
>>>> +               if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS=
_MASK
>>>> |
>>>> +
>>>> IB_USER_VERBS_CMD_COMMAND_MASK))
>>>> +                       return -EINVAL;
>>>>
>>>> -       if (hdr.command >=3DB_USER_VERBS_CMD_THRESHOLD) {
>>>> -               struct ib_uverbs_cmd_hdr_ex hdr_ex;
>>>> +               command =3Ddr.command & IB_USER_VERBS_CMD_COMMAND_=
MASK;
>>>>
>>>> -               if (copy_from_user(&hdr_ex, buf, sizeof(hdr_ex)))
>>>> -                       return -EFAULT;
>>>> +               if (command >=3DRRAY_SIZE(uverbs_cmd_table) ||
>>>> +                   !uverbs_cmd_table[command])
>>>> +                       return -EINVAL;
>>>>
>>>> -               if (((hdr_ex.in_words + hdr_ex.provider_in_words) =
* 4)
>>>> !=3Dount)
>>>> +               if (!file->ucontext &&
>>>> +                   command !=3DB_USER_VERBS_CMD_GET_CONTEXT)
>>>>                          return -EINVAL;
>>>>
>>>> -               return uverbs_cmd_table[hdr.command](file,
>>>> -                                                    buf +
>>>> sizeof(hdr_ex),
>>>> -                                                    (hdr_ex.in_wo=
rds +
>>>> -
>>>> hdr_ex.provider_in_words) * 4,
>>>> -                                                    (hdr_ex.out_w=
ords +
>>>> -
>>>> hdr_ex.provider_out_words) * 4);
>>>> -       } else {
>>>> +               if (!(file->device->ib_dev->uverbs_cmd_mask & (1ul=
l <<
>>>> command)))
>>>> +                       return -ENOSYS;
>>>> +
>>>>                  if (hdr.in_words * 4 !=3Dount)
>>>>                          return -EINVAL;
>>>>
>>>> -               return uverbs_cmd_table[hdr.command](file,
>>>> -                                                    buf + sizeof(=
hdr),
>>>> -                                                    hdr.in_words =
* 4,
>>>> -                                                    hdr.out_words=
 * 4);
>>>> +               return uverbs_cmd_table[command](file,
>>>> +                                                buf + sizeof(hdr)=
,
>>>> +                                                hdr.in_words * 4,
>>>> +                                                hdr.out_words * 4=
);
>>>> +
>>>> +       } else if (flags =3DIB_USER_VERBS_CMD_FLAG_EXTENDED) {
>>>> +               __u32 command;
>>>> +
>>>> +               struct ib_uverbs_ex_cmd_hdr ex_hdr;
>>>> +               struct ib_udata ucore;
>>>> +               struct ib_udata uhw;
>>>> +               int err;
>>>> +
>>>> +               if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS=
_MASK
>>>> |
>>>> +
>>>> IB_USER_VERBS_CMD_COMMAND_MASK))
>>>> +                       return -EINVAL;
>>>> +
>>>> +               command =3Ddr.command & IB_USER_VERBS_CMD_COMMAND_=
MASK;
>>>> +
>>>> +               if (command >=3DRRAY_SIZE(uverbs_ex_cmd_table) ||
>>>> +                   !uverbs_ex_cmd_table[command])
>>>> +                       return -ENOSYS;
>>>> +
>>>> +               if (!file->ucontext)
>>>> +                       return -EINVAL;
>>>> +
>>>> +               if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (=
1ull
>>>> << command)))
>>>> +                       return -ENOSYS;
>>>> +
>>>> +               if (count < (sizeof(hdr) + sizeof(ex_hdr)))
>>>> +                       return -EINVAL;
>>>> +
>>>> +               if (copy_from_user(&ex_hdr, buf + sizeof(hdr),
>>>> sizeof(ex_hdr)))
>>>> +                       return -EFAULT;
>>>> +
>>>> +               count -=3Dizeof(hdr) + sizeof(ex_hdr);
>>
>>
>> A small issue: count is reduced here and the write function returns
>> the reduced size.
>> I think we should return the amount of data the user wrote and not t=
o
>> subtract the headers from the returned size.
>>
>
> Good catch.

Yann, the 3.13 merge window  is coming  closer, can you please post V2
of this series with fixes to the few
issues Matan was pointing on and possibly one squash @ the beginning
of the series, if this is possible.


>
>
>>>> +
>>>> +               return count;
>>
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D^
>>
>
>
>>>> diff --git a/include/uapi/rdma/ib_user_verbs.h
>>>> b/include/uapi/rdma/ib_user_verbs.h
>>>> index 93577fc..cbfdd4c 100644
>>>> --- a/include/uapi/rdma/ib_user_verbs.h
>>>> +++ b/include/uapi/rdma/ib_user_verbs.h
>>>> @@ -87,8 +87,11 @@ enum {
>>>>          IB_USER_VERBS_CMD_CLOSE_XRCD,
>>>>          IB_USER_VERBS_CMD_CREATE_XSRQ,
>>>>          IB_USER_VERBS_CMD_OPEN_QP,
>>>> -       IB_USER_VERBS_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THRESH=
OLD,
>>>>
>>>> -       IB_USER_VERBS_CMD_DESTROY_FLOW
>>>> +};
>>>> +
>>>> +enum {
>>>> +       IB_USER_VERBS_EX_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THR=
ESHOLD,
>>>> +       IB_USER_VERBS_EX_CMD_DESTROY_FLOW
>>>>   };
>>>
>>>
>>> I think B_USER_VERBS_CMD_THRESHOLD could be removed.
>>>
>
> If it's removed, CREATE_FLOW will be the first command.
>
> I thought it could be interesting to keep room for the "legacy"
> commands if they're going to be supported as extended commands
> in the future.
>
> Regards.
>
> --
> Yann Droneaud
> OPTEYA
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
