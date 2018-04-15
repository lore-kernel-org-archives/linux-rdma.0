From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Sun, 15 Apr 2018 05:06:36 -0700
Message-ID: <20180415120636.GA10759@infradead.org>
References: <20180413070644.11974-1-gthelen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180413070644.11974-1-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Thelen <gthelen@google.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 13, 2018 at 12:06:44AM -0700, Greg Thelen wrote:
> Allow INFINIBAND without INFINIBAND_ADDR_TRANS.

Why?  We are pushing everyone heavily to use RDMA/CM, so making it
optional seems rather counter-intuitive.

You'll also have to fix tons of ULPs to explicitly depend on
INFINIBAND_ADDR_TRANS, or make code conditional on it.
