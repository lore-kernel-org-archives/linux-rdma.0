From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] IB/core kobject cleanup
Date: Tue, 3 Jun 2014 11:29:44 +0300
Message-ID: <CAJZOPZ+AFVumOfaNtPcpgRbLcGzhNbUEM=wBv0JzfQL6+vNurw@mail.gmail.com>
References: <1400400746-9030-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400400746-9030-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 18, 2014 at 11:12 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Hi, These patches clean up the kobject destruction code in IB/core, and fix a
> memory leak.

Hi Roland, it seems you missed this small patch series which Haggai
sent few weeks ago, can you please pick it for 3.16?

Or.


> Haggai Eran (3):
>   IB/core: remove unneeded kobject_get/put calls
>   IB/core: fix port kobject deletion during error flow
>   IB/core: fix kobject leak on device register error flow
>
>  drivers/infiniband/core/sysfs.c | 85 ++++++++++++++++++++++-------------------
>  1 file changed, 45 insertions(+), 40 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
