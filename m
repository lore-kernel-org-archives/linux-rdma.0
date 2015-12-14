From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/5] IB/core: Add ib_is_udata_cleared
Date: Mon, 14 Dec 2015 18:31:10 +0200
Message-ID: <CAAKD3BBKu493f539h+SfG=JLgW-OKrsUZ8FhZPHy598n6+j4=Q@mail.gmail.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
	<1449157463-25313-3-git-send-email-matanb@mellanox.com>
	<56658718.8080308@mellanox.com>
	<CAAKD3BC7bhKC+jKV3aH9W+pcBwV19PJZYwXdZue6hNew=CJW9g@mail.gmail.com>
	<5669983E.5000200@mellanox.com>
	<CAAKD3BDfobwroOnvoxPMTA5zL=wxY3KDL=FAvq5EdUOkFG_F+Q@mail.gmail.com>
	<566D9315.9050807@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <566D9315.9050807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 13, 2015 at 5:47 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 10/12/2015 19:29, Matan Barak wrote:
>> On Thu, Dec 10, 2015 at 5:20 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> On 10/12/2015 16:59, Matan Barak wrote:
>>>> On Mon, Dec 7, 2015 at 3:18 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> On 12/03/2015 05:44 PM, Matan Barak wrote:
>>>>>> Extending core and vendor verb commands require us to check that the
>>>>>> unknown part of the user's given command is all zeros.
>>>>>> Adding ib_is_udata_cleared in order to do so.
>>>>>>
>>>>>
>>>>> Why not copy the data into kernel space and run memchr_inv() on it?
>>>>>
>>>>
>>>> Probably less efficient, isn't it?
>>> Why do you think it is less efficient?
>>>
>>> I'm not sure calling copy_from_user multiple times is very efficient.
>>> For once, you are calling access_ok multiple times. I guess it depends
>>> on the amount of data you are copying.
>>>
>>
>> Isn't access_ok pretty cheap?
>> It calls __chk_range_not_ok which on x86 seems like a very cheap
>> function and __chk_user_ptr which is a compiler check.
>> I guess most kernel-user implementation will be pretty much in sync,
>> so we'll possibly call it for a few/dozens of bytes. In that case, I
>> think this implementation is a bit faster.
>>
>>>> I know it isn't data path, but we'll execute this code in all extended
>>>> functions (sometimes even more than once).
>>> Do you think it is important enough to maintain our own copy of
>>> memchr_inv()?
>>>
>>
>> True, I'm not sure it's important enough, but do you think it's that
>> complicated?
>
> It is complicated in my opinion. It is 67 lines of code, it's
> architecture dependent and relies on preprocessor macros and conditional
> code. I think this kind of stuff belongs in lib/string.c and not in the
> RDMA stack.
>

I'm not sure regarding the string.c location, as it deals with user
buffers, but in order not to
be dependent on this, I'll change this code to the following.

static inline bool ib_is_udata_cleared(struct ib_udata *udata,
                                       u8 cleared_char,
                                       size_t offset,
                                       size_t len)
{
        const void __user *p = udata->inbuf + offset;
        bool ret = false;
        u8 *buf;

        if (len > USHRT_MAX)
                return false;

        buf = kmalloc(len, GFP_KERNEL);
        if (!buf)
                return false;

        if (copy_from_user(buf, p, len))
                goto free;

        ret = !memchr_inv(buf, cleared_char, len);

free:
        kfree(buf);
        return ret;
}

> Haggai

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
