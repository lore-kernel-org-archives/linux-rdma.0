From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 3/3] iw_cxgb4: remove the stid on listen create failure
Date: Fri, 15 Sep 2017 13:51:17 -0500
Message-ID: <019a01d32e53$9ccadc60$d6609520$@opengridcomputing.com>
References: <20170915140822.B0E2DE0C1D@smtp.ogc.us> <20170915164605.GA27343@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170915164605.GA27343@kroah.com>
Content-Language: en-us
Sender: stable-owner@vger.kernel.org
To: 'Greg KH' <gregkh@linuxfoundation.org>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH 3/3] iw_cxgb4: remove the stid on listen create failure
> 
> On Tue, Sep 05, 2017 at 11:52:34AM -0700, Steve Wise wrote:
> > Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> > ---
> >  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I know I sure don't take patches without changelog text, and for sure
> that could never go into a stable tree...

I thought the one line commit log was sufficient.  I'll be more verbose.

Thanks,

Steve.
