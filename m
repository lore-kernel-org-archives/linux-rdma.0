From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 10/29] IB/rxe: Interface to ib_core
Date: Sun, 19 Jun 2016 14:12:55 +0300
Message-ID: <CAG9sBKOK-jPrrVw5xjL77a64mCqYAdyoWxzzgHGTXG_S0VsjfQ@mail.gmail.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com>
 <1466084751-29901-11-git-send-email-monis@mellanox.com> <00c301d1c7de$09147da0$1b3d78e0$@opengridcomputing.com>
 <20160616180131.GD23229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160616180131.GD23229-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> I have done some work that binds the original version of this stuff to
> a non-net device and makes it run as soft-ib.
>
> I can't recall where the hooks ended up, but please consider that use-case.
>
OK, so for the meantime I'll leave it as is with home to find more use
cases later.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
