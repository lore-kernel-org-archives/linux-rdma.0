From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH V3 3/4] RDMA/iser: limit sg tablesize to device fastreg max depth
Date: Wed, 1 Jul 2015 15:41:23 -0500
Message-ID: <009801d0b43e$4b22d390$e1687ab0$@opengridcomputing.com>
References: <20150701162936.6501.45512.stgit@build.ogc.int>	<20150701163052.6501.27775.stgit@build.ogc.int> <CAJ3xEMidOySxVe_SsZ_02HQNi5F2fMZX8e9n2H9y1YoK3uj6vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMidOySxVe_SsZ_02HQNi5F2fMZX8e9n2H9y1YoK3uj6vQ@mail.gmail.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Or Gerlitz' <gerlitz.or@gmail.com>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Roi Dayan' <roid@mellanox.com>, linux-rdma@vger.kernel.org, 'Sagi Grimberg' <sagig@mellanox.com>, 'Mike Marciniszyn' <infinipath@intel.com>, target-devel@vger.kernel.org, 'Eli Cohen' <eli@mellanox.com>, 'Or Gerlitz' <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]
> Sent: Wednesday, July 01, 2015 3:27 PM
> To: Steve Wise
> Cc: Doug Ledford; Roi Dayan; linux-rdma@vger.kernel.org; Sagi Grimberg; Mike Marciniszyn; target-devel@vger.kernel.org; Eli Cohen; Or
> Gerlitz
> Subject: Re: [PATCH V3 3/4] RDMA/iser: limit sg tablesize to device fastreg max depth
> 
> On Wed, Jul 1, 2015 at 7:30 PM, Steve Wise <swise@opengridcomputing.com> wrote:
> 
> please no empty change-logs for this driver (and elsewhere), find
> something that fills @ least one sentence, it's easy.
> 

sure.

> Also, we are aiming to initiate (Sagi please make sure you follow on
> this practice too) commit titles for the iser initiator with Capital
> letter, so s/limit/Limit/g
>

I thought SOP was to _not_ capitalize in this case?

 
> > Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> > ---
> >  drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > index 6a594aa..ec692f7 100644
> > --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> > +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > @@ -640,6 +640,13 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
> >                                                    SHOST_DIX_GUARD_CRC);
> >                 }
> >
> > +               /*
> > +                * Limit the sg_tablesize based on the device max fastreg page
> > +                * list length.
> > +                */
> > +               shost->sg_tablesize = min_t(u32, shost->sg_tablesize,
> > +                       ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> > +
> 
> I guess you should also somehow recap shost->max_sectors (which is
> hard coded to 1024 (== 512KB IO) now) for your needs.
>

Ok.  
