From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] infiniband:Fix error checking in the function
 ocrdma_dereg_mr
Date: Fri, 4 Sep 2015 11:01:03 -0600
Message-ID: <20150904170103.GB8026@obsidianresearch.com>
References: <1441384543-32447-1-git-send-email-xerofoify@gmail.com>
 <55E9CAB2.3060106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E9CAB2.3060106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, selvin.xavier@avagotech.com, devesh.sharma@avagotech.com, mitesh.ahuja@avagotech.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 04, 2015 at 12:45:38PM -0400, Doug Ledford wrote:
> On 09/04/2015 12:35 PM, Nicholas Krause wrote:
> > This fixes error checking in the function ocrdma_dereg_mr to properly
> > check if the call to ocrdma_mbx_alloc fails as if so we must exit this
> > function immediately and return the error code to the caller of the
> > function ocrdma_dereg_mr to signal a non recoverable error has occurred
> > when calling this function that needs to be handled by the caller in its
> > own intended error paths.
> 
> This is probably not the right solution here.

Indeed, it is my long term goal to remove error reporting from
'dealloc' style driver functions.

Only Emulex's driver reports errors here, and *nothing* pays attention
to them, or has any recovery strategy.

The best iterm option is to WARN_ON here:

> > -	(void) ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);
> > +	ret =  ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);

And Emulex should work to fix their driver so dealloc failures are
either impossible or cause a full device reset of some kind.

Jason
