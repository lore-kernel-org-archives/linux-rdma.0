From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: iSER multi-queue configuration
Date: Mon, 2 May 2016 10:12:22 -0500
Message-ID: <01c201d1a485$06cc8f50$1465adf0$@opengridcomputing.com>
References: <CAF1ivSa24Y114s0f0g74jgmP8MuPfrfU_uAA7AAVR8Tsz=+avg@mail.gmail.com>	 <1461996836.4373.5.camel@kernel.org> <57256FB6.7030607@grimberg.me> <1462082826.11010.3.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1462082826.11010.3.camel@kernel.org>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Ming Lin' <mlin@kernel.org>, 'Sagi Grimberg' <sagi@grimberg.me>, linux-rdma@vger.kernel.org
Cc: 'Bart Van Assche' <bart.vanassche@sandisk.com>, 'target-devel' <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Ming Lin
> Sent: Sunday, May 01, 2016 1:07 AM
> To: Sagi Grimberg; linux-rdma@vger.kernel.org
> Cc: Bart Van Assche; target-devel
> Subject: Re: iSER multi-queue configuration
> 
> On Sun, 2016-05-01 at 05:53 +0300, Sagi Grimberg wrote:
> > > Hi Sagi,
> >
> > Hi Ming,
> >
> > > I'm looking at why there is only 1 HW queue for iser.
> > >
> > > 2185 int scsi_mq_setup_tags(struct Scsi_Host *shost)
> > > 2186 {
> > > ...
> > > 2199         shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? :
> > > 1;
> > >
> > >
> > > It seems because iser code does not set shost->nr_hw_queues at all.
> > >
> > > Why?
> >
> > The iscsi driver has not yet been converted to scsi_mq and iser as
> > an iscsi transport still does not use multi-queue.
> 
> I'm going to compare performance between NVMe over RDMA and SCSI over
> RDMA. SRP supports scsi_mq, so I'd use SRP to do the apples-to-apples
> comparison.
> 
> >
> > In iscsi, a hw queue maps to an iscsi session. In order to support
> > multi-queue we need to have iscsi open multiple sessions and map
> > a session to a queue.
> >
> > I had some preliminary works on this (joint with Mike Christie) but I
> > didn't have time thus far to implement a full conversion to scsi-mq.
> 
> I'd happy to test it once you done.

Ditto.  SRP as a comparison is only useful for IB/RoCE transports.  iSER will allow iWARP to play in the game as well...

Steve.
