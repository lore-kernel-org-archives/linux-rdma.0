From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Thu, 17 Sep 2009 07:24:45 -0700
Message-ID: <adafxalejiq.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <1253187028.8439.2.camel@twins> (Peter Zijlstra's message of
	"Thu, 17 Sep 2009 13:30:28 +0200")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
List-Id: linux-rdma@vger.kernel.org


 > Anton Blanchard suggested a while back that this might be integrated
 > with perf-counters, since perf-counters already does mmap() tracking and
 > also provides events through an mmap()'ed buffer.
 > 
 > Has anybody looked into this?

I didn't see the original suggestion.  Certainly hooking in to existing
infrastructure for user/kernel communication would be good.

The fit doesn't seem great to me, although I am rather naive about perf
counters.  The problem that ummunotify is trying to solve is to let an
app say 'for these 1000 address ranges (that possibly only cover a small
part of my total address space), please let me know when the mappings
are invalidated for any reason'.

So getting those events in the kernel is no problem -- we have the MMU
notifier hooks that tell us exactly what we need to know.  The issue is
purely the way userspace registers interest in address ranges, and how
to kernel returns the events.

For perf counters it seems that one would have to create a new counter
for each address range... is that correct?  And also I don't know if
perf counter has an analog for the fast path optimization that
ummunotify provides via a mmap'ed generation counter (a quick way for
userspace to see 'nothing happened since last time you checked').

 - R.
