From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] mm: ratelimit PFNs busy info message
Date: Tue, 08 Aug 2017 15:34:02 +1000
Message-ID: <87k22eoc6t.fsf@concordia.ellerman.id.au>
References: <499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins@redhat.com> <20170802141720.228502368b534f517e3107ff@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170802141720.228502368b534f517e3107ff@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jonathan Toppins <jtoppins@redhat.com>
Cc: linux-mm@kvack.org, linux-rdma@vger.kernel.org, dledford@redhat.com, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@techsingularity.net>, Hillf Danton <hillf.zj@alibaba-inc.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed,  2 Aug 2017 13:44:57 -0400 Jonathan Toppins <jtoppins@redhat.com> wrote:
>
>> The RDMA subsystem can generate several thousand of these messages per
>> second eventually leading to a kernel crash. Ratelimit these messages
>> to prevent this crash.
>
> Well...  why are all these EBUSY's occurring?  It sounds inefficient (at
> least) but if it is expected, normal and unavoidable then perhaps we
> should just remove that message altogether?

We see them on powerpc sometimes when CMA is unable to make large
allocations for the hash table of a KVM guest.

At least in that context they're not useful, CMA will try the
allocation again, and if it really can't allocate then CMA will print
more useful information itself.

So I'd vote for dropping the message and letting the callers decide what
to do.

cheers
