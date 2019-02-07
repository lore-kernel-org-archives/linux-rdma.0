From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 08:54:08 -0800
Message-ID: <20190207165407.GA29531@iweiny-DESK2.sc.intel.com>
References: <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <20190207035258.GD6173@dastard>
 <20190207052310.GA22726@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190207052310.GA22726@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 10:23:10PM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 07, 2019 at 02:52:58PM +1100, Dave Chinner wrote:
> 
> > Requiring ODP capable hardware and applications that control RDMA
> > access to use file leases and be able to cancel/recall client side
> > delegations (like NFS is already able to do!) seems like a pretty
> 
> So, what happens on NFS if the revoke takes too long?

This is the fundamental issue with RDMA revoke.  With RDMA and some hardware
you are going to end up killing processes.  If the decision is that only
processes on non-ODP hardware get killed and the user basically "should not
have done that" then I'm ok with that.  However, then we really need to
prevented them from registering the memory in the first place.  Which means we
leave in the "longterm" GUP registration and fail those registrations can't be
supported.

Ira
