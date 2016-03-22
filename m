From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Tue, 22 Mar 2016 09:33:55 +0200
Message-ID: <CAJ3xEMg5OPBT63=VV4EKnZUWSHGatDRL0n7O4iBVrN9bMUw5dg@mail.gmail.com>
References: <20160309050731.GM13396@leon.nu>
	<20160309192109.GB15031@phlsvsds.ph.intel.com>
	<20160310045609.GC1977@leon.nu>
	<20160314070951.GB26456@leon.nu>
	<20160314120152.GA30838@phlsvsds.ph.intel.com>
	<CAJ3xEMiSgXFT46r0Y7DZGr3mpJFSLrtYrMdz+DbCXDozbMYZRA@mail.gmail.com>
	<20160315012049.GA30055@phlsvsds.ph.intel.com>
	<CAJ3xEMhToYOBMo_nNi2fFpTexUmUqb3zBX7zWWYjCDfPWpWn-w@mail.gmail.com>
	<20160315193731.GA20662@phlsvsds.ph.intel.com>
	<CAJ3xEMjWxdwM0wQR85_-wHpPhYSWz1W0T8H_nDjnp2JS7G29Qw@mail.gmail.com>
	<20160316172309.GB26530@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316172309.GB26530-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2016 at 7:23 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Mar 16, 2016 at 05:53:37PM +0200, Or Gerlitz wrote:

>> The cache comes to amortize the cost of pin/unpin and such, correct? this means
>> that over longs runs, if there's nice locality of the same process
>> using the same pages, you pay the register/pin cost once, later use lazy
>> de-registration/pinning, and only do that
>> when MMU notifier tells you this is a must, or under some eviction policy.

>> Since the cost is amortized, the system calls over-head should be negligible
>> (also, the same system call can be used to evict X and register Y), do you
>> have performance data that shows otherwise?

> I don't personally have the data but will check with some folks here.

Dennis, didn't see a reply from you here...

Doug, as this is still review discussion in progress, I guess you'll wait with
finalizing the talks before adding this into your 2nd 4.6 pull request?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
