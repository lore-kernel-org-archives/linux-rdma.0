From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Wed, 9 Dec 2015 01:13:29 +0200
Message-ID: <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
	<566753E3.9060301@redhat.com>
	<CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
	<20151208225940.GB27609@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208225940.GB27609-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 9, 2015 at 12:59 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Dec 09, 2015 at 12:47:55AM +0200, Or Gerlitz wrote:

>> The patch is three liner to add the cached attrs --
>> http://marc.info/?l=linux-rdma&m=142309296813985&w=2 -- if you are OK
>> with that, I will add a 2nd patch that ports all ULPs to use the
>> cached copy instead of their code which does the query.

>> Actually, why not start with this approach and later decide if we need
>> to go further of this is enough?

> Or, can we please stop this bikeshedding. Christoph's patch is done,
> well tested and does a lot more clean up that this hacky three liner.

Christoph patch is here indeed, it does two things

1. remove all the ULP device attr alloc, device query, attr free hassle
2. adds tons of new fields to struct ib_device

I think it just goes too much and needlessly adds tons of these new
fields directly to struct ib_device where we can have them all well
scoped into ib_device_attr member or pointer from struct ib_device

> It is a good patch,

I didn't say it's bad, I said I think we can achieve #1 above with way
less drastic patch, and I'd like to hear the maintainer option, and
have the chance to argu with the maintainer if needed, yours I heard,
you like it, I know.

> and although patchworks doesn't have my remarks
> from an earlier revision I still think it should go forward.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
