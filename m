From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Wed, 4 May 2016 11:09:08 +0200
Message-ID: <20160504090908.GA14787@lst.de>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com> <20160503093307.GL19931@lst.de> <5729147C.5000904@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5729147C.5000904-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 03, 2016 at 02:13:32PM -0700, Bart Van Assche wrote:
> > I don't think there is any good reason to printk a warning here -
> > limited hardware is a totally normal thing.  E.g. if we merge
> > your RDMA/CM support and someone runs SRP on chelsio hardware they'd
> > probably hit this all the time..
> 
> Are you sure? What I see in the v4.6-rc6 tree seems to indicate that Chelsio
> hardware supports large page lists:

You're right - I was confused about the small data sizes it allows
without MRs.  Either way, limited hardware on the initiator side is
something totally normal that happens all the time especiall with
SCSI HBAs, so I'd prefer to not spew a warning about it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
