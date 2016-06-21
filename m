From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 00/29] Soft RoCE driver
Date: Tue, 21 Jun 2016 10:21:36 +0300
Message-ID: <CAG9sBKPOxXMb=cFQTqiujRmRBz=HwK5yAZROvjsCeLXN_OT0EA@mail.gmail.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com> <030701d1cb27$6a968ef0$3fc3acd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <030701d1cb27$6a968ef0$3fc3acd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 20, 2016 at 10:10 PM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>>
>> Soft RoCE resources:
>>
>> [1[ https://github.com/SoftRoCE/librxe-dev librxe - source code in Github
>> [2] https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home - Soft RoCE Wiki
> page
>> [3] https://github.com/SoftRoCE/librxe-dev - Soft RoCE userspace library
>>
>
> Hey Moni, is there a branch in [2] that matches this submission?
>
>
Hi Steve
branch rxe_submission_v16 matches series 2.
Please note that you need to fetch also librxe (no change in branch
there) as name of the shared user/kerenl file was changed
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
