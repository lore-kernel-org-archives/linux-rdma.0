From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 15/15] RDMA/bnxt_re: Disable FMR by default
Date: Thu, 18 May 2017 11:11:56 +0530
Message-ID: <CA+sbYW2BOTWPw1_ko40YQvSTPZaL2VteDGm=8yWN31GZBAZSng@mail.gmail.com>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
 <1495012791-5053-16-git-send-email-selvin.xavier@broadcom.com>
 <be1696c2-f93f-5f5e-cbe8-968bf41903e7@intel.com> <20170518042456.GU3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518042456.GU3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Dennis and Leon for your comments. I will post V3 with the
change suggested.

On Thu, May 18, 2017 at 9:54 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, May 17, 2017 at 08:29:09AM -0400, Dennis Dalessandro wrote:
>> On 5/17/2017 5:19 AM, Selvin Xavier wrote:
>> > Adding a config mechanism to enable/disable FMR support.
>> > There are some issues seen with FMR implementation during
>> > stress traffic. So disabling it by default for now.
>>
>> If it doesn't work maybe just remove it rather than adding another Kconfig?
>
> +10000
>
>>
>> -Denny
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
