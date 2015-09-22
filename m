From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/mlx4: Report checksum offload cap when query device
Date: Tue, 22 Sep 2015 07:45:57 +0300
Message-ID: <CAJ3xEMhZPBXxg9w5FY5=U4FGZJ4zkhO=0vPtUkXV1v5J3Aa0+A@mail.gmail.com>
References: <cover.1442413048.git.bodong@mellanox.com>
	<68bea4df2c89e5457aaaccf914756bc309d742a7.1442413048.git.bodong@mellanox.com>
	<55FB7AE8.2070304@redhat.com>
	<CAJ3xEMg31JSPU2_gW0OGjC9rdTgDRcx=7LnuPncD6+gCE7nRMw@mail.gmail.com>
	<56007DDF.30502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56007DDF.30502-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 22, 2015 at 12:59 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Here's the only matrix of IP checksumming that makes sense:
>
> 1) UD over IB (because it is one of the supported IPoIB types)
> 2) RC over IB (same as above)
> 3) Raw ETH over Eth (because IP over Eth makes sense and is a common
> type of packet to send on Raw Eth, but Raw Eth will never be sent on IB
> as it isn't supported there at all)
>
> Anything else would require adding more Raw ETH QPs elsewhere, or
> expanding the IPoIB spec to include more connection types.

OK, I'm good with that, so you want two news bits of device caps and
not the too fancy
matrix of checksum-caps-for-qp-type-and-link-type.

>> Really, there's enough spare bits in ib_device_cap_flags that
>> you could do away with the new caps entirely.

Yes, Bodong, please go ahead and use bits 26,27 of
include/rdma/ib_verbs.h :: enum ib_device_cap_flags
for the two new caps Doug asked.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
