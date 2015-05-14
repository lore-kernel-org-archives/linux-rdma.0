From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Thu, 14 May 2015 16:03:47 +0300
Message-ID: <55549D33.1000208@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
 <1431530845.2377.30.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431530845.2377.30.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/13/2015 6:27 PM, Doug Ledford wrote:
> They will land at kernel.org when I know they won't change again (which
> really means when I have the final kdoc patch and Ira's dependent
> patches and everything there is merged properly).  For now, they are
> present at the github repo as:
>
> mwang-v8
> ira-cleanups
> to-be-rebased/for-4.2 (which is nothing but a merge of the two above
> branches)

Doug,

Developers whose work depends on other people can't chase multiple 
branches. And they need not wait for the maintainer to be 110% sure that 
something is final. Our community is small enough to swallow rebases you 
would do if at some point a patch for the next kernel is replaced, etc.

As others companies we have here internal review (Gerrit), build and 
regression systems which are dependent on the open-source maintainers 
trees/branches (for example, Dave Miller's net and net-next trees and 
used to be also on Roland infiniband.git / for-next branch).  These 
branches must be well known in location and name.

Lets find a way to get things in that direction, for everyone's benefit.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
