From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 0/5] RDMA: reg_remote_mr
Date: Tue, 29 Jan 2019 10:34:03 -0800
Message-ID: <20190129183402.GB10129@iweiny-DESK2.sc.intel.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
 <8cdb77b6-c160-81d0-62be-5bbf84a98d69@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8cdb77b6-c160-81d0-62be-5bbf84a98d69@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Joel Nider <joeln@il.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 29, 2019 at 10:44:48AM -0600, Steve Wise wrote:
> 
> On 1/29/2019 7:26 AM, Joel Nider wrote:
> > As discussed at LPC'18, there is a need to be able to register a memory
> > region (MR) on behalf of another process. One example is the case of
> > post-copy container migration, in which CRIU is responsible for setting
> > up the migration, but the contents of the memory are from the migrating
> > process. In this case, we want all RDMA READ requests to be served by
> > the address space of the migration process directly (not by CRIU). This
> > patchset implements a new uverbs command which allows an application to
> > register a memory region in the address space of another process.
> 
> Hey Joel,
> 
> Dumb question:
> 
> Doesn't this open a security hole by allowing any process to register
> memory in any other process?

I agree, Changing all MR to use FOLL_REMOTE seems wrong.

Ira

> 
> Steve.
> 
> 
