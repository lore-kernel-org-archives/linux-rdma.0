From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4] IB/srpt and the percpu_ida conversion
Date: Fri, 8 Apr 2016 01:01:10 +0200
Message-ID: <20160407230110.GA9842@lst.de>
References: <57055BC6.7070402@sandisk.com> <1460068181.18732.23.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460068181.18732.23.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 07, 2016 at 03:29:41PM -0700, Nicholas A. Bellinger wrote:
> I asked to not revert the percpu_ida conversion and again you simply
> ignored subsystem maintainer feedback, and included a different
> percpu_ida conversion without using alloc_session callback that still
> does pre-allocation of buffers before session login even completes.

He doesn't revert it after the patch series, but reverts it first
to then do it properly.  If you don't like that it's fine to ask
Bart to resend with a different patch ordering, but it would be really
helpful to do it politely.

> The whole point of the alloc_session callback is so that extra
> pre-allocation doesn't happen until after se_node_acl lookup has
> finished, and is what ib_srpt needs to be using given SRP's completely
> existent spec level security model.

Your original patch didn't use the alloc_session callback either,
so I don't really see the fuzz here.  I don't see how it makes things
clearer, but if you ask politely, and provide a detailed and valid
explanation I'm pretty sure Bart will adopt the series to your taste.

> 
> In any event, I'm fixing the regression ahead of the next v4.6-rc PULL
> in:
> 
> http://www.spinics.net/lists/target-devel/msg12535.html
> 
> Any issues you find with this patch should be sent out as an incremental
> patch, and not rolling your own concoction.

That patch doesn't work.  While it's great to have a maintainer that
sets overall architectural direction it also really helps to work nicely
with contributors that have detailed experience with the transport (or in
this case even wrote the original driver).

I think a lot of these disagreements could be sorted out much better if
you work with Bart at a technical level rather than having a personal
vandetta.
