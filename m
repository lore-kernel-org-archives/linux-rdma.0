From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 10:35:04 -0800
Message-ID: <20190206183503.GO21860@bombadil.infradead.org>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 01:32:04PM -0500, Doug Ledford wrote:
> On Wed, 2019-02-06 at 09:52 -0800, Matthew Wilcox wrote:
> > On Wed, Feb 06, 2019 at 10:31:14AM -0700, Jason Gunthorpe wrote:
> > > On Wed, Feb 06, 2019 at 10:50:00AM +0100, Jan Kara wrote:
> > > 
> > > > MM/FS asks for lease to be revoked. The revoke handler agrees with the
> > > > other side on cancelling RDMA or whatever and drops the page pins. 
> > > 
> > > This takes a trip through userspace since the communication protocol
> > > is entirely managed in userspace.
> > > 
> > > Most existing communication protocols don't have a 'cancel operation'.
> > > 
> > > > Now I understand there can be HW / communication failures etc. in
> > > > which case the driver could either block waiting or make sure future
> > > > IO will fail and drop the pins. 
> > > 
> > > We can always rip things away from the userspace.. However..
> > > 
> > > > But under normal conditions there should be a way to revoke the
> > > > access. And if the HW/driver cannot support this, then don't let it
> > > > anywhere near DAX filesystem.
> > > 
> > > I think the general observation is that people who want to do DAX &
> > > RDMA want it to actually work, without data corruption, random process
> > > kills or random communication failures.
> > > 
> > > Really, few users would actually want to run in a system where revoke
> > > can be triggered.
> > > 
> > > So.. how can the FS/MM side provide a guarantee to the user that
> > > revoke won't happen under a certain system design?
> > 
> > Most of the cases we want revoke for are things like truncate().
> > Shouldn't happen with a sane system, but we're trying to avoid users
> > doing awful things like being able to DMA to pages that are now part of
> > a different file.
> 
> Why is the solution revoke then?  Is there something besides truncate
> that we have to worry about?  I ask because EBUSY is not currently
> listed as a return value of truncate, so extending the API to include
> EBUSY to mean "this file has pinned pages that can not be freed" is not
> (or should not be) totally out of the question.
> 
> Admittedly, I'm coming in late to this conversation, but did I miss the
> portion where that alternative was ruled out?

That's my preferred option too, but the preponderance of opinion leans
towards "We can't give people a way to make files un-truncatable".
