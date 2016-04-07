From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] IB/srpt: Convert to percpu_ida tag allocation
Date: Fri, 8 Apr 2016 01:03:45 +0200
Message-ID: <20160407230345.GA10282@lst.de>
References: <57055BC6.7070402@sandisk.com> <57055C25.4060304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57055C25.4060304@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 06, 2016 at 11:57:41AM -0700, Bart Van Assche wrote:
> Just like other target drivers, use percpu_ida_alloc() and
> percpu_ida_free() for I/O context management.

Can you please resend this patch straight on top of current Linus'
tree?  I think the two cleanup patches are worthwhile to resubmit
later, but let's get the issues with the broken conversion sorted
out first with the smallest possible attack vector from Nic.

I need this sorted out before sending the RDMA R/W API, so I'd really
appreciate if this was sorted out quickly.
