From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Trying to link with DAT 2.0 function
Date: Mon, 11 Oct 2010 14:34:13 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011B5755C8@orsmsx506.amr.corp.intel.com>
References: <1F77938CC2143D47AE7204B1DB33104C02C9FC57@XMBIL151.northgrum.com>
 <E3280858FA94444CA49D2BA02341C983011B575529@orsmsx506.amr.corp.intel.com>
 <1F77938CC2143D47AE7204B1DB33104C02C9FD0E@XMBIL151.northgrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1F77938CC2143D47AE7204B1DB33104C02C9FD0E-/R8ruR6G1fHgAiKnVY1dJgQSgKfZeEaX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Young, Eric R." <Eric.Young-itBhTGHPdi0@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Do you have a roadmap available? Is this planned to be implemented in
>the near future?

There are no plans. I really don't know how this call even made
it in the specification given that DAT is suppose to be O/S agnostic.

In any case, can you use dat_cno_wait() on top of the EVD's 
as a means to support/trigger multiple event streams? What is driving 
your choice to use dat_cno_fd_create()? Maybe we can come up 
with an alternative with the existing API.

Arlin





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
