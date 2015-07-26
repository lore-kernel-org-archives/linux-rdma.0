From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive
 names
Date: Sun, 26 Jul 2015 19:44:50 +0300
Message-ID: <55B50E82.1030001@dev.mellanox.co.il>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161848.25617.26092.stgit@build2.ogc.int>
 <55B4B190.7070305@dev.mellanox.co.il> <20150726104328.GB18944@infradead.org>
 <55B4BDE3.8040801@dev.mellanox.co.il> <20150726155304.GA32464@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150726155304.GA32464@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com, infinipath@intel.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bfields@fieldses.org
List-Id: linux-rdma@vger.kernel.org

On 7/26/2015 6:53 PM, Christoph Hellwig wrote:
> On Sun, Jul 26, 2015 at 02:00:51PM +0300, Sagi Grimberg wrote:
>> On the wire iser sends a single rkey, but the target is allowed to
>> transfer the data however it wants to.
>
> So you're trying to get above the limit of a single RDMA READ, not
> above the limit for memory registration in the initiator?

Correct.

>  In that case your explanation makes sense, that's just not what I expected
> to be the limiting factor.
>

In the initiator case, there is no way to support transfer size that
exceeds the device registration length capabilities (unless we start
using higher-order atomic allocations which we won't).
