From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH V3 4/4] RDMA/isert: Support iWARP transport
Date: Wed, 1 Jul 2015 15:53:19 -0500
Message-ID: <009a01d0b43f$f5fa8640$e1ef92c0$@opengridcomputing.com>
References: <20150701162936.6501.45512.stgit@build.ogc.int>	<20150701163058.6501.39171.stgit@build.ogc.int> <CAJ3xEMjWVwbW0sgVsMj3hPLMRZgJ8srMG89gYzUEbvQAHBaUEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMjWVwbW0sgVsMj3hPLMRZgJ8srMG89gYzUEbvQAHBaUEw@mail.gmail.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Or Gerlitz' <gerlitz.or@gmail.com>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Roi Dayan' <roid@mellanox.com>, linux-rdma@vger.kernel.org, 'Sagi Grimberg' <sagig@mellanox.com>, 'Mike Marciniszyn' <infinipath@intel.com>, target-devel@vger.kernel.org, 'Eli Cohen' <eli@mellanox.com>, 'Or Gerlitz' <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]
> Sent: Wednesday, July 01, 2015 3:33 PM
> To: Steve Wise
> Cc: Doug Ledford; Roi Dayan; linux-rdma@vger.kernel.org; Sagi Grimberg; Mike Marciniszyn; target-devel@vger.kernel.org; Eli Cohen; Or
> Gerlitz
> Subject: Re: [PATCH V3 4/4] RDMA/isert: Support iWARP transport
> 
> On Wed, Jul 1, 2015 at 7:30 PM, Steve Wise <swise@opengridcomputing.com> wrote:
> > Memory regions that are the target of an iWARP RDMA READ RESPONSE need
> > REMOTE_WRITE access rights.  So enable REMOTE_WRITE for iWARP devices.
> 
> I don't see the point to mess the code with this branching on the
> iwarp specific diffs from IB/RoCE -- note that the MRs for which you
> mangle their access flags are LOCAL and not advertised to external
> entity (initiator), hence why not just OR into the access flags what
> iwarp needs?!

Yes, the MR is a local MR, but it is used for REMOTE access for iWARP, but not IB.  It think the reason is that in iWARP there is no distinction between local and remote keys.  For iwarp you get 1 key called a Steering Tag or STAG that is used both locally and advertised to the peer (if to be used for REMOTE IO).  Further, that STAG is sent to the peer in the RDMA READ REQUEST and the peer iWARP stack uses it to generate READ RESPONSE messages with the advertised STAG as the READ DESTINATION.  And thus these STAGs require REMOTE_WRITE access flags.  In IB, I believe the "key" sent in the READ REQUEST is not the MR lkey or rkey at all, but a one-shot transaction key, valid for that READ operation only, and the local IB stack uses this key to map to the destination MR/lkey when processing th
 e RDMA READ RESPONSE.  This difference in the protocols is what drives the access flag difference.

Regardless, I'm not sure what you propose I do differently?  The code in this patch does OR the needed access flag if the device is iWARP when creating the DMA_MR.

> 
> > Use the device's max_sge_rd capability to compute the target's read sge
> > depth.  Save both the read and write max_sge values in the isert_conn
> > struct, and use these when creating RDMA_READ work requests
> 
> We have here strictly two related but different changes, break this to
> two patches.
> 

Easy enough.

> > +static int any_port_is_iwarp(struct isert_device *device)
> > +{
> > +       int i;
> > +
> > +       for (i = rdma_start_port(device->ib_device);
> > +            i <= rdma_end_port(device->ib_device); i++)
> > +               if (rdma_protocol_iwarp(device->ib_device, i))
> > +                       return 1;
> > +       return 0;
> > +}
> > +
> 
> If this needed @ all, put in one of the IB core headers, not in a ULP source

As per the consensus on V2 of the series, the core changes to remove any_port_is_iwarp() will be in a subsequent series so we can carefully review the new proposed API and see how it affects the apps that use it (iSER and NFSRDMA).  I'll be posting this 2nd series soon.

Thanks!

Steve.
