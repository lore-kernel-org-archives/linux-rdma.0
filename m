From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 9/9] ib_verbs: Add a new qp create flag to request
 features for Ethernet over IB
Date: Fri, 2 Sep 2016 10:34:51 -0600
Message-ID: <20160902163451.GC24997@obsidianresearch.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
 <1472774969-18997-10-git-send-email-knut.omang@oracle.com>
 <20160902021729.GE30057@obsidianresearch.com>
 <1472792670.9410.276.camel@oracle.com>
 <1472814057.3975.47.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472814057.3975.47.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 02, 2016 at 01:00:57PM +0200, Knut Omang wrote:
> On Fri, 2016-09-02 at 07:04 +0200, Knut Omang wrote:
> > On Thu, 2016-09-01 at 20:17 -0600, Jason Gunthorpe wrote:
> > > 
> > > On Fri, Sep 02, 2016 at 02:09:29AM +0200, Knut Omang wrote:
> > > > 
> > > > Some Infiniband HCAs need to know if a QP is going to
> > > > be used for Ethernet over IB (EOIB).
> > > You will have to send this after your driver. I recommend a patch
> > > proposing this functionality with your driver as the example
> > > implementation, along with a kernel user, as mellanox typically does.
> > It's a bit of a chicken and egg situation since the driver 
> > depends on the patches. If I can 'tick off' this bit soon, I can move ahead and 
> > get to the send the driver too.
> > 
> > There's not much info in the driver - it just forwards that bit to a hardware bit
> > and it all happens from there. But hardware needs to know when to set that bit,
> > as it is only valid when operating as transport for Ethernet.
> > 
> > Please - it would be a big help for me (saving a lot of work down the line that 
> > is better spent working with the community than with handling more version issues later) 
> > if I can get an indication that just that bit would be acceptable 8-D ...
> 
> I will add the following further justification to the commit message for v2:
> 
> Support for encapsulation of Ethernet over IB (EoIB) is a generic feature 
> where different HCA implementations can include different special features. 
> One example is that if the HCA knows the QP is going to be used for Ethernet, 
> the implementation can ensure that all messages sent on this QP represents 
> a properly formatted encapsulation of Ethernet frames with legal header values.
> Or the HCA can perform the encapsulation itself.

It would be better to remove support for this from your driver in the
initial submission.

Keep new uAPIs in new driver submissions to an absolute minimum please.

And as I said, you need to introduce a kernel user of this bit as
well, so the driver alone is not enough.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
