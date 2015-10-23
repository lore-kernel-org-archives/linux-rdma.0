From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Fri, 23 Oct 2015 09:46:02 +0300
Message-ID: <CAJ3xEMiDpiVWeW7MVs8VuULj39VchDW==OpqB28ni3U_=i5Dog@mail.gmail.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
	<CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
	<561E510C.8060501@redhat.com>
	<CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
	<56266C4B.1060000@redhat.com>
	<CAJ3xEMhexSZhkVVqZaCxvYYKXay6FWrUsXoKgmW=Q-+2pcdN8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhexSZhkVVqZaCxvYYKXay6FWrUsXoKgmW=Q-+2pcdN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Tue, Oct 20, 2015 at 7:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>> [...] Next I'll be pulling simple for-next items, then I'll be reviewing the
>> RoCE GID cadche usage in verbs/cma v2 patchset, then the Add RoCE v2
>> support v1 patchset, then the New fast registration API v5 set.

Doug, there are few singleton patches to mlxN drivers, just to make
sure they are not left behind (thanks)

a small mlx5 enhancement, Signed by Eli C. the driver maintainer
https://patchwork.kernel.org/patch/7454641

two small mlx4 fixes, acked by me...
https://patchwork.kernel.org/patch/7348911/
https://patchwork.kernel.org/patch/7348871/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
