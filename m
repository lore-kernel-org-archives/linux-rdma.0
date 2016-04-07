From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] IB/srpt: Convert to percpu_ida tag allocation
Date: Thu, 07 Apr 2016 16:31:03 -0700
Message-ID: <1460071863.18732.62.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com> <57055C25.4060304@sandisk.com>
	 <20160407230345.GA10282@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160407230345.GA10282@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-04-08 at 01:03 +0200, Christoph Hellwig wrote:
> On Wed, Apr 06, 2016 at 11:57:41AM -0700, Bart Van Assche wrote:
> > Just like other target drivers, use percpu_ida_alloc() and
> > percpu_ida_free() for I/O context management.
> 
> Can you please resend this patch straight on top of current Linus'
> tree?  I think the two cleanup patches are worthwhile to resubmit
> later, but let's get the issues with the broken conversion sorted
> out first with the smallest possible attack vector from Nic.
> 

Like I said, I'll be resolving this myself in target-pending for the
next v4.6-rc fixes PULL.
