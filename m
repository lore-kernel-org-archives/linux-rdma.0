From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Mon, 23 Oct 2017 14:33:46 -0400
Message-ID: <1508783626.3325.16.camel@redhat.com>
References: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
         <1508771116.3325.0.camel@redhat.com>
         <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-23 at 13:57 -0400, Dennis Dalessandro wrote:
> On 10/23/2017 11:05 AM, Doug Ledford wrote:
> > On Fri, 2017-10-13 at 13:56 +0300, Dan Carpenter wrote:
> > > The "2 * UINT_MAX" overflows so the test is essentially doing
> > > this:
> > > 
> > > 	if ((u64)(ts - cce->timestamp) > UINT_MAX - 1) {
> > > 
> > > I've changed it to a 64bit type.
> > > 
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > ---
> > > Not tested.
> > > 
> > > diff --git a/drivers/infiniband/hw/hfi1/mad.c
> > > b/drivers/infiniband/hw/hfi1/mad.c
> > > index f4c0ffc040cc..3aeea8afd44f 100644
> > > --- a/drivers/infiniband/hw/hfi1/mad.c
> > > +++ b/drivers/infiniband/hw/hfi1/mad.c
> > > @@ -3781,7 +3781,7 @@ static int
> > > __subn_get_opa_hfi1_cong_log(struct
> > > opa_smp *smp, u32 am,
> > >   		 * required to wrap the counter are supposed to
> > >   		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
> > >   		 */
> > > -		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
> > > +		if ((u64)(ts - cce->timestamp) > (2ULL *
> > > UINT_MAX))
> > >   			continue;
> > >   		memcpy(cong_log->events[i].local_qp_cn_entry,
> > > &cce-
> > > > lqpn, 3);
> > > 
> > >   		memcpy(cong_log-
> > > > events[i].remote_qp_number_cn_entry,
> > 
> > Denny, I'm looking for feedback from you on this patch.  This fixes
> > a
> > bug, my only concern is that the code used to work with the bug,
> > could
> > this make the code not work?
> > 
> 
> Mike and I have been looking at this. The code seems to work as it
> is 
> but fails with Dan's patch. We are still looking at it, but I'd
> advise 
> against pulling just yet. It's not something for 4.14.

That's what I was afraid of: by fixing a C language bug, you expose the
fact that there is a subtle logic bug that's only been working because
of the C language bug ;-).

I'll hold off until you send this patch through with whatever
incremental changes are needed elsewhere to make it work.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

