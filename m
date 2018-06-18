From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] mm: set PG_dma_pinned on get_user_pages*()
Date: Mon, 18 Jun 2018 10:11:13 +0200
Message-ID: <20180618081113.GA16991@lst.de>
References: <20180617012510.20139-1-jhubbard@nvidia.com> <20180617012510.20139-3-jhubbard@nvidia.com> <CAPcyv4i=eky-QrPcLUEqjsASuRUrFEWqf79hWe0mU8xtz6Jk-w@mail.gmail.com> <20180617200432.krw36wrcwidb25cj@ziepe.ca> <CAPcyv4gayKk_zHDYAvntware12qMXWjnnL_FDJNUQsJS_zNfDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gayKk_zHDYAvntware12qMXWjnnL_FDJNUQsJS_zNfDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 01:10:04PM -0700, Dan Williams wrote:
> I believe kernel behavior regression is a primary concern as now
> fallocate() and truncate() can randomly fail where they didn't before.

Fail or block forever due to actions of other unprivileged users.

That is a complete no-go.
