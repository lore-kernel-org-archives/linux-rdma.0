From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] drivers/IB,qib: do not use mmap_sem
Date: Thu, 31 Jan 2019 11:04:00 +0100
Message-ID: <20190131100400.GC19222@quack2.suse.cz>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-4-dave@stgolabs.net>
 <20190128233140.GA12530@ziepe.ca>
 <20190129044607.GL25106@ziepe.ca>
 <20190129185005.GC10129@iweiny-DESK2.sc.intel.com>
 <20190129231903.GA5352@ziepe.ca>
 <2807E5FD2F6FDA4886F6618EAC48510E79BA6A27@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E79BA6A27@CRSMSX101.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: 'Jason Gunthorpe' <jgg@ziepe.ca>, Davidlohr Bueso <dave@stgolabs.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "dledford@redhat.com" <dledford@redhat.com>, "jack@suse.de" <jack@suse.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Wed 30-01-19 18:01:33, Weiny, Ira wrote:
> > 
> > On Tue, Jan 29, 2019 at 10:50:05AM -0800, Ira Weiny wrote:
> > > > .. and I'm looking at some of the other conversions here.. *most
> > > > likely* any caller that is manipulating rlimit for get_user_pages
> > > > should really be calling get_user_pages_longterm, so they should not
> > > > be converted to use _fast?
> > >
> > > Is this a question?  I'm not sure I understand the meaning here?
> > 
> > More an invitation to disprove the statement
> 
> Generally I agree.  But would be best if we could get fast GUP for
> performance.  I have not worked out if that will be possible with the
> final "longterm" solutions.

Initially probably not, longer-term it might be added if there are
performance data supporting that (i.e., showing real workload that would
benefit). In principle there's nothing that would prevent gup_fast like
functionality for long-term pins but I expect there will be always
additional overhead (compared to plain gup_fast()) of establishing
something like leases to identify long-term pins. But we haven't figured
out the details yet. For now we concentrate on fixing short-term pins and
issues with those.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
