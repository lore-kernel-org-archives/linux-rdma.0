From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Mon, 2 May 2016 15:55:02 -0400
Message-ID: <20160502195502.GA31800@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The hfi1 driver has a "UI" device associated with it. This is currently a
char dev. It is used for debugging/diagnostics. Basically it provides direct
user level access to HW registers. We have been exploring options to remove
this char dev, yet retain the same functionality.

One approach we have considered is using the regmap interface. This has a
number of problems. It is primarily a read only interface. The write
capability is not even available as a compile time option. A code change is
needed to make use of it. There are other issues as well such as being 32bit
when we need 64bit. So this seems like the wrong option.

Another approach is using the driver's resource0 file. We can mmap() the BAR
and access the registers. The main drawback we have with that is we have
some hardware requirements that the driver needs to arbitrate access to
certain registers. This means some form of kernel/user space shared locking.  
We are currently not aware of anything that the kernel provides to achieve 
this. However, we are still looking and would appreciate any pointers.

The third approach would be to take our existing UI implementation and plop
it down in debugfs as a binary file. We can control our locking just as we
do today, in the driver. This gets rid of the character device, and it's not
even available unless the admin decides to mount debugfs.

We also should be able to use any of these schemes to handle our eprom
reading/writing. Adding eprom to IPoIB as Doug suggested is a fine plan, but
we technically don't need to do it right now when we could make do with the
"UI" functionality and hide the details in user space. In the future there 
may well be value in having an eprom capability in the rdma sub-system, but 
for now we believe we can avoid extending the kernel in this regard.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
