From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Sun, 2 Aug 2015 00:40:51 +0300
Message-ID: <CAJ3xEMgNPdgTCT_-=bkush2rrezwvfDPK5OBJShArqad-3j1jw@mail.gmail.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
	<CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ@mail.gmail.com>
	<20150731073420.GB2485@infradead.org>
	<55BD2D57.8030107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BD2D57.8030107-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 1, 2015 at 11:34 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 07/31/2015 03:34 AM, Christoph Hellwig wrote:
>> On Fri, Jul 31, 2015 at 02:05:06AM +0300, Or Gerlitz wrote:
>>> So... enough is enough, please put it in a kernel module residing in
>>> the IB core and use it in this driver, to begin with. The fact that
>>> ipath is going to go, makes the cope duplication "only" 2X vs the 3X,
>>> but it's still 2X

>> Agreed.  Any if anyone tries to submit software RoCE again it'll be
>> another duplication.

> Or, I haven't looked at the soft-roce driver (ever).  Is it going to
> need this library as well?  If it is, then as you have rung the bell for
> getting this library written, I will expect Mellanox to work with Intel
> to make sure that this library is suitable for not just their hardware
> drivers but also the soft-roce driver you guys are working on.

Doug,

I'd like to make sure we're on the same page here: the upstream kernel
currently contains two SW implementations of IB transports, namely
within ipath and qib, the OPA driver is the third in that row, and
this is without any reason I can think of.

If we agree on that, this by itself justifies the OPA developers to
come up with factoring out the bits from qib and the OPA driver into a
library which is to be used by the two drivers.

As for soft-roce, indeed, that driver would uses SW implementation as
well, and it when we review this proposed library it should be usable
there too. One thing to take into account for that triple use-case
would be a layered breakdown, e.g to have the shared code deal with
the transport (L4) level without deep assumptions on the lower layers.

[...]

> if the soft-roce driver needs the library too, and it is
> not yet in a state to be submitted and even not in a state where its
> needs can be articulated clearly so that the library can be written with
> soft-roce's needs in mind as well as the Intel driver's needs, then I'll
> let the hfi1 driver out of staging before that task is complete and
> we'll just get to the library when we have all of the stake holders in
> place and can actually work on all of them at once.

Doug, this I can't understand, why have in upstream the same
functionality implemented three times: ipath, qib and hfi1?!

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
