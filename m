From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Tue, 12 Feb 2019 17:44:52 +0100
Message-ID: <20190212164452.GF19076@quack2.suse.cz>
References: <20190211102402.GF19029@quack2.suse.cz>
 <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com>
 <20190211180654.GB24692@ziepe.ca>
 <20190211181921.GA5526@iweiny-DESK2.sc.intel.com>
 <20190211182649.GD24692@ziepe.ca>
 <20190211184040.GF12668@bombadil.infradead.org>
 <CAPcyv4j71WZiXWjMPtDJidAqQiBcHUbcX=+aw11eEQ5C6sA8hQ@mail.gmail.com>
 <20190211204945.GF24692@ziepe.ca>
 <CAPcyv4jHjeJxmHMyrbRhg9oeaLK5WbZm-qu1HywjY7bF2DwiDg@mail.gmail.com>
 <01000168e2913f2e-56010847-a10b-407e-b4eb-7730164267de-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01000168e2913f2e-56010847-a10b-407e-b4eb-7730164267de-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue 12-02-19 16:36:36, Christopher Lameter wrote:
> On Mon, 11 Feb 2019, Dan Williams wrote:
> 
> > An mmap write after a fault due to a hole punch is free to trigger
> > SIGBUS if the subsequent page allocation fails. So no, I don't see
> > them as the same unless you're allowing for the holder of the MR to
> > receive a re-fault failure.
> 
> Order 0 page allocation failures are generally not possible in that path.
> System will reclaim and OOM before that happens.

But also block allocation can fail in the filesystem or you can have memcgs
set up that make the page allocation fail, can't you? So in principle Dan
is right. Page faults can and do fail...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
