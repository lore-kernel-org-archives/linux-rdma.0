From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RESEND 4/7] mm/gup: Add FOLL_LONGTERM capability to GUP fast
Date: Mon, 25 Mar 2019 14:51:50 -0300
Message-ID: <20190325175150.GA21008@ziepe.ca>
References: <20190317183438.2057-1-ira.weiny@intel.com>
 <20190317183438.2057-5-ira.weiny@intel.com>
 <CAA9_cmcx-Bqo=CFuSj7Xcap3e5uaAot2reL2T74C47Ut6_KtQw@mail.gmail.com>
 <20190325084225.GC16366@iweiny-DESK2.sc.intel.com>
 <20190325164713.GC9949@ziepe.ca>
 <20190325092314.GF16366@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190325092314.GF16366@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, linux-mm <linux-mm@kvack.org>, Linux
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 25, 2019 at 02:23:15AM -0700, Ira Weiny wrote:
> > > Unfortunately holding the lock is required to support FOLL_LONGTERM (to check
> > > the VMAs) but we don't want to hold the lock to be optimal (specifically allow
> > > FAULT_FOLL_ALLOW_RETRY).  So I'm maintaining the optimization for *_fast users
> > > who do not specify FOLL_LONGTERM.
> > > 
> > > Another way to do this would have been to define __gup_longterm_unlocked with
> > > the above logic, but that seemed overkill at this point.
> > 
> > get_user_pages_unlocked() is an exported symbol, shouldn't it work
> > with the FOLL_LONGTERM flag?
> > 
> > I think it should even though we have no user..
> > 
> > Otherwise the GUP API just gets more confusing.
> 
> I agree WRT to the API.  But I think callers of get_user_pages_unlocked() are
> not going to get the behavior they want if they specify FOLL_LONGTERM.

Oh? Isn't the only thing FOLL_LONGTERM does is block the call on DAX?
Why does the locking mode matter to this test?

> What I could do is BUG_ON (or just WARN_ON) if unlocked is called with
> FOLL_LONGTERM similar to the code in get_user_pages_locked() which does not
> allow locked and vmas to be passed together:

The GUP call should fail if you are doing something like this. But I'd
rather not see confusing specialc cases in code without a clear
comment explaining why it has to be there.

Jason
