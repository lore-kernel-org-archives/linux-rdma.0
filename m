From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH 3/6] drivers/IB,qib: do not use mmap_sem
Date: Wed, 30 Jan 2019 18:01:33 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E79BA6A27@CRSMSX101.amr.corp.intel.com>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-4-dave@stgolabs.net> <20190128233140.GA12530@ziepe.ca>
 <20190129044607.GL25106@ziepe.ca>
 <20190129185005.GC10129@iweiny-DESK2.sc.intel.com>
 <20190129231903.GA5352@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190129231903.GA5352@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Jason Gunthorpe' <jgg@ziepe.ca>
Cc: Davidlohr Bueso <dave@stgolabs.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "dledford@redhat.com" <dledford@redhat.com>, "jack@suse.de" <jack@suse.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, Jan 29, 2019 at 10:50:05AM -0800, Ira Weiny wrote:
> > > .. and I'm looking at some of the other conversions here.. *most
> > > likely* any caller that is manipulating rlimit for get_user_pages
> > > should really be calling get_user_pages_longterm, so they should not
> > > be converted to use _fast?
> >
> > Is this a question?  I'm not sure I understand the meaning here?
> 
> More an invitation to disprove the statement

Generally I agree.  But would be best if we could get fast GUP for performance.  I have not worked out if that will be possible with the final "longterm" solutions.

IRa

> 
> Jason
