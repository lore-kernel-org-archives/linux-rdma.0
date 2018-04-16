From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Mon, 16 Apr 2018 04:02:12 +0000
Message-ID: <CAHH2K0ZKqDt2OS1RN7i6qqc=VyPfhzC5sfSSb4ktDdtZnzAhCA@mail.gmail.com>
References: <20180413070644.11974-1-gthelen@google.com> <20180415120636.GA10759@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180415120636.GA10759@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 15, 2018 at 5:06 AM Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Apr 13, 2018 at 12:06:44AM -0700, Greg Thelen wrote:
> > Allow INFINIBAND without INFINIBAND_ADDR_TRANS.

> Why?  We are pushing everyone heavily to use RDMA/CM, so making it
> optional seems rather counter-intuitive.

Bugs.  We don't currently use CM.  But fuzzy testing has been finding a
fair number CM bugs, so we were thinking of disabling it until we need it.

> You'll also have to fix tons of ULPs to explicitly depend on
> INFINIBAND_ADDR_TRANS, or make code conditional on it.

I think I've identified the set of options which use
INFINIBAND_ADDR_TRANS without a kconfig depends:
* CIFS_SMB_DIRECT
* INFINIBAND_SRPT
* NVME_RDMA
* NVME_TARGET_RDMA

I have patches for the above, but need to finish the commit logs.  Let me
know if they'll be nacked and I'll just patch my kernel and forget
upstreaming.
