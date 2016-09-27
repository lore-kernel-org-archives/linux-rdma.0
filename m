From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] libocrdma: Move ocrdma's list
 implementation into common directory
Date: Tue, 27 Sep 2016 12:03:24 -0600
Message-ID: <20160927180324.GA5304@obsidianresearch.com>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-5-git-send-email-leon@kernel.org>
 <20160925144121.GA12246@infradead.org>
 <20160925161315.GD4088@leon.nu>
 <20160925162203.GA32434@infradead.org>
 <20160926174057.GD22965@obsidianresearch.com>
 <20160926221440.GA5878@infradead.org>
 <20160926222319.GA2358@obsidianresearch.com>
 <ff764b75-19af-340b-7228-328462c524ae@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ff764b75-19af-340b-7228-328462c524ae-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 27, 2016 at 07:14:09PM +0300, Yishai Hadas wrote:
> Leon is out of office for a week, I can take it from here and come to the
> list in coming days with a new candidate series based on previous notes.

Right, I forgot..

> Few notes to sync on:
> 1) Looking at ocrdma_list.h it extends the list default functionality to use
> an internal mutex, see list_lock & list_unlock calls. This is not a standard
> usage of a list. It may require some logic outside list.h to replace the
> usage without introducing the mutex in the shared new H file.

I noticed that. It doesn't look too bad, there are only two call sites
to list_lock, so I'd just move the mutex from the list head to the
ocrdma_dev_list.

> 2) Taking list.h from the 'CCAN' URL requires taking as well few other H
> files that it uses internally (e.g. build_assert.h). In few cases I don't
> see any reason to take the full file into rdma-core (e.g. ccan/str/str.h for
> stringify) will take only the needed functionality into list.h.

Hum. We have various other places using stringify and other
macros. Nothing in str.h looks bad at my first glance, so I'd just
take the whole thing.

It will be easier to work with ccan going forward if you minimize the
changes made to their stuff.

I suggest putting into a top level ccan/ (or util/ccan?) directory,
flatten the directory structure and we will compile the C component of
it into libccan.a and libccan_pic.a and link everything to it.

> 3) Need to clean up the 'CCAN' files from its include to "config.h",  in
> addition, need to consider the functionality that need to be taken when
> there are some #if HAVE_XXX internally. (see #if HAVE_TYPEOF in list.h).

If you can get the code ported with a hardwired config.h (just add
stuff to buildlib/config.h.in) and whatever else, send it to me and
I'll get everything sorted out for cmake.

Generally speaking though, as code that targets only Linux, and only
Linux distros of a certain age, we can safely make a lot of
assumptions.

> 4) Re the licensing disclaimer in each H file, what do you suggest to put ?
> for example minmax.h uses licenses/CC0 see
> https://github.com/rustyrussell/ccan/blob/master/ccan/minmax/LICENSE which
> is different comparing list.h which is ../../licenses/BSD-MIT.

If we go with the ccan/ top level then add the the files as
ccan/COPYING.CCO and ccan/COPYING.MIT, etc and update the comments
accordingly.

So far all the options we've found require accepting single-licened
code. I view this as OK since those two licenses are widely regarded
to be GPLv2 compatible, and specifically OK'd by the FSF. I'd prefer
this situation to the current situation of having potentially
GPLv2-only code...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
