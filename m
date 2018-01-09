From: Aishwarya Pant <aishpant@gmail.com>
Subject: Re: Documentation: infiniband: move sysfs interface to ABI
Date: Tue, 9 Jan 2018 23:17:07 +0530
Message-ID: <20180109174707.GA19233@mordor.localdomain>
References: <20180108085342.GB8353@mordor.localdomain>
 <20180109172820.GD4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109172820.GD4518@ziepe.ca>
Sender: linux-doc-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 10:28:20AM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 08, 2018 at 02:23:42PM +0530, Aishwarya Pant wrote:
> > Hi
> > 
> > In Documentation/infiniband/sysfs.txt, there is a description of the infiniband
> > sysfs interface and there also exists
> > Documentation/ABI/testing/sysfs-class-infiniband which is out of date.
> > 
> > Would it be useful to move out the interface completely from
> > Documentation/infiniband/sysfs.txt to the ABI?
> 
> It would be good, but I fear all the documentation files are variously
> out of date, so it would be harder to do this task reliably without
> having various rdma devices to inspect?
> 
> But if you want to take it on, I could probably get you some sysfs
> dumps from some systems to help?

Yes, I think that would be useful. I might not be able to fill in the
descriptions completely for all attributes but I can create a documentation
skeleton for them.

Aishwarya

> 
> Jason
