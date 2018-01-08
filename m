From: Aishwarya Pant <aishpant@gmail.com>
Subject: Documentation: infiniband: move sysfs interface to ABI
Date: Mon, 8 Jan 2018 14:23:42 +0530
Message-ID: <20180108085342.GB8353@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

Hi

In Documentation/infiniband/sysfs.txt, there is a description of the infiniband
sysfs interface and there also exists
Documentation/ABI/testing/sysfs-class-infiniband which is out of date.

Would it be useful to move out the interface completely from
Documentation/infiniband/sysfs.txt to the ABI?

The ABI documentation format looks like the following:

What: (the full sysfs path of the attribute)
Date: (date of creation)
KernelVersion: (kernel version it first showed up in)
Contact: (primary contact)
Description: (long description on usage)

I am doing this in an exercise to move sysfs ABI interfaces (which are
documented) to their right place i.e. in Documentation/ABI along with the rest.

Aishwarya
