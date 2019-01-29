From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 0/5] RDMA: reg_remote_mr
Date: Tue, 29 Jan 2019 10:44:48 -0600
Message-ID: <8cdb77b6-c160-81d0-62be-5bbf84a98d69@opengridcomputing.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Nider <joeln@il.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 1/29/2019 7:26 AM, Joel Nider wrote:
> As discussed at LPC'18, there is a need to be able to register a memory
> region (MR) on behalf of another process. One example is the case of
> post-copy container migration, in which CRIU is responsible for setting
> up the migration, but the contents of the memory are from the migrating
> process. In this case, we want all RDMA READ requests to be served by
> the address space of the migration process directly (not by CRIU). This
> patchset implements a new uverbs command which allows an application to
> register a memory region in the address space of another process.

Hey Joel,

Dumb question:

Doesn't this open a security hole by allowing any process to register
memory in any other process?

Steve.
