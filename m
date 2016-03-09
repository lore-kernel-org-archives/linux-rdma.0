From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Wed, 9 Mar 2016 16:47:04 +0200
Message-ID: <CAJ3xEMhcs-6vDzsNk9nJKoNxTWnfaUtDmNHhLp1EPyerjnw2Xg@mail.gmail.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
	<CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com>
	<20160309002157.GA20105@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160309002157.GA20105-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 9, 2016 at 2:21 AM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Mar 08, 2016 at 10:56:48PM +0200, Or Gerlitz wrote:
>>

>> If indeed there's a need for such a pin down cache, it should have
>> been implemented in the IB core, b/c both the problem and the solution
>> are generic and have nothing to do with certain device driver.

> Since this is for psm it has nothing to do with the IB core. I fail to see
> what that would achieve.

So your logic goes like

1. hfi is a driver which plugs into the IB core

2. OTOH hfi implements proprietary inter-connect, but we can use the
IB core for fabric management
so we change the IB core MAD code to support the interconnect

3. OTOH the maintainer allowed hfi to expose to user-space proprietary
char-device

4. so from now on, we can patch hfi with 300 patches per release that
deal with extensions
to functionality exposed by the char device  and we don't care to
solve generic problems
that has nothing to do with the HW used for the device.

Really?

>> The problem is that you are bypassing the IB core altogether with a
>> proprietary character device in the hfi1 driver which managed to snick
>> in even in the presence of reviewer comments during the submission.

> Yes there were reviewer comments, and the maintainer made a decision.
> I would also not call this proprietary. It is open source after all:
>
> See:  https://github.com/01org/opa-psm2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
