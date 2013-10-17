From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] IB/core: extended command: an improved
 infrastructure for uverbs commands
Date: Thu, 17 Oct 2013 17:05:00 +0200
Message-ID: <f45595bcb4399ea2cb81d99a914dd9a0@meuh.org>
References: <cover.1381510045.git.ydroneaud@opteya.com>
 <0b84e20b204eb0fc67db9ca9106d6bf753a12ae3.1381510045.git.ydroneaud@opteya.com>
 <525C0FF2.5040905@mellanox.com> <525FF724.5050601@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525FF724.5050601-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 17.10.2013 16:41, Matan Barak a =C3=A9crit=C2=A0:
> On 14/10/2013 6:38 PM, Matan Barak wrote:
>> On 11/10/2013 8:57 PM, Yann Droneaud wrote:
>>> Commit 400dbc9 added an infrastructure for extensible uverbs
>>> commands while later commit 436f2ad exported
>>> ib_create_flow()/ib_destroy_flow()
>>> functions using this new infrastructure.
>>>=20

>>> diff --git a/drivers/infiniband/core/uverbs_main.c
>>> b/drivers/infiniband/core/uverbs_main.c
>>> index 75ad86c..4f00654 100644
>>> --- a/drivers/infiniband/core/uverbs_main.c
>>> +++ b/drivers/infiniband/core/uverbs_main.c
>>> @@ -587,6 +592,7 @@ static ssize_t ib_uverbs_write(struct file *fil=
p,
>>> @@ -594,41 +600,104 @@ static ssize_t ib_uverbs_write(struct file
>>> *filp, const char __user *buf,
>>>          if (copy_from_user(&hdr, buf, sizeof hdr))
>>>                  return -EFAULT;
>>>=20
>>> -       if (hdr.command >=3DRRAY_SIZE(uverbs_cmd_table) ||
>>> -           !uverbs_cmd_table[hdr.command])
>>> -               return -EINVAL;
>>> +       flags =3Dhdr.command &
>>> +                IB_USER_VERBS_CMD_FLAGS_MASK) >>
>>> IB_USER_VERBS_CMD_FLAGS_SHIFT;
>>>=20
>>> -       if (!file->ucontext &&
>>> -           hdr.command !=3DB_USER_VERBS_CMD_GET_CONTEXT)
>>> -               return -EINVAL;
>>> +       if (!flags) {
>>> +               __u32 command;
>>>=20
>>> -       if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull <<
>>> hdr.command)))
>>> -               return -ENOSYS;
>>> +               if (hdr.command &=20
>>> ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
>>> +
>>> IB_USER_VERBS_CMD_COMMAND_MASK))
>>> +                       return -EINVAL;
>>>=20
>>> -       if (hdr.command >=3DB_USER_VERBS_CMD_THRESHOLD) {
>>> -               struct ib_uverbs_cmd_hdr_ex hdr_ex;
>>> +               command =3Ddr.command & IB_USER_VERBS_CMD_COMMAND_M=
ASK;
>>>=20
>>> -               if (copy_from_user(&hdr_ex, buf, sizeof(hdr_ex)))
>>> -                       return -EFAULT;
>>> +               if (command >=3DRRAY_SIZE(uverbs_cmd_table) ||
>>> +                   !uverbs_cmd_table[command])
>>> +                       return -EINVAL;
>>>=20
>>> -               if (((hdr_ex.in_words + hdr_ex.provider_in_words) *=
=20
>>> 4)
>>> !=3Dount)
>>> +               if (!file->ucontext &&
>>> +                   command !=3DB_USER_VERBS_CMD_GET_CONTEXT)
>>>                          return -EINVAL;
>>>=20
>>> -               return uverbs_cmd_table[hdr.command](file,
>>> -                                                    buf +
>>> sizeof(hdr_ex),
>>> -                                                    (hdr_ex.in_wor=
ds=20
>>> +
>>> -
>>> hdr_ex.provider_in_words) * 4,
>>> -                                                   =20
>>> (hdr_ex.out_words +
>>> -
>>> hdr_ex.provider_out_words) * 4);
>>> -       } else {
>>> +               if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull=
=20
>>> <<
>>> command)))
>>> +                       return -ENOSYS;
>>> +
>>>                  if (hdr.in_words * 4 !=3Dount)
>>>                          return -EINVAL;
>>>=20
>>> -               return uverbs_cmd_table[hdr.command](file,
>>> -                                                    buf +=20
>>> sizeof(hdr),
>>> -                                                    hdr.in_words *=
=20
>>> 4,
>>> -                                                    hdr.out_words =
*=20
>>> 4);
>>> +               return uverbs_cmd_table[command](file,
>>> +                                                buf + sizeof(hdr),
>>> +                                                hdr.in_words * 4,
>>> +                                                hdr.out_words * 4)=
;
>>> +
>>> +       } else if (flags =3DIB_USER_VERBS_CMD_FLAG_EXTENDED) {
>>> +               __u32 command;
>>> +
>>> +               struct ib_uverbs_ex_cmd_hdr ex_hdr;
>>> +               struct ib_udata ucore;
>>> +               struct ib_udata uhw;
>>> +               int err;
>>> +
>>> +               if (hdr.command &=20
>>> ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
>>> +
>>> IB_USER_VERBS_CMD_COMMAND_MASK))
>>> +                       return -EINVAL;
>>> +
>>> +               command =3Ddr.command & IB_USER_VERBS_CMD_COMMAND_M=
ASK;
>>> +
>>> +               if (command >=3DRRAY_SIZE(uverbs_ex_cmd_table) ||
>>> +                   !uverbs_ex_cmd_table[command])
>>> +                       return -ENOSYS;
>>> +
>>> +               if (!file->ucontext)
>>> +                       return -EINVAL;
>>> +
>>> +               if (!(file->device->ib_dev->uverbs_ex_cmd_mask &=20
>>> (1ull
>>> << command)))
>>> +                       return -ENOSYS;
>>> +
>>> +               if (count < (sizeof(hdr) + sizeof(ex_hdr)))
>>> +                       return -EINVAL;
>>> +
>>> +               if (copy_from_user(&ex_hdr, buf + sizeof(hdr),
>>> sizeof(ex_hdr)))
>>> +                       return -EFAULT;
>>> +
>>> +               count -=3Dizeof(hdr) + sizeof(ex_hdr);
>=20
> A small issue: count is reduced here and the write function returns
> the reduced size.
> I think we should return the amount of data the user wrote and not to
> subtract the headers from the returned size.
>=20

