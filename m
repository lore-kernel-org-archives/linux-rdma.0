From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] IB/hfi1: Fix hard lockup due to not using save/restore
 spin lock
Date: Wed, 1 Jun 2016 09:14:59 -0700
Message-ID: <20160601161459.GB9144@kroah.com>
References: <20160601143812.26872.85826.stgit@phlsvslse11.ph.intel.com>
 <20160601154440.GH7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601154440.GH7477@leon.nu>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 01, 2016 at 06:44:40PM +0300, Leon Romanovsky wrote:
> On Wed, Jun 01, 2016 at 10:38:12AM -0400, Mike Marciniszyn wrote:
> > Upstream commit 7049de65c9e5 into 4.6.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Is it part of the commit message?

It's enough for me to know what to do here :)

thanks,

greg k-h
