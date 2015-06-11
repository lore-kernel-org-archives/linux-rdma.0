From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Thu, 11 Jun 2015 13:09:15 +0300
Message-ID: <CAAKD3BARmPfc4=y5brjEmiLc1oh4H4oiToppAmijE9LRNZgRHg@mail.gmail.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
	<55769561.8000300@mellanox.com>
	<5577FAFB.8020205@mellanox.com>
	<20150610150010.GA11243@obsidianresearch.com>
	<557852EE.5030107@mellanox.com>
	<20150610184954.GA26404@obsidianresearch.com>
	<1433984788.71666.78.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433984788.71666.78.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 4:06 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2015-06-10 at 12:49 -0600, Jason Gunthorpe wrote:
>> On Wed, Jun 10, 2015 at 06:08:30PM +0300, Matan Barak wrote:
>> > >It isn't really a cleanup because the whole gid table is new code and
>> > >has latent elements for rocev2 - this is why it is so much bigger than
>> > >it should be.
>> >
>> > I disagree. Could you please point on anything that is RoCE V2 specific?
>> > The essence of RoCE V2 in the previous series was the gid_type part.
>> > This is now completely removed.
>>
>> Sure gid_type is gone, but I didn't say roceve2 specific, I said
>> latent elements. ie I'm assuming reasons for the scary locking are
>> because the ripped out rocev2 code needed it?  And some of the
>> complexity that looks pointless now was supporting ripped out rocev2
>> elements? That is not necessarily bad, but the code had better be good
>> quailty and working..
>>
>> But then I look at the patches, and the very first locking I test out
>> looks wrong. I see call_rcu/synchronize_rcu being used without a
>> single call to rcu_read_lock. So this fails #2 of the RCU review
>> checklist (Seriously? Why am I catching this?)
>>
>> I stopped reading at that point.
>
> The way they chose to split up patches is part of the problem here.
>
> People tend to push the "patches should be small, self contained,
> incremental" ideal.  In some cases, that gets carried to an extreme.  In
> this case, patch 1 introduces one side of the locking and patch 3 and 5
> introduce the other halves.
>
> In all, this needs to be re-ordered first off:
>
> Patch 4 should be 1 and netdev@ should be Cc:ed
> Patch 6 should be 2 and netdev@ should be Cc:ed
> Patch 2 should be 3 (or just all by itself in a separate submission)
> Patch 1, 3, and 5 should be squashed down to a single patch so that the
> locking can actually be analyzed for correctness.
>
>> I think you've got the right basic idea for a cleanup series here. It
>> is time to buckle down and execute it well.
>

Ok, we'll reorder and squash the required parts.

> Except that this isn't really a cleanup, and calling it that clouds the
> issue.  Both the mlx4 and ocrdma drivers implement incomplete RoCE gid
> management support.  If this were a true cleanup, they would just merge
> the support from mlx4 and ocrdma to core and switch the drivers over to
> it.  But that's not the case.  The new core code implements everything
> that the two drivers do, and then some more.  And in the process is
> standardizes some things that weren't standardized before.  So, a much
> more accurate description of this would be to say that the patchset
> implements a core RoCE GID management that is a much more complete
> management engine than either driver's engine, and that the last few
> patches remove the partial engines from the drivers and switch the
> drivers over to the core engine.
>
> My only complaints so far are these:
>
> 1)  I would have preferred that this be treated just like the other ib
> cache items.  The source of changes are different, but in essence, the
> RoCE gid table *is* a cache.  It's not real until the hardware writes
> it.  I would have preferred to see the handling of the roce_gid_table
> all contained in the cache file with the other cache operations.  If you
> wanted to keep the management portion in its own file, that I would have
> been fine with, but anything that manipulated the table should have been
> with the other cache manipulation functions.
>

Actually I thought the putting in a different file will make it more
maintainable.
We could move it to cache.c. Since the roce_gid_table is structured a
bit differently than the current gid_cache, are you willing to live
with the same structure of code and data-structures, just moved to
cache.c and prefixed with ib_cache_roce_xxxx ?

> 2)  I'm not convinced at all that RCU was needed and that a rwlock
> wouldn't have been sufficient.  What drove you to use RCU and do you
> have numbers to back up that it matters?
>

RCU is only used in order to protect the ndev. seqcount is used to
protect reading while writing and mutex protects several writers.
seqcount was chosen as write is sleep-able context and read could take
place in atomic context.

>>  Do an internal mellanox
>> kernel team review of this series. Audit and fix all the locking,
>> evaluate the code growth and design. Audit to confirm there is no
>> functional change that is not documented in a commit message. Tell me
>> v6 is the best effort *team Mellanox* can put forward.
>>
>> Jason
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
