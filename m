From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 9 Jun 2016 10:05:06 +0300
Message-ID: <CAG9sBKMw_YwQZd8EoJ-ma6rhtG0Z6kNb6NpHtLVFaWedie3oag@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <00ef01d1c1a6$07784730$1668d590$@opengridcomputing.com> <010001d1c1ac$cfe397f0$6faac7d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <010001d1c1ac$cfe397f0$6faac7d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Steve

The following does the copy:

make headers_install INSTALL_HDR_PATH=/usr

On Wed, Jun 8, 2016 at 8:40 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> > Soft RoCE resources:
>> >
>> > [1] https://github.com/SoftRoCE/librxe-dev librxe - source code in Github
>> >
>> > [2] https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home - Soft RoCE Wiki
>> page
>>
>> Hey Moni,
>>
>> I'm trying to build librxe and it cannot find <rdma/ib_rxe.h>  Where does this
>> file come from?
>>
>
> Never mind. I see it is in include/uapi/rdma/
>
> I guess that needs to be copied to /usr/include/rdma to build librxe...
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
