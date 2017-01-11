From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 14:18:59 -0600
Message-ID: <03b301d26c47$f154a5a0$d3fdf0e0$@opengridcomputing.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com> <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com> <027101d26c2c$c94467f0$5bcd37d0$@opengridcomputing.com> <28B0D906-7BDB-4B87-94E9-6BE263BFBFF7@oracle.com> <038901d26c44$67d6c4f0$37844ed0$@opengridcomputing.com> <383D1FFB-346B-40E9-A174-606F13AFF849@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <383D1FFB-346B-40E9-A174-606F13AFF849-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'Amrani, Ram'" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Elior, Ariel'" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Kalderon, Michal'" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'List Linux RDMA Mailing' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Hariprasad S' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

<snip>

> >> It might be cool to have an API similar to rdma_rw that allows ULPs
> >> to use a scatterlist for Send and Receive operations. It could hide
> >> the driver and device maximum SGE values.
> >>
> >
> > I'm not sure what you mean by "in place"?  (sorry for being not up to speed
on
> > this whole issue)  But perhaps some API like this could be added to
rdma_rw...
> 
> "in place" == the SGE array would point to struct pages
> containing parts of the message payload. That's basically what
> this "support large inline threshold" patch is doing.
> 
> If the device supports only 4 SGEs, then the largest
> message size that can be sent this way is just one or two
> pages.
> 
> Some would prefer to send much larger payloads this way.
>

I'm not sure how the API would do this w/o having to send multiple ULP protocol
SEND messages and thus that moves the logic into the ULP.  IE if the device only
supports 4 SGE, and that only allows 2 pages worth of inline data, then the ULP
needs to create multiple SEND messages with ULP headers in each, I would think.
Not sure how this could be done below the ULP...

> I guess what I'm asking is whether 4 SGEs is going to be typical
> of HCAs going forward, or whether there is a definite trend for
> adding more in new device designs.
>

The iWARP spec mandates 4 as the minimum.   That's where the 4 came from for
iWARP devices...

<snip>

> >> The original code needed only two SGEs for sending, and one for
> >> receiving.
> >>
> >> IIRC the RPC-over-RDMA receive path still needs just one SGE.
> >>
> >
> > No I mean the code that bumps it up to 18.  Would that cause an immediate
> > failure if cxgb4 supported 17 and only enforces it at post_send() time?
> 
> "mount" would fail immediately if the driver reported max_sge == 17.
> The check that Ram mentioned happens at mount time, before anything
> has been sent.
>

Hmm...
 
> 
> > (haven't looked in detail at your patches...sorry).  Our QA ran testing on
4.9
> > and didn't see this issue, so that's why I'm asking.    They have not yet
run
> > NFS/RDMA testing on 4.9-rc.  I've asked them to do a quick regression test
asap.
> 

Correction: I meant 4.10-rc above.   

But still, I believe Chelsio tested 4.9, so perhaps it isn't the "mount" that
causes a failure but trying to send something with an SGE > 4 that happens
immediately after the mount?  And since cxgb4 supports up to 17, the failure
wouldn't be seen until some inline message was attempted that required 18
sges...

> That's curious!
> 
> 
> >>> Note: the ib_device_attr only has a max_sge that pertains to both send and
> > recv,
> >>> so cxgb4 sets it to the min value.  We should probably add a max_recv_sge
> > and
> >>> max_send_sge to ib_device_attr...
> >>
> >> I could go for that too.
> >>
> >
> > I'm swamped right now to add this, but the changes should be trivial...
> 
> Maybe I could get to it, but no promises.

(I'm holding my breath! ;))

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
