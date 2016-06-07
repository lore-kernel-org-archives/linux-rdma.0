From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/7] IB/IPoIB: Fix race between ipoib_remove_one
 to sysfs functions
Date: Tue, 7 Jun 2016 13:45:20 +0300
Message-ID: <CAAk-MO_9P2vVJS_RXrqUPx224Re9sjifug+hfxVGN4Ze5tYhSg@mail.gmail.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
	<1465042524-25852-4-git-send-email-leon@kernel.org>
	<CAJ3xEMh_Pg2Kkp6yHx2OUJMokn0HX8Jd9Q0bcsB50KfTAcP1Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh_Pg2Kkp6yHx2OUJMokn0HX8Jd9Q0bcsB50KfTAcP1Gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 7, 2016 at 10:31 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, Jun 4, 2016 at 3:15 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> Fixes: 862096a8bbf8 ("IB/ipoib: Add more rtnl_link_ops callbacks")
>> Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
>
> These two commits go back to 3.7-rc1 / Oct 2012 -- so I wonder how come we never
> got reports on this ABBA deadlock happens in real life - any idea, did
> you see the deadlock in

Sure, it is from the real life, you can see the stack that i added to
the commit message.
If you want to simulate that just add sleep in the remove_one while
trying to change mode/add-child etc.

> action, ever? We did had lockdep warnings and thanks you Erez for

welcome.

> finally getting there to fix after me... I will look on your patch.

>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
