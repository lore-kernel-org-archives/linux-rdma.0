From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: HFI1 code duplication todo
Date: Thu, 12 Nov 2015 16:13:18 -0500
Message-ID: <20151112211317.GB11252@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The major todo for the hfi1 driver in staging is getting rid of the verbs 
code duplication between ipath, qib, and now hfi1. The ipath driver has been 
deprecated and is going to be deleted soon. So that leaves qib and hfi. To 
address this we have proposed rdmavt which will be a common kmod that 
provides software RDMA verbs support. qib and hfi1 will both use this as 
well as other forthcoming drivers such as soft-roce. See this thread for 
some details: http://www.spinics.net/lists/linux-rdma/msg29922.html.

Since that initial RFC we have been accumulating patches in a GitHub repo 
for an early look at the development. At some point soon we want to actually 
start posting the patches to the mailing list. This is where it gets tricky.  
The code basically not only adds a new driver but it modifies two existing 
ones, heavily. To make it more murky one driver is in staging the other is 
in the usual drivers/infiniband tree.

The question is, how do we go about this logistically due to the 2 drivers 
being in separate sub-trees?

Greg, Doug,
As the maintainers of the two trees involved we'd kind of like to get your 
thoughts on this.

Thanks

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
