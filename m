From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Wed, 9 Mar 2016 10:19:51 -0500
Message-ID: <20160309151951.GA15031@phlsvsds.ph.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com> <CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com> <20160309002157.GA20105@phlsvsds.ph.intel.com> <CAJ3xEMhcs-6vDzsNk9nJKoNxTWnfaUtDmNHhLp1EPyerjnw2Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhcs-6vDzsNk9nJKoNxTWnfaUtDmNHhLp1EPyerjnw2Xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2016 at 04:47:04PM +0200, Or Gerlitz wrote:
>4. so from now on, we can patch hfi with 300 patches per release that
>deal with extensions
>to functionality exposed by the char device  and we don't care to
>solve generic problems
>that has nothing to do with the HW used for the device.
>
>Really?

There is certainly a large number of patches pending for 4.6 I'll give you 
that, and yes it is greater than 300. However, these cover 3 drivers, qib, 
hfi1, and rdmavt.  The bulk of that work is the refactoring of the verbs 
code from qib and hfi1 to rdmavt which was done in a very incremental 
process. 

The vast majority of these pending patches are not related to "extensions to 
functionality exposed by the char device".

In fact, I'd say that the verbs refactoring is precisely solving a generic 
problem.  So I can't agree with you here.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
