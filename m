From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 10:50:00 +0100
Message-ID: <20190206095000.GA12006@quack2.suse.cz>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue 05-02-19 09:50:59, Ira Weiny wrote:
> The problem: Once we have pages marked as GUP-pinned how should various
> subsystems work with those markings.
> 
> The current work for John Hubbards proposed solutions (part 1 and 2) is
> progressing.[1]  But the final part (3) of his solution is also going to take
> some work.
> 
> In Johns presentation he lists 3 alternatives for gup-pinned pages:
> 
> 1) Hold off try_to_unmap
> 2) Allow writeback while pinned (via bounce buffers)
> 	[Note this will not work for DAX]

Well, but DAX does not need it because by definition there's nothing to
writeback :)

> 3) Use a "revocable reservation" (or lease) on those pages
> 4) Pin the blocks as busy in the FS allocator
> 
> The problem with lease's on pages used by RDMA is that the references to
> these pages is not local to the machine.  Once the user has been given
> access to the page they, through the use of a remote tokens, give a
> reference to that page to remote nodes.  This is the core essence of
> RDMA, and like it or not, something which is increasingly used by major
> Linux users.
> 
> Therefore we need to discuss the extent by which leases are appropriate and
> what happens should a lease be revoked which a user does not respond to.

I don't know the RDMA hardware so this is just an opinion of filesystem /
mm guy but my idea how this should work would be:

MM/FS asks for lease to be revoked. The revoke handler agrees with the
other side on cancelling RDMA or whatever and drops the page pins. Now I
understand there can be HW / communication failures etc. in which case the
driver could either block waiting or make sure future IO will fail and drop
the pins. But under normal conditions there should be a way to revoke the
access. And if the HW/driver cannot support this, then don't let it anywhere
near DAX filesystem.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
