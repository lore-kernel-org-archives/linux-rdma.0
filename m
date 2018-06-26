From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: set PG_dma_pinned on get_user_pages*()
Date: Tue, 26 Jun 2018 15:47:57 +0200
Message-ID: <20180626134757.GY28965@dhcp22.suse.cz>
References: <20180617012510.20139-3-jhubbard@nvidia.com>
 <CAPcyv4i=eky-QrPcLUEqjsASuRUrFEWqf79hWe0mU8xtz6Jk-w@mail.gmail.com>
 <20180617200432.krw36wrcwidb25cj@ziepe.ca>
 <CAPcyv4gayKk_zHDYAvntware12qMXWjnnL_FDJNUQsJS_zNfDw@mail.gmail.com>
 <311eba48-60f1-b6cc-d001-5cc3ed4d76a9@nvidia.com>
 <20180618081258.GB16991@lst.de>
 <d4817192-6db0-2f3f-7c67-6078b69686d3@nvidia.com>
 <CAPcyv4iacHYxGmyWokFrVsmxvLj7=phqp2i0tv8z6AT-mYuEEA@mail.gmail.com>
 <3898ef6b-2fa0-e852-a9ac-d904b47320d5@nvidia.com>
 <CAPcyv4iRBzmwWn_9zDvqdfVmTZL_Gn7uA_26A1T-kJib=84tvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4iRBzmwWn_9zDvqdfVmTZL_Gn7uA_26A1T-kJib=84tvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <john.hubbard@gmail.com>, Matthew Wilcox <willy@infradead.org>, Christopher Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon 18-06-18 12:21:46, Dan Williams wrote:
[...]
> I do think we should explore a page flag for pages that are "long
> term" pinned. Michal asked for something along these lines at LSF / MM
> so that the core-mm can give up on pages that the kernel has lost
> lifetime control. Michal, did I capture your ask correctly?

I am sorry to be late. I didn't ask for a page flag exactly. I've asked
for a way to query for the pin to be temporal or permanent. How that is
achieved is another question. Maybe we have some more spare room after
recent struct page reorganization but I dunno, to be honest. Maybe we
can have an _count offset for these longterm pins. It is not like we are
using the whole ref count space, right?

Another thing I was asking for is to actually account those longterm
pinned pages and apply some control over those. They are basically mlock
like and so their usage should better not be unbound.
-- 
Michal Hocko
SUSE Labs
