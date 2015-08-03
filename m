From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Mon, 3 Aug 2015 08:24:20 -0700
Message-ID: <20150803152420.GA24193@infradead.org>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55BBF4B8.2050700@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 31, 2015 at 03:20:40PM -0700, Bart Van Assche wrote:
> On 07/30/2015 04:22 PM, Jason Gunthorpe wrote:
> >All patches are compile tested. I've done basic testing up to and including
> >the IPoIB patch, the rest required specialized setups I don't have access to,
> >but are fairly straightforward.
> 
> Hello Jason,
> 
> SRP login fails with this patch series applied on top of Linux kernel
> v4.2-rc4. At the target side the following message appears every time the
> SRP initiator tries to log in: "ib_srpt: RDMA t 5 for idx 0 failed with
> status 10" (10=remote access error). That causes the initiator to receive a
> flush error (5).

Could this be caused because srp_map_sg_entry falls back to the phys
mapping for unaligned large requests in line 1389 in Dougs tree:

	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
	    dma_len > dev->mr_max_size) {
		ret = srp_finish_mapping(state, ch);
		if (ret)
			return ret;

		srp_map_desc(state, dma_addr, dma_len, target->rkey);
		srp_map_update_start(state, NULL, 0, 0);
		return 0;
	}

Bart, do you know what hardware this workaround is for?

Also the SRP driver still falls back to phys registrations if the
better MR methods fail, something that will stop working with
Jasons patch.  It's something that looks a little questionable
and which other ULDs don't do either, so it would be good time
to review this practice.

Additionally the SRP_DATA_DESC_INDIRECT case always uses the global
rkey, so whenever we hits this things are going to break.

Jason, I suspect it might be a good idea to rename the rkey field
to something like global_rkey, and make sure it's guarded by a proper
conditional shared by all users.
