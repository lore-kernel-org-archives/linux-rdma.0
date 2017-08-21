From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC] mm,drm/i915: Mark pinned shmemfs pages as unevictable
Date: Mon, 21 Aug 2017 11:29:17 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1708211128190.10613@nuc-kabylake>
References: <20170606120436.8683-1-chris@chris-wilson.co.uk> <20170606121418.GM1189@dhcp22.suse.cz> <150314853540.7354.10275185301153477504@mail.alporthouse.com> <20170821140641.GN25956@dhcp22.suse.cz> <150332781184.13047.15448500819676507290@mail.alporthouse.com>
 <20170821155737.dewjjal3cou52ruw@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170821155737.dewjjal3cou52ruw@hirez.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Michal Hocko <mhocko@suse.com>, intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matthew Auld <matthew.auld@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Aug 2017, Peter Zijlstra wrote:

> > Peter, is that the latest version?
>
> Probably, I ran into the Infiniband code and couldn't convince anybody
> to help me out :/ Its been stale for a few years now I'm afraid.

What help do you need? CCing linux-rdma....


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
