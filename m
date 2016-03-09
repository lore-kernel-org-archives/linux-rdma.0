From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 5/9] IB/core: add a simple MR pool
Date: Wed, 9 Mar 2016 13:56:20 +0100
Message-ID: <20160309125620.GB31210@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-6-git-send-email-hch@lst.de> <56DF29EB.7040703@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56DF29EB.7040703@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 11:37:15AM -0800, Bart Van Assche wrote:
> Hmm ... why has 'mr' been initialized to NULL in this function? I think 
> that initialization can be left out. Anyway:

There is no need for it in the current version, and I'll remove it.
