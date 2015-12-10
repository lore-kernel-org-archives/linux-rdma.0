From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/5] IB/core: Add ib_is_udata_cleared
Date: Thu, 10 Dec 2015 19:29:22 +0200
Message-ID: <CAAKD3BDfobwroOnvoxPMTA5zL=wxY3KDL=FAvq5EdUOkFG_F+Q@mail.gmail.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
	<1449157463-25313-3-git-send-email-matanb@mellanox.com>
	<56658718.8080308@mellanox.com>
	<CAAKD3BC7bhKC+jKV3aH9W+pcBwV19PJZYwXdZue6hNew=CJW9g@mail.gmail.com>
	<5669983E.5000200@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5669983E.5000200-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 5:20 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 10/12/2015 16:59, Matan Barak wrote:
>> On Mon, Dec 7, 2015 at 3:18 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> On 12/03/2015 05:44 PM, Matan Barak wrote:
>>>> Extending core and vendor verb commands require us to check that the
>>>> unknown part of the user's given command is all zeros.
>>>> Adding ib_is_udata_cleared in order to do so.
>>>>
>>>
>>> Why not copy the data into kernel space and run memchr_inv() on it?
>>>
>>
>> Probably less efficient, isn't it?
> Why do you think it is less efficient?
>
> I'm not sure calling copy_from_user multiple times is very efficient.
> For once, you are calling access_ok multiple times. I guess it depends
> on the amount of data you are copying.
>

Isn't access_ok pretty cheap?
It calls __chk_range_not_ok which on x86 seems like a very cheap
function and __chk_user_ptr which is a compiler check.
I guess most kernel-user implementation will be pretty much in sync,
so we'll possibly call it for a few/dozens of bytes. In that case, I
think this implementation is a bit faster.

>> I know it isn't data path, but we'll execute this code in all extended
>> functions (sometimes even more than once).
> Do you think it is important enough to maintain our own copy of
> memchr_inv()?
>

True, I'm not sure it's important enough, but do you think it's that
complicated?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
