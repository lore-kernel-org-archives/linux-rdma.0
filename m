From: 'Greg KH' <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] iw_cxgb4: remove the stid on listen create failure
Date: Fri, 15 Sep 2017 11:59:05 -0700
Message-ID: <20170915185905.GA22953@kroah.com>
References: <20170915140822.B0E2DE0C1D@smtp.ogc.us>
 <20170915164605.GA27343@kroah.com>
 <019a01d32e53$9ccadc60$d6609520$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <019a01d32e53$9ccadc60$d6609520$@opengridcomputing.com>
Sender: stable-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 15, 2017 at 01:51:17PM -0500, Steve Wise wrote:
> > Subject: Re: [PATCH 3/3] iw_cxgb4: remove the stid on listen create failure
> > 
> > On Tue, Sep 05, 2017 at 11:52:34AM -0700, Steve Wise wrote:
> > > Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> > > ---
> > >  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > I know I sure don't take patches without changelog text, and for sure
> > that could never go into a stable tree...
> 
> I thought the one line commit log was sufficient.  I'll be more verbose.

All you are saying in the subject was _what_ you did, which does nothing
to explain _why_ you did it.  Especially for something you feel needs to
be fixed in older kernels you need to explain why it is all needed.

Changelog descriptions are hard, usually harder than writing the
original patch.  Welcome to good software engineering practices :)

thanks,

greg k-h
