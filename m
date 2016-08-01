From: Jon Derrick <jonathan.derrick@intel.com>
Subject: Re: [RFC 6/7] NVMe: Use genalloc to allocate CMB regions
Date: Mon, 1 Aug 2016 10:20:58 -0600
Message-ID: <20160801162057.GA11476@localhost.localdomain>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
 <1470034653-9097-7-git-send-email-haggaie@mellanox.com>
 <20160801155348.GB23224@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160801155348.GB23224@infradead.org>
Sender: linux-pci-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Haggai Eran <haggaie@mellanox.com>, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, Liran Liss <liranl@mellanox.com>, linux-pci@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>, Stephen Bates <stephen.bates@microsemi.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 01, 2016 at 08:53:49AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 01, 2016 at 09:57:32AM +0300, Haggai Eran wrote:
> > Register the CMB in a gen_pool dedicated to manage CMB regions. Use the
> > pool to allocate the SQs to make sure they are registered.
> 
> And why would the NVMe driver care if "they are registered"?
> 
> Once we start allowing diverse CMB uses (what happened to Jon's patches
> btw?) genalloc might be a good backend allocator, but without that
> it's entirely pointless.  Also please don't introduce useless header
> files.
My concern is using CMB as a generic memory space could lead to invalid uses and untested paths in broken firmware (leading to bricked drives...). The spec defines what it's allowed to be used for, but doesn't really leave it open for general purpose usage outside of that. Because of that I think it needs more hand-holding by the kernel to prevent invalid usage.

What I would like to see is a set of knobs controlling the 'chunks' of memory's usages (controlled through sysfs/configfs?) and the kernel takes care of allocation. My set was going to expose a resource file for WDS/RDS but everything else was unhandled except for its current sqes usage. I think the genalloc could fit into this scheme quite well.

Thoughts?
