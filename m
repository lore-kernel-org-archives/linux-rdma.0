From: Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Mon, 13 Jul 2015 15:36:44 -0400
Message-ID: <55A4134C.2040301@talpey.com>
References: <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com> <20150707161751.GA623@obsidianresearch.com> <559BFE03.4020709@dev.mellanox.co.il> <20150707213628.GA5661@obsidianresearch.com> <559CD174.4040901@dev.mellanox.co.il> <20150708190842.GB11740@obsidianresearch.com> <559D983D.6000804@talpey.com> <20150708233604.GA20765@obsidianresearch.com> <559E54AB.2010905@dev.mellanox.co.il> <20150709170142.GA21921@obsidianresearch.com> <20150711102538.GB14741@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150711102538.GB14741@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, bfields@fieldses.org, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 7/11/2015 6:25 AM, 'Christoph Hellwig' wrote:
> I think what we need to support for now is FRMR as the primary target,
> and FMR as a secondar[y].

FMR is a *very* bad choice, for several reasons.

1) It's not supported by very many devices, in fact it might even
be thought to be obsolete.

2) It does not protect on byte boundaries, therefore it is unsafe
to use for anything but page-sized, page-aligned RDMA operations.

3) It is a synchronous API, i.e. it is not work-request based and
therefore is not very high performance.

4) It sometimes is used with a "pool", which defers deregistration
in the hopes of amortizing overhead. However, this deferral further
increases the risk of remote access, including altering of memory
contents after the fact.

Personally, I'd recommend ib_get_phys_mr() over FMR. It at least
doesn't suffer from issues 1, 2 and 4.
