From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu
 refcount optional for user MRs
Date: Thu, 6 Apr 2017 14:47:56 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC342EABD0@fmsmsx120.amr.corp.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
 <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
 <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
 <20170406074955.GG2269@mtr-leonro.local>
 <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > However, I have an question, how do you ensure that user memory has no
> > users without refcounts? Will it be possible to dereg the memory
> > despite the fact that there are users?
> 
> Mike can correct me if I'm wrong but it is still refcounted. Just not per CPU,
> global if you will.
> 

The details on appropriate usage are in include/linux/percpu-refcount.h.

The counters "can" operate in percpu or atomic mode based on an initialization choice.   Percpu mode is STILL reference counting.

At the point that a counted object is heading out the door, the counter is changed to atomic mode with an implicit RCU barrier in percpu_ref_kill().

frmr, dma, and user MRs transparently use the percpu mode with a significant benefit for data path operations.

There were two patches in the patch series, one reworks the rdmavt read side MR to allow for getting rid of an explicit RCU at deref time.   The second module parameter was intended to allow for a faster memory registration for user MRs as an option.

Ideally, the choice SHOULD be addressed in the MR registration code as a "fast dereg" option in ib_access_flags?

Mike




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
