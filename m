From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Fri, 27 May 2016 00:22:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05BBED@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
 <HE1PR05MB1418B4396F696F763D67A893B1410@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20160526184348.GA22174@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160526184348.GA22174-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'd say that is actually more likely to happen if it is open
> coded. Nested object locking like that requires consistent ordering to
> avoid deadlock..
> 
> It would be easier for the core code to enforce consistent nested lock
> acquire ordering than to try and do that scattered across all the
> code. You are right, the core code cannot just iterate over the
> provided object list and grab the locks.
> 
> One very simple option is for the core to enforce a sort order on the
> object list as it grabs the locks and fail&unwind for unordered lists.

I did not have object locking in my proposal.  I tried to maintain very simple locking, hoping it would make it possible for a mere human to validate that the locking was correct.  Plus it kept the size of the object structure smaller.

A lock associated with the idr is held while objects are acquired.  A simple reference count is bumped for each object when used.  If exclusive access is required, a flag is set.  If the exclusive flag is set, then any attempt to acquire the object is rejected and the ioctl fails.

Coordination with the removal of the kernel client (i.e. device) is done using a rw-lock.  Ioctls acquire a read lock, while the removal processing acquires the write lock.

Maybe there's a reason to create a more complex scheme than this, similar to what uverbs has, but AFAICT, this level of synchronization seems sufficient.  Any lower-level locking is the responsibility of the kernel client.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
