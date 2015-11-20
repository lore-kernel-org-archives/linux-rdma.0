From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/9] staging/rdma/hfi1: Add function stubs for TID caching
Date: Fri, 20 Nov 2015 10:21:44 +0200
Message-ID: <CAJ3xEMgjTfRQPPRs_grgqG49RMi1jTxwB9TkS+pjdhgqcPDg-A@mail.gmail.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
	<1446244918-12089-6-git-send-email-ira.weiny@intel.com>
	<CAJ3xEMiLz=kgeQhx07WFWtNzcPwy2ZL9fs0SZkSpVd6+reGUVA@mail.gmail.com>
	<20151120010630.GA25032@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151120010630.GA25032-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 3:06 AM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Thu, Nov 12, 2015 at 07:58:54AM +0200, Or Gerlitz wrote:
>> On Sat, Oct 31, 2015 at 12:41 AM,  <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> So this is an wholy orthogonal mechanism for memory registrations or
>> de-registrations vs what's supported by the upstream RDMA stack to which this driver
>> attempts to be a HW provider, right?

>> Ira, Mike - why do that?

>> 2. Greg - I read an earlier comment you made that a driver in staging need to be 1st
>> and most **fixed** with patches such that the TODO items to get it out
>> of staging are addressed. I see here every day long train of features going into this
>> driver, should the focus need to be elsewhere, according to the staging guidelines?

> I've already complained about this, supposedly these are things that are
> needed to get it out of staging...

Greg,

When the driver was picked by Doug to staging, the only major comment
he has was the need to come up with shared code that implements IBTA
transport in SW -- to avoid the code duplication between ipath, qib and hfi1

Indeed, work has been started to do that, but since hfi1 is in staging,
none of the patches applied on it deal with that comment. I guess it
should be OK that people sends cleanup once the driver is already there,
buy should it be so heavily patched with new features? Mike? Doug?

> And yes, you are correct.

I know...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
