From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 10 Mar 2016 08:57:22 +0100
Message-ID: <20160310075722.GA551@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com> <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de> <56E071B6.8060809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E071B6.8060809@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2016 at 10:55:50AM -0800, Bart Van Assche wrote:
> Regarding the iSERt patches that are present in your rdma-rw-api branch: 

I haven't submitted those yet, as the signature MR support hasn't been
tested and is most likely broken.  (and even if it's not broken it's too
ugly to live :))

> what is the impact of these patches on memory registration for the iSERt 
> driver in combination with an IB HCA? Is memory registration still enabled 
> for this combination? If not: how about changing this patch series such 
> that memory registration is performed either if the transport protocol is 
> iWARP or the ULP driver requests memory registration explicitly, e.g. by 
> setting a flag in struct rdma_rw_ctx and/or struct ib_qp_init_attr?

I don't want the ULP to ask for memory registrations, and it's not really
the ULPs business.  It should be done either if needed (iWarp, signature
MRs), or if the HCA driver prefers it for a larger enough transfers.

Once the basic API is in I'd like to add an interface for the HCA driver,
as Mellannox has indicated they'd like to register for larger transfers.

Anby chance to get a review of the remaining patches so we can get it
in for this merge window?
