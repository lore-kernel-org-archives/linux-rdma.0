From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] IB/srpt: Introduce two helper functions
Date: Thu, 7 Apr 2016 15:40:36 +0200
Message-ID: <20160407134036.GB17477@lst.de>
References: <57055BC6.7070402@sandisk.com> <57055C10.3060108@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57055C10.3060108@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 06, 2016 at 11:57:20AM -0700, Bart Van Assche wrote:
> Move the functionality for initializing and cleaning up I/O
> contexts into two new functions. This patch does not change any
> functionality.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
