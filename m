From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 8/9] gpu/drm/i915: optimize out the case when a range
 is updated to read only
Date: Tue, 29 Jan 2019 11:21:13 -0500
Message-ID: <20190129162112.GA3194@redhat.com>
References: <20190123222315.1122-1-jglisse@redhat.com>
 <20190123222315.1122-9-jglisse@redhat.com>
 <154833175216.4120.925061299171157938@jlahtine-desk.ger.corp.intel.com>
 <20190124153032.GA5030@redhat.com>
 <154877159986.4387.16328989441685542244@jlahtine-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <154877159986.4387.16328989441685542244@jlahtine-desk.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: linux-mm@kvack.org, Ralph Campbell <rcampbell@nvidia.com>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 29, 2019 at 04:20:00PM +0200, Joonas Lahtinen wrote:
> Quoting Jerome Glisse (2019-01-24 17:30:32)
> > On Thu, Jan 24, 2019 at 02:09:12PM +0200, Joonas Lahtinen wrote:
> > > Hi Jerome,
> > > 
> > > This patch seems to have plenty of Cc:s, but none of the right ones :)
> > 
> > So sorry, i am bad with git commands.
> > 
> > > For further iterations, I guess you could use git option --cc to make
> > > sure everyone gets the whole series, and still keep the Cc:s in the
> > > patches themselves relevant to subsystems.
> > 
> > Will do.
> > 
> > > This doesn't seem to be on top of drm-tip, but on top of your previous
> > > patches(?) that I had some comments about. Could you take a moment to
> > > first address the couple of question I had, before proceeding to discuss
> > > what is built on top of that base.
> > 
> > It is on top of Linus tree so roughly ~ rc3 it does not depend on any
> > of the previous patch i posted.
> 
> You actually managed to race a point in time just when Chris rewrote much
> of the userptr code in drm-tip, which I didn't remember of. My bad.
> 
> Still interested to hearing replies to my questions in the previous
> thread, if the series is still relevant. Trying to get my head around
> how the different aspects of HMM pan out for devices without fault handling.

HMM mirror does not need page fault handling for everything and in fact
for user ptr you can use HMM mirror without page fault support in hardware.
Page fault requirement is more like a __very__ nice to have feature.

So sorry i missed that mail i must had it in a middle of bugzilla spam
and deleted it. So here is a paste of it and answer. This was for a
patch to convert i915 to use HMM mirror instead of having i915 does it
own thing with GUP (get_user_page).

> Bit late reply, but here goes :)
>
> We're working quite hard to avoid pinning any pages unless they're in
> the GPU page tables. And when they are in the GPU page tables, they must
> be pinned for whole of that duration, for the reason that our GPUs can
> not take a fault. And to avoid thrashing GPU page tables, we do leave
> objects in page tables with the expectation that smart userspace
> recycles buffers.

You do not need to pin the page because you obey to mmu notifier ie
it is perfectly fine for you to keep the page map into the GPU until
you get an mmu notifier call back for the range of virtual address.

The pin from GUP in fact does not protect you from anything. GUP is
really misleading, by the time GUP return the page you get might not
correspond to the memory backing the virtual address.

In i915 code this is not an issue because you synchronize against
mmu notifier call back.

So my intention in converting GPU driver from GUP to HMM mirror is
just to avoid the useless page pin. As long as you obey the mmu
notifier call back (or HMM sync page table call back) then you are
fine.

> So what I understand of your proposal, it wouldn't really make a
> difference for us in the amount of pinned pages (which I agree,
> we'd love to see going down). When we're unable to take a fault,
> the first use effectively forces us to pin any pages and keep them
> pinned to avoid thrashing GPU page tables.

With HMM there is no pin, we never pin the page ie we never increment
the refcount on the page as it is useless to do so if you abide by
mmu notifier. Again the pin GUP take is misleading it does not block
mm event.

However Without pin and still abiding to mmu notifier you will not
see any difference in thrashing ie number of time you will get a mmu
notifier call back. As really those call back happens for good reasons.
For instance running out of memory and kernel trying to reclaim or
because userspace did a syscall that affect the range of virtual address.

This should not happen in regular workload and when they happen the pin
from GUP will not inhibit those either. In the end you will get the exact
same amount of trashing but you will inhibit thing like memory compaction
or migration while HMM does not block those (ie HMM is a good citizen ;)
while GUP user are not).

Also we are in the process of changing GUP and GUP will now have more
profound impact to filesystem and mm (inhibiting and breaking some of
the filesystem behavior). Converting GPU driver to HMM will avoid those
adverse impact and it is one of the motivation behind my crusade to
convert all GUP user that abide by mmu notifier to use HMM instead.


> So from i915 perspective, it just seems to be mostly an exchange of
> an API to an another for getting the pages. You already mentioned
> the fast path is being worked on, which is an obvious difference.
> But is there some other improvement one would be expecting, beyond
> the page pinning?

So for HMM i have a bunch of further optimization and new feature.
Using HMM would make it easier for i915 to leverage those.

> Also, is the requirement for a single non-file-backed VMA in the
> plans of being eliminated or is that inherent restriction of the
> HMM_MIRROR feature? We're currently not imposing such a limitation.

HMM does not have that limitation, never did. It seems that i915
unlike other driver does allow GUP on file back page, while other
GPU driver do not. So i made the assumption the i915 did have that
limitation without checking the code.


> > I still intended to propose to remove
> > GUP from i915 once i get around to implement the equivalent of GUP_fast
> > for HMM and other bonus cookies with it.
> > 
> > The plan is once i have all mm bits properly upstream then i can propose
> > patches to individual driver against the proper driver tree ie following
> > rules of each individual device driver sub-system and Cc only people
> > there to avoid spamming the mm folks :)
> 
> Makes sense, as we're having tons of changes in this field in i915, the
> churn to rebase on top of them will be substantial.

I am posting more HMM bits today for 5.1, i will probably post another i915
patchset in coming weeks. I will try to base it on for-5.1-drm tree as i am
not only doing i915 but amd too and it is easier if i can do all of them in
just one tree so i only have to switch GPU not kernel too for testing :)

> 
> Regards, Joonas
> 
> PS. Are you by any chance attending FOSDEM? Would be nice to chat about
> this.

No i am not going to fosdem :(

Cheers,
Jérôme
