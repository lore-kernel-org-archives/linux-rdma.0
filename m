From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] IB/hfi1: Fix hard lockup due to not using save/restore
 spin lock
Date: Wed, 1 Jun 2016 16:50:02 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25B27C1F@fmsmsx120.amr.corp.intel.com>
References: <20160601143812.26872.85826.stgit@phlsvslse11.ph.intel.com>
 <20160601154440.GH7477@leon.nu> <20160601161459.GB9144@kroah.com>
 <20160601164732.GI7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160601164732.GI7477@leon.nu>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "leon@kernel.org" <leon@kernel.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Jun 01, 2016 at 09:14:59AM -0700, Greg KH wrote:
> > On Wed, Jun 01, 2016 at 06:44:40PM +0300, Leon Romanovsky wrote:
> > > On Wed, Jun 01, 2016 at 10:38:12AM -0400, Mike Marciniszyn wrote:
> > > > Upstream commit 7049de65c9e5 into 4.6.
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > Is it part of the commit message?
> >
> > It's enough for me to know what to do here :)
> 
> Good to know, I always used CC: stable notation.
> 

The patch didn't port cleanly because of the staging -> drivers/infiniband move.

Hence the option 3 choice for submission.

Mike
