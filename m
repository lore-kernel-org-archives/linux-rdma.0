From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Tue, 8 Dec 2015 23:07:44 +0200
Message-ID: <CAJ3xEMj397H-9Jrfk3K+MX92d6Q4gNA8w2tkKM6LytodPSbP-g@mail.gmail.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
	<CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
	<561E510C.8060501@redhat.com>
	<CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
	<56266C4B.1060000@redhat.com>
	<CAJ3xEMhexSZhkVVqZaCxvYYKXay6FWrUsXoKgmW=Q-+2pcdN8w@mail.gmail.com>
	<CAJ3xEMiDpiVWeW7MVs8VuULj39VchDW==OpqB28ni3U_=i5Dog@mail.gmail.com>
	<562A57AB.4000702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562A57AB.4000702-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 23, 2015 at 5:52 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/23/2015 02:46 AM, Or Gerlitz wrote:

>> Doug, there are few singleton patches to mlxN drivers, just to make
>> sure they are not left behind (thanks)

>> a small mlx5 enhancement, Signed by Eli C. the driver maintainer
>> https://patchwork.kernel.org/patch/7454641

>> two small mlx4 fixes, acked by me...
>> https://patchwork.kernel.org/patch/7348911/
>> https://patchwork.kernel.org/patch/7348871/

> Yes, I know.  There are quite a few different things for mlx5.  I was
> waiting on all of them until I knew that RoCEv2 was in as that gates
> whether or not mlx5 RoCE can go in.

Doug,

So RoCEv2 didn't make it for 4.4, but still, the above are changes
touching driver only code and I don't see why they should be waiting
so long.

Can we finally see them in a k.o branch of yours please? either for
your 4.4-rc pull or on 4.5 branch.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
