From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] IB/srpt and the percpu_ida conversion
Date: Thu, 07 Apr 2016 15:29:41 -0700
Message-ID: <1460068181.18732.23.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57055BC6.7070402@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-04-06 at 11:56 -0700, Bart Van Assche wrote:
> Hi Doug,
> 
> This patch series addresses the recently reported issue with regard to 
> the percpu_ida conversion of the ib_srpt driver. My proposal is to 
> submit patch 1/4 for inclusion in kernel v4.6 and to submit patches 2..4 
> for inclusion in kernel v4.7. The actual patches in this series are:
> 
> 0001-IB-srpt-Revert-Convert-to-percpu_ida-tag-allocation.patch
> 0002-IB-srpt-Report-login-failures-only-once.patch
> 0003-IB-srpt-Introduce-two-helper-functions.patch
> 0004-IB-srpt-Convert-to-percpu_ida-tag-allocation.patch
> 

I asked to not revert the percpu_ida conversion and again you simply
ignored subsystem maintainer feedback, and included a different
percpu_ida conversion without using alloc_session callback that still
does pre-allocation of buffers before session login even completes.

The whole point of the alloc_session callback is so that extra
pre-allocation doesn't happen until after se_node_acl lookup has
finished, and is what ib_srpt needs to be using given SRP's completely
existent spec level security model.

In any event, I'm fixing the regression ahead of the next v4.6-rc PULL
in:

http://www.spinics.net/lists/target-devel/msg12535.html

Any issues you find with this patch should be sent out as an incremental
patch, and not rolling your own concoction.
