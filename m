From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving longterm-GUP
 usage by RDMA
Date: Tue, 12 Feb 2019 16:55:21 +0000
Message-ID: <01000168e2a26936-eb7cef59-9772-4a76-b7f3-a7fdc864fa72-000000@email.amazonses.com>
References: <20190211102402.GF19029@quack2.suse.cz> <CAPcyv4iHso+PqAm-4NfF0svoK4mELJMSWNp+vsG43UaW1S2eew@mail.gmail.com> <20190211180654.GB24692@ziepe.ca> <20190211181921.GA5526@iweiny-DESK2.sc.intel.com> <20190211182649.GD24692@ziepe.ca>
 <20190211184040.GF12668@bombadil.infradead.org> <CAPcyv4j71WZiXWjMPtDJidAqQiBcHUbcX=+aw11eEQ5C6sA8hQ@mail.gmail.com> <20190211204945.GF24692@ziepe.ca> <CAPcyv4jHjeJxmHMyrbRhg9oeaLK5WbZm-qu1HywjY7bF2DwiDg@mail.gmail.com> <20190211210956.GG24692@ziepe.ca>
 <20190212163433.GD19076@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190212163433.GD19076@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Ira Weiny <ira.weiny@intel.com>, Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 12 Feb 2019, Jan Kara wrote:

> > Isn't that already racy? If the mmap user is fast enough can't it
> > prevent the page from becoming freed in the first place today?
>
> No, it cannot. We block page faulting for the file (via a lock), tear down
> page tables, free pages and blocks. Then we resume faults and return
> SIGBUS (if the page ends up being after the new end of file in case of
> truncate) or do new page fault and fresh block allocation (which can end
> with SIGBUS if the filesystem cannot allocate new block to back the page).

Well that is already pretty inconsistent behavior. Under what conditions
is the SIGBUS occurring without the new fault attempt?

If a new fault is attempted then we have resource constraints that could
have caused a SIGBUS independently of the truncate. So that case is not
really something special to be considered for truncation.

So the only concern left is to figure out under what conditions SIGBUS
occurs with a racing truncate (if at all) if there are sufficient
resources to complete the page fault.
