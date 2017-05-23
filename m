From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] IB/hfi1: Protect the global dev_cntr_names and
 port_cntr_names
Date: Tue, 23 May 2017 22:06:07 +0200
Message-ID: <20170523200607.GA4896@kroah.com>
References: <20170523194407.28059.59929.stgit@phlsvslse11.ph.intel.com>
 <20170523195533.GA17694@kroah.com>
 <32E1700B9017364D9B60AED9960492BC342FD4B2@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC342FD4B2@fmsmsx120.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 23, 2017 at 07:59:21PM +0000, Marciniszyn, Mike wrote:
> > > Cc: stable <stable@vger.kernel.org> # v4.10
> > 
> > Why resend this???
> 
> There are two patches, one for 4.10 and one for 4.11.
> 
> Each of the v2's should have had a different version on the stable cc line in the signoff block.

But I already emailed you saying, 4.10 is end-of-life, no one is doing
anything with it, so why resend it?

greg k-h
