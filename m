From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 12:49:54 -0800
Message-ID: <20190206204954.GS21860@bombadil.infradead.org>
References: <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206194055.GP21860@bombadil.infradead.org>
 <a9df9be75966f34f55f843a3cd7e1ee7d497c7fa.camel@redhat.com>
 <20190206202021.GQ21860@bombadil.infradead.org>
 <a8dc27e81182060b3480127332c77ac624abcb22.camel@redhat.com>
 <20190206204128.GR21860@bombadil.infradead.org>
 <fbdeccb01f7d0ba2f6ebb69660b7aa3d99690042.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fbdeccb01f7d0ba2f6ebb69660b7aa3d99690042.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 03:47:53PM -0500, Doug Ledford wrote:
> On Wed, 2019-02-06 at 12:41 -0800, Matthew Wilcox wrote:
> > On Wed, Feb 06, 2019 at 03:28:35PM -0500, Doug Ledford wrote:
> > > On Wed, 2019-02-06 at 12:20 -0800, Matthew Wilcox wrote:
> > > > Not hot-unplugging the RDMA device but hot-unplugging an NV-DIMM.

^^^ I think you missed this line ^^^

> You said "now that I think about it, there was a desire to support hot-
> unplug which also needed revoke".  For us, hot unplug is done at the
> device level and means all connections must be torn down.  So in the
> context of this argument, if people want revoke so DAX can migrate from
> one NV-DIMM to another, ok.  But revoke does not help RDMA migrate.
> 
> If, instead, you mean that you want to support hot unplug of an NV-DIMM
> that is currently the target of RDMA transfers, then I believe
> Christoph's answer on this is correct.  It all boils down to which
> device you are talking about doing the hot unplug on.
