From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Fri, 11 Sep 2009 00:40:19 -0600
Message-ID: <20090911064019.GZ4973@obsidianresearch.com>
References: <aday6omhz9d.fsf@cisco.com>
	<20090911145036.DB65.A69D9226@jp.fujitsu.com>
	<adatyzahvbm.fsf@cisco.com> <4AA9EAF7.5010401@inria.fr>
	<adapr9yhug3.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <adapr9yhug3.fsf@cisco.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Roland Dreier <rdreier@cisco.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, general@lists.openfabrics.org, Brice Goglin <Brice.Goglin@inria.fr>, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 10, 2009 at 11:22:20PM -0700, Roland Dreier wrote:

> As I said, it does mean that MPI can invalidate cached registrations for
> COWed memory, which might be useful in case a parent forks and then
> touches memory it used to use for RDMA, but I think that's the easier
> part of the fork/COW problem.

What happens to all the other IB resources (PD, CQ, QP, etc) on fork?

AFAIK, pretty much by design the IB stack cannot/does not duplicate
these objects.

The natural consequence is that a PD is always associated with a
single process at a time, thus a memory registration which is
associated with a PD must also be associated with a single process.

So.. What is the problem with fork? The semantics of what should
happen seem natural enough to me, the PD doesn't get copied to the
child, so the MR stays with the parent. COW events on the pinned
region must be resolved so that the physical page stays with the
process that has pinned it - the pin is logically released in the
child because the MR doesn't exist because the PD doesn't exist.

Is this a general problem with the MR mechanism? If I
mmap(MAP_SHARED|MAP_READONLY) and someone mmaps(MAP_PRIVATE|MAP_WRITE)
on the same file I can generate COW events - will this make RDMAs go
randomly too?? 

Jason
