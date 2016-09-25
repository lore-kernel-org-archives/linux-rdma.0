From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma_rxe: Fix kernel crash when IPV6 disabled.
Date: Sun, 25 Sep 2016 10:46:19 +0530
Message-ID: <CAG53R5V0ECVWh7jCQVV78Rf8Qe1iUJ-JGbHDzShskme_wYbY6w@mail.gmail.com>
References: <1474730674-4017-1-git-send-email-pandit.parav@gmail.com> <20160925043648.GT4088@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925043648.GT4088-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 25, 2016 at 10:06 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sat, Sep 24, 2016 at 03:24:34PM +0000, Parav Pandit wrote:
>> This patch fixes below kernel crash when CONFIG_IPV6 is disabled by
>> avoiding ip6 socket initialization.
>>
>> Additionally it has below minor related cleanup around recv_sockets elements.
>>
>> 1. Avoid extern for structure which is locally used in file
>> 2. Define recv_sockets as static as its used by single file
>> 3. Follow reverse deallocation order than allocation order for
>> recv_sockets elements
>
> Thanks Parav,
> This crash was already fixed upstream.
> https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/commit/drivers/infiniband/sw/rxe?id=dfdd6158ca2c8838313470c5ab79243d04da70b2

ok. Thanks. I was in 4.8-rc branch and I searched for rdma_rxe tag for
commits based on Stephen's rdma_rxe tag. This one was done using
IB/rxe.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
