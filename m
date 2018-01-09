From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: Documentation: infiniband: move sysfs interface to ABI
Date: Tue, 9 Jan 2018 10:28:20 -0700
Message-ID: <20180109172820.GD4518@ziepe.ca>
References: <20180108085342.GB8353@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108085342.GB8353@mordor.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 02:23:42PM +0530, Aishwarya Pant wrote:
> Hi
> 
> In Documentation/infiniband/sysfs.txt, there is a description of the infiniband
> sysfs interface and there also exists
> Documentation/ABI/testing/sysfs-class-infiniband which is out of date.
> 
> Would it be useful to move out the interface completely from
> Documentation/infiniband/sysfs.txt to the ABI?

It would be good, but I fear all the documentation files are variously
out of date, so it would be harder to do this task reliably without
having various rdma devices to inspect?

But if you want to take it on, I could probably get you some sysfs
dumps from some systems to help?

Jason
