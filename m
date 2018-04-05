From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-next 00/13] IB/hfi1,core: Driver updates for 4.17
Date: Thu, 5 Apr 2018 08:49:21 -0600
Message-ID: <20180405144921.GB29712@ziepe.ca>
References: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
 <20180405030916.GD29229@ziepe.ca>
 <080bb43b-86bc-6943-81a2-93c8808b41a0@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <080bb43b-86bc-6943-81a2-93c8808b41a0@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Mariciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, Brian Welty <brian.welty@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Ashutosh Dixit <ashutosh.dixit@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 04, 2018 at 11:33:02PM -0400, Dennis Dalessandro wrote:
> On 4/4/2018 11:09 PM, Jason Gunthorpe wrote:
> >On Wed, Apr 04, 2018 at 08:01:11PM -0700, Dennis Dalessandro wrote:
> >>Hi Jason and Doug,
> >>
> >>Here are most of our updates for 4.17. I will follow this up with a small
> >>16B series then I still have a few more patches that are waiting on
> >>some more thorough testing. Should be able to get them on the list tomrrow or
> >>Friday at the latest, wanted to get these out now. I don't think anything
> >>is really that scary in here.
> >
> >Probably not going to happen for 4.17.
> >
> >As a general rule series that are not on the list before the merge
> >window opens are not going to be make it. Linus discourages doing
> >things at the last minute as it encourages bad behavior that reduces
> >release quality.
> 
> I think that's a fine policy, and usually try to stick to that myself, but
> got behind this time by a couple days. To be fair though, I wouldn't call
> this last minute.

'last minute' was sending series during the rc6 time period.

After release is 'too late'

Jason
