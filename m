From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next 00/27] IB/hfi1, rdmavt, core, etc: patches for
 next 08/04/2017
Date: Fri, 18 Aug 2017 15:07:09 -0400
Message-ID: <1503083229.2598.45.camel@redhat.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
         <f73b2f88-bc1b-92ed-1632-d2f3b1583d60@intel.com>
         <e6444306-2507-d632-3a2c-1bb736af999c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <e6444306-2507-d632-3a2c-1bb736af999c@intel.com>
Sender: stable-owner@vger.kernel.org
To: Don Hiatt <don.hiatt@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Bartlomiej Dudek <bartlomiej.dudek@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-10 at 11:17 -0700, Don Hiatt wrote:
> 
> On 8/10/2017 10:05 AM, Dennis Dalessandro wrote:
> > On 8/4/2017 4:52 PM, Dennis Dalessandro wrote:
> > 
> > > Dasaratharaman Chandramouli (10):
> > >        IB/core: Convert ah_attr from OPA to IB when copying to
> > > user
> > >        IB/srpt: Increase lid and sm_lid to 32 bits
> > >        IB/IPoIB: Increase local_lid to 32 bits
> > >        IB/mad: Change slid in RMPP recv from 16 to 32 bits
> > >        IB/core: Change port_attr.lid size from 16 to 32 bits
> > >        IB/core: Change port_attr.sm_lid from 16 to 32 bits
> > >        IB/CM: Create appropriate path records when handling CM
> > > request
> > >        IB/CM: Set appropriate slid and dlid when handling CM
> > > request
> > >        IB/rdmavt,hfi1,qib: Enhance rdmavt and hfi1 to use 32 bit
> > > lids
> > >        IB/hfi1: Enable RDMA_CAP_OPA_AH in hfi driver to support 
> > > extended LIDs
> 
> I submitted a v4 of just the 'extended lid' changes which is 8
> patches 
> in total.
> These patches from Denny's original patch series (from Dasa) are
> still 
> valid:
> 
>         IB/CM: Set appropriate slid and dlid when handling CM request
>         IB/rdmavt,hfi1,qib: Enhance rdmavt and hfi1 to use 32 bit
> lids
>         IB/hfi1: Enable RDMA_CAP_OPA_AH in hfi driver to support 
> extended LIDs

OK, I *think* I've got things figured out, but I need to request that
you guys submit things differently in the future.

In general, if you submit a series of 7 patches that does some "thing",
then whether or not a resubmit adds or reduces the patch count, it
should still be just that "thing".  And once you do a submission for a
"thing" as a series, that series should never get subsumed into another
"thing".  In order for me to keep v1 versus v2 of any given "thing"
straight and not miss stuff, or waste a ton of time trying to apply
things that are already applied, a "thing" must remain the same "thing"
unless it is clearly withdrawn entirely and submitted as part of a new
"thing".

That said, I have the two series that updated the lid size and added
the support to the CM.  I think that means that patches 7 through 16
are now all applied, but I still need to process the others (and
digging that "thing" out of the middle is even hard than if it were
just at the beginning or the end).  Let me know if that is not correct.

> 
> > Leon had some comments with these patches and Don is going to
> > submit 
> > an updated version of these 10. These were submitted previously
> > back 
> > in early June and sat on the list without comment. Hearing no
> > feedback 
> > I rebased them and sent with my other patches so we could get the 
> > driver patches out.
> > 
> > In hindsight we probably should have just submitted another
> > revision 
> > to these 10 and sent the following 11 and the other 6 as a
> > separate 
> > series. If that makes things easier we can still do that. Let me
> > know 
> > the easiest way for you to consume these.
> > 
> > > Don Hiatt (11):
> > >        IB/core: Change wc.slid from 16 to 32 bits
> > >        IB/CM: Add OPA Path record support to CM
> > >        IB/rdmavt,hfi1,qib: Modify check_ah() to account for
> > > extended 
> > > LIDs
> > >        IB/hfi1: Add support to receive 16B bypass packets
> > >        IB/hfi1: Add support to send 16B bypass packets
> > >        IB/hfi1: Add support to process 16B header errors
> > >        IB/hfi1: Determine 9B/16B L2 header type based on Address
> > > handle
> > >        IB/hfi1: Add 16B UD support
> > >        IB/hfi1: Add 16B trace support
> > >        IB/hfi1: Add 16B RC/UC support
> > >        IB/hfi1: Enhance PIO/SDMA send for 16B
> > 
> > These will still apply, as will the other 6 patches in this series.
> > 
> > -Denny
> 
> 
-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
