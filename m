From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
Date: Wed, 28 Oct 2015 04:30:10 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CBD4369@CRSMSX101.amr.corp.intel.com>
References: <saurabh.truth@gmail.com>
 <1445960860-3396-1-git-send-email-saurabh.truth@gmail.com>
 <20151027181235.GA27038@phlsvsds.ph.intel.com>
 <20151027181652.GA6879@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB18571E3F@CRSMSX101.amr.corp.intel.com>
 <20151027200012.GA7403@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151027200012.GA7403@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Wan, Kaike" <kaike.wan@intel.com>
Cc: Saurabh Sengar <saurabh.truth@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, Oct 27, 2015 at 06:56:50PM +0000, Wan, Kaike wrote:
> 
> > > I do wonder if it is a good idea to call ib_nl_send_msg with a
> > > spinlock held though.. Would be nice to see that go away.
> >
> > We have to hold the lock to protect against a race condition that a
> > quick response will try to free the request from the
> > ib_nl_request_list before we even put it on the list.
> 
> Put is on the list first? Use a kref? Doesn't look like a big deal to clean this up.
> 
> Jason

Not sure what "Put is on the list first?" means.  I think it is valid to build the request, 
if success, add to the list, then send it.  That would solve the problem you mention 
above.  Was that what you hand in mind, Jason?

I don't have time to work on this right now, not sure about Kaike.  Until we can remove 
the spinlock the current proposed patch should be applied in the interim.  Sorry for the
noise before.

Reviewed-By: Ira Weiny <ira.weiny@intel.com>
