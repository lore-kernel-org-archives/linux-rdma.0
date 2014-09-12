From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
Date: Sat, 13 Sep 2014 00:16:20 +0300
Message-ID: <CAJ3xEMhSZcrN0_nurc=-sUT+KM3vFgAD6XJjjA-eK0-Jyeut0Q@mail.gmail.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
	<5405D2D8.1040700@mellanox.com>
	<CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com>
	<CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com>
	<CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
	<540F0CD8.9070002@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540F0CD8.9070002-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Latchesar Ionkov <lionkov-YOWKrPYUwWM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 9, 2014, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 04/09/2014, Roland Dreier wrote:

>> Have you done any review or testing of these changes?  If so can you
>> share the results?

> We have tested this feature thoroughly inside Mellanox. We ran random
> tests that performed MR registrations, memory mappings and unmappings,
> calls to madvise with MADV_DONTNEED for invalidations, sending and
> receiving of data, and RDMA operations. The test validated the integrity
> of the data, and we verified the integrity of kernel memory by running
> the tests under a debugging kernel.

Hi Roland,

Per your request we provided the information on tests conducted with
the patches.

Note that the patches can't really disrupt existing applications that
don't set the new IB_ACCESS_ON_DEMAND MR flag when they register
memory. Also
the whole set of changes to the umem area is dependent on building with
CONFIG_INFINIBAND_ON_DEMAND_PAGING -- all in all, everything is in
place for protecting against potential regression that this series
could introduce.

As you didn't provide any feedback for > six months, and we have all
the above in place (report on stability tests, performance data and
mechanics to avoid regressions) I think it would be fair to get this
picked for the coming merge window, thoughts?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