Good catch.

>>> +
>>> +               return count;
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D^
>=20


>>> diff --git a/include/uapi/rdma/ib_user_verbs.h
>>> b/include/uapi/rdma/ib_user_verbs.h
>>> index 93577fc..cbfdd4c 100644
>>> --- a/include/uapi/rdma/ib_user_verbs.h
>>> +++ b/include/uapi/rdma/ib_user_verbs.h
>>> @@ -87,8 +87,11 @@ enum {
>>>          IB_USER_VERBS_CMD_CLOSE_XRCD,
>>>          IB_USER_VERBS_CMD_CREATE_XSRQ,
>>>          IB_USER_VERBS_CMD_OPEN_QP,
>>> -       IB_USER_VERBS_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THRESHO=
LD,
>>> -       IB_USER_VERBS_CMD_DESTROY_FLOW
>>> +};
>>> +
>>> +enum {
>>> +       IB_USER_VERBS_EX_CMD_CREATE_FLOW =3D=20
>>> IB_USER_VERBS_CMD_THRESHOLD,
>>> +       IB_USER_VERBS_EX_CMD_DESTROY_FLOW
>>>   };
>>=20
>> I think B_USER_VERBS_CMD_THRESHOLD could be removed.
>>=20

If it's removed, CREATE_FLOW will be the first command.

I thought it could be interesting to keep room for the "legacy"
commands if they're going to be supported as extended commands
in the future.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
