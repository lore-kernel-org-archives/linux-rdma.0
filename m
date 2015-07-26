From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive
 names
Date: Sun, 26 Jul 2015 08:53:04 -0700
Message-ID: <20150726155304.GA32464@infradead.org>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161848.25617.26092.stgit@build2.ogc.int>
 <55B4B190.7070305@dev.mellanox.co.il>
 <20150726104328.GB18944@infradead.org>
 <55B4BDE3.8040801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B4BDE3.8040801@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@infradead.org>, Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com, infinipath@intel.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bfields@fieldses.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 26, 2015 at 02:00:51PM +0300, Sagi Grimberg wrote:
> On the wire iser sends a single rkey, but the target is allowed to
> transfer the data however it wants to.

So you're trying to get above the limit of a single RDMA READ, not
above the limit for memory registration in the initiator?  In that
case your explanation makes sense, that's just not what I expected
to be the limiting factor.
