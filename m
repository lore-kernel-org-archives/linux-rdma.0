From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 12:41:28 -0800
Message-ID: <20190206204128.GR21860@bombadil.infradead.org>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206194055.GP21860@bombadil.infradead.org>
 <a9df9be75966f34f55f843a3cd7e1ee7d497c7fa.camel@redhat.com>
 <20190206202021.GQ21860@bombadil.infradead.org>
 <a8dc27e81182060b3480127332c77ac624abcb22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a8dc27e81182060b3480127332c77ac624abcb22.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 03:28:35PM -0500, Doug Ledford wrote:
> On Wed, 2019-02-06 at 12:20 -0800, Matthew Wilcox wrote:
> > On Wed, Feb 06, 2019 at 03:16:02PM -0500, Doug Ledford wrote:
> > > On Wed, 2019-02-06 at 11:40 -0800, Matthew Wilcox wrote:
> > > > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> > > > > though? If we only allow this use case then we may not have to worry about
> > > > > long term GUP because DAX mapped files will stay in the physical location
> > > > > regardless.
> > > > 
> > > > ... except for truncate.  And now that I think about it, there was a
> > > > desire to support hot-unplug which also needed revoke.
> > > 
> > > We already support hot unplug of RDMA devices.  But it is extreme.  How
> > > does hot unplug deal with a program running from the device (something
> > > that would have returned ETXTBSY)?
> > 
> > Not hot-unplugging the RDMA device but hot-unplugging an NV-DIMM.
> > 
> > It's straightforward to migrate text pages from one DIMM to another;
> > you remove the PTEs from the CPU's page tables, copy the data over and
> > pagefaults put the new PTEs in place.  We don't have a way to do similar
> > things to an RDMA device, do we?
> 
> We don't have a means of migration except in the narrowly scoped sense
> of queue pair migration as defined by the IBTA and implemented on some
> dual port IB cards.  This narrowly scoped migration even still involves
> notification of the app.
> 
> Since there's no guarantee that any other port can connect to the same
> machine as any port that's going away, it would always be a
> disconnect/reconnect sequence in the app to support this, not an under
> the covers migration.

I don't understand you.  We're not talking about migrating from one IB
card to another, we're talking about changing the addresses that an STag
refers to.
