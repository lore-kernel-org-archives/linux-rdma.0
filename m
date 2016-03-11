From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 9/9] IB/srpt: convert to the generic RDMA READ/WRITE
	API
Date: Fri, 11 Mar 2016 10:09:22 +0100
Message-ID: <20160311090922.GB28498@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-10-git-send-email-hch@lst.de> <20160308201342.GL13396@leon.nu> <20160309125941.GC31210@lst.de> <56E1F067.7020807@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E1F067.7020807@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, dledford@redhat.com, sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 10, 2016 at 02:08:39PM -0800, Bart Van Assche wrote:
> Since it is safe to pass NULL to kfree() I think a similar comment applies 
> to srpt_free_rw_ctxs() and that also from that function "ioctx->rw_ctxs && 
> " can be left out.

Ok, I'll update it.
