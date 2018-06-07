From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Thu, 7 Jun 2018 12:00:34 -0600
Message-ID: <20180607180034.GD14583@ziepe.ca>
References: <20180530220405.GH30754@ziepe.ca>
 <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
 <20180530222520.GJ30754@ziepe.ca>
 <d2472443-3ae6-63f4-59ad-d6367b837038@opengridcomputing.com>
 <CAK8P3a3HZXTR60ua=cjBHnB5FWWKve9F-JqcNwn0ujks+=FsNg@mail.gmail.com>
 <20180530230136.GK30754@ziepe.ca>
 <CAHH2K0ZLDmsPNw=sOobL=+R54yRFrnG4syWcW43UEbwxsvFehw@mail.gmail.com>
 <d23e215a30f1277c941973043262cdfc60c71315.camel@redhat.com>
 <20180604230745.GG24926@ziepe.ca>
 <CAHH2K0baMto7A75YxvP9LWtR9wgAFY76n_2q3fX_b=qcnuX1mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHH2K0baMto7A75YxvP9LWtR9wgAFY76n_2q3fX_b=qcnuX1mw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Thelen <gthelen@google.com>
Cc: Doug Ledford <dledford@redhat.com>, Arnd Bergmann <arnd@arndb.de>, swise@opengridcomputing.com, swise@chelsio.com, yuval.shaia@oracle.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 07, 2018 at 01:10:39AM -0700, Greg Thelen wrote:
> > > I don't really think I like this approach though.  At a minimum if you
> > > are going to make iWARP totally dependent on rdmacm, then there is zero
> > > reason that iw_cm.o should be part of the obj-$(CONFIG_INFINIBAND)
> > > Makefile recipe when ADDR_TRANS is disabled.
> >
> > This makes sense, Greg, can you send a followup patch with these
> > items? I know this series has been tough..
> >
> > Thanks,
> > Jason
> 
> Ack.  Sorry for delay.  I'll take a look at this in a day or two.  Let
> me know if it's more urgent.

No rush, sometime in the next several weeks is fine

Jason
