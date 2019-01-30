From: "Joel Nider" <JOELN@il.ibm.com>
Subject: Re: [PATCH 0/5] RDMA: reg_remote_mr
Date: Wed, 30 Jan 2019 10:22:59 +0200
Message-ID: <OF3A13C355.FCBF3024-ONC2258392.002D8AC7-C2258392.002E0D17@notes.na.collabserv.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
 <8cdb77b6-c160-81d0-62be-5bbf84a98d69@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8cdb77b6-c160-81d0-62be-5bbf84a98d69@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-rdma@vger.kernel.org

Steve Wise <swise@opengridcomputing.com> wrote on 01/29/2019 06:44:48 PM:

> 
> On 1/29/2019 7:26 AM, Joel Nider wrote:
> > As discussed at LPC'18, there is a need to be able to register a 
memory
> > region (MR) on behalf of another process. One example is the case of
> > post-copy container migration, in which CRIU is responsible for 
setting
> > up the migration, but the contents of the memory are from the 
migrating
> > process. In this case, we want all RDMA READ requests to be served by
> > the address space of the migration process directly (not by CRIU). 
This
> > patchset implements a new uverbs command which allows an application 
to
> > register a memory region in the address space of another process.
> 
> Hey Joel,
> 
> Dumb question:
> 
> Doesn't this open a security hole by allowing any process to register
> memory in any other process?

Not a dumb question - there is a security problem. Jason just suggested
I look at how ptrace solves the problem, so that's my best option at the
moment. Still, I figured it was a good idea to let everyone take a look
at what I have so far, and start to get feedback.

> Steve.
> 
> 
