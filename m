From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/5] IB/core: Add ib_is_udata_cleared
Date: Thu, 10 Dec 2015 16:59:17 +0200
Message-ID: <CAAKD3BC7bhKC+jKV3aH9W+pcBwV19PJZYwXdZue6hNew=CJW9g@mail.gmail.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
	<1449157463-25313-3-git-send-email-matanb@mellanox.com>
	<56658718.8080308@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56658718.8080308-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 7, 2015 at 3:18 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/03/2015 05:44 PM, Matan Barak wrote:
>> Extending core and vendor verb commands require us to check that the
>> unknown part of the user's given command is all zeros.
>> Adding ib_is_udata_cleared in order to do so.
>>
>
> Why not copy the data into kernel space and run memchr_inv() on it?
>

Probably less efficient, isn't it?
I know it isn't data path, but we'll execute this code in all extended
functions (sometimes even more than once).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
