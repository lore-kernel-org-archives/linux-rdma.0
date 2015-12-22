From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: device attr cleanup
Date: Tue, 22 Dec 2015 09:56:28 +0200
Message-ID: <CAJ3xEMiGOF79o1OSgxgk2tN+kY91uiNY5Aq+xu2U0Sur-htxpQ@mail.gmail.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
	<566753E3.9060301@redhat.com>
	<CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
	<20151208225940.GB27609@obsidianresearch.com>
	<CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
	<CAJ3xEMgQNMtxgTKC0zaKgy-WGugf6KwT7Ys5h3_RbN_7qd2=tg@mail.gmail.com>
	<56706414.8010807@redhat.com>
	<5670FC5E.8070405@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5670FC5E.8070405-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 7:53 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/15/2015 9:03 PM, Doug Ledford wrote:

>> Or, you specifically asked me to wait until this week.  I made my
>> initial impressions clear (I don't necessarily like the removal of the
>> attr struct, but I like the removal of all of the query calls, and I'm
>> inclined to take the patch in spite of not liking the removal of the
>> struct).  Do you have anything to add or have we beat this horse to death?

> Hi Doug,
> Lets stop beating, both horses and people.
> I do understand that
> 1. you don't link the removal of the attr
> 2. you do like the removal of all the query calls
>
> I am proposing to take the path of a patch that
> does exactly #2 while avoiding #1.

Doug,

Did you look on my v1 post and the related discussion there w.r.t udata?

You didn't make any comment on my response here nor on the proposed patches.

Since we are really short in time w.r.t EOY holidays and we have the
udata matter
open (see [1]), could we move finalizing this discussion to the 4.6 time-frame?

If you do have the time, I think it would be fair to see a response
from you on the
discussion before you pick any of the two patch sets - so??

Or.

[1] Christoph's patch doesn't remove the query_device callback from
mlx4 since we
report there values to libmlx4 through the udata mechanism. The
query_device callback
will need to be present in future/current drivers if they decide to
use udata as well


> What's wrong with that? I haven't heard any reasoning for why its
> so good to stash ~50 new fields on the IB device structure except
> for the author saying that other subsystems do that and other people
> saying they are in favor of this approach while not providing any
> reasoning, except for maybe something on bikes.
>
> Why you or anyone else has to be from now and ever the cache line police
> making sure that people don't add new attributes in random locations
> over the IB device structure?
>
> What's wrong with putting fifty attributesin a structure which is a field
> of the device struct and have people go there to see what are the d
> ifferentattrs and add news ones there?
>
> This will make the 4.5 merge window extremely complex or even totally
> threatened  w.r.t to the RDMA subsystem and related drivers by 3.3K LOC
> patch.
>
> Sorry, but, I still don't get it.
>
> Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
