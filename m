From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 12/12] IB/mlx5: Limit mkey page size to 2GB
Date: Fri, 28 Oct 2016 19:53:24 +0300
Message-ID: <CAJ3xEMi4paPdk3giS5u87EOeTuYLbJG+AzROdkwUtbOW6i=D+w@mail.gmail.com>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
 <1477575407-20562-13-git-send-email-leon@kernel.org> <CAJ3xEMidqSMWs5TsxC9KBNcc_Li4nH9sb_-oUg-cKz8D_VtEdw@mail.gmail.com>
 <31841A29-5CE1-45A9-999A-1FAAA3CDFD4F@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31841A29-5CE1-45A9-999A-1FAAA3CDFD4F-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 28, 2016 at 4:21 PM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Oct 28, 2016, at 4:02 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> In case we are working with 1GB hugepage, it is possible to find more than
> two continuous pages, and end up with more than 2GB..

got it
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
