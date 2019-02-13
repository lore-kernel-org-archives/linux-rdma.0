From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 13 Feb 2019 16:06:32 +0100
Message-ID: <20190213150632.GB26828@quack2.suse.cz>
References: <20190211180654.GB24692@ziepe.ca>
 <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
 <20190211182649.GD24692@ziepe.ca>
 <20190211184040.GF12668@bombadil.infradead.org>
 <CAPcyv4j71WZiXWjMPtDJidAqQiBcHUbcX=+aw11eEQ5C6sA8hQ@mail.gmail.com>
 <20190211204945.GF24692@ziepe.ca>
 <CAPcyv4jHjeJxmHMyrbRhg9oeaLK5WbZm-qu1HywjY7bF2DwiDg@mail.gmail.com>
 <20190211210956.GG24692@ziepe.ca>
 <20190212163433.GD19076@quack2.suse.cz>
 <01000168e2a26936-eb7cef59-9772-4a76-b7f3-a7fdc864fa72-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168e2a26936-eb7cef59-9772-4a76-b7f3-a7fdc864fa72-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Ira Weiny <ira.weiny@intel.com>, Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue 12-02-19 16:55:21, Christopher Lameter wrote:
> On Tue, 12 Feb 2019, Jan Kara wrote:
> 
> > > Isn't that already racy? If the mmap user is fast enough can't it
> > > prevent the page from becoming freed in the first place today?
> >
> > No, it cannot. We block page faulting for the file (via a lock), tear down
> > page tables, free pages and blocks. Then we resume faults and return
> > SIGBUS (if the page ends up being after the new end of file in case of
> > truncate) or do new page fault and fresh block allocation (which can end
> > with SIGBUS if the filesystem cannot allocate new block to back the page).
> 
> Well that is already pretty inconsistent behavior. Under what conditions
> is the SIGBUS occurring without the new fault attempt?

I probably didn't express myself clearly enough. I didn't say that SIGBUS
can occur without a page fault. The evaluation of whether a page would be
beyond EOF, page allocation, and block allocation happen only in response
to a page fault...

> If a new fault is attempted then we have resource constraints that could
> have caused a SIGBUS independently of the truncate. So that case is not
> really something special to be considered for truncation.

Agreed. I was just reacting to Jason's question whether an application
cannot prevent page freeing by being aggressive enough.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
