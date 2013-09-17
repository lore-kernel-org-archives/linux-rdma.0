From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for rdma_ucm
Date: Tue, 17 Sep 2013 13:02:05 +0300
Message-ID: <5238289D.40608@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com> <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com> <26c47667e463e65dd79caaa4bddc437b@meuh.org> <523054BA.2040608@mellanox.com> <97104d76028c356b458509ce95b08c92@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <97104d76028c356b458509ce95b08c92-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/9/2013 3:36 PM, Yann Droneaud wrote:
> Le 11.09.2013 13:32, Or Gerlitz a =C3=A9crit :
>> On 11/09/2013 12:52, Yann Droneaud wrote:
>>> Le 10.09.2013 16:41, Or Gerlitz a =C3=A9crit :
>>>> +static ssize_t ucma_init_qp_attr_ex(struct ucma_file *file,
>>>> +                    const char __user *inbuf,
>>>> +                    int in_len, int out_len)
>>>> +{
>>>> +    struct rdma_ucm_init_qp_attr_ex cmd;
>>>> +    struct ib_uverbs_qp_attr_ex resp;
>>>> +    struct ucma_context *ctx;
>>>> +    struct ib_qp_attr qp_attr;
>>>> +    int ret;
>>>> +
>>>> +    if (out_len < sizeof(resp))
>>>> +        return -ENOSPC;
>>>> +
>>>> +    if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
>>>> +        return -EFAULT;
>>>> +
>>>> +    if (copy_from_user(&resp, (void __user *)(unsigned
>>>> long)cmd.response,
>>>> +               sizeof(resp)))
>>>> +        return -EFAULT;
>>>> +
>>>
>>>
>>> Reading from the response buffer ? I haven't seen that before in
>>> IB/core before.
>>
>> The intent here is to use copy_from_user just to make sure the user =
space
>> provided buffer has enough room to hold the kernel response structur=
e.
>> This
>> this command may be extended in the future without bumping the overa=
ll
>> uverbs ABI
>> version we wanted to add this extra protection.
>
> It's checking nothing ... you should not suppose the user having / no=
t
> having its buffer end
> aligned on a page boundary, so that the kernel will detect the end of
> buffer
> when trying to read from it.
>
> BTW, out_len is already checked against resp size ... so I don't
> understand yet.

That's right - we're not checking anything here.
struct ib_uverbs_qp_attr_ex contains 2 user pointers:
+       /* represents: struct ib_uverbs_ah_attr_ex * __user */
+       void __user *ah_attr_ex;
+       /* represents: struct ib_uverbs_ah_attr_ex * __user */
+       void __user *alt_ah_attr_ex;

Those pointers should be given to rdma_init_qp_attr in order to=20
initialize them.

We are using pointers here in order to maintain future extendability of=
=20
the address handle structures.

>
> Regards.
>
Regards
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
