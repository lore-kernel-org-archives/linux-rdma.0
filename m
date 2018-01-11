From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] iscsi_iser: Re-enable 'iser_pi_guard' module parameter
Date: Thu, 11 Jan 2018 09:58:22 -0700
Message-ID: <20180111165822.GC1309@ziepe.ca>
References: <1515575256-9949-1-git-send-email-hare@suse.de>
 <20180110230240.GR4518@ziepe.ca>
 <CY4PR0601MB35860D768905FF165DB99A048C160@CY4PR0601MB3586.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY4PR0601MB35860D768905FF165DB99A048C160-HWnCAiYGO2rYxEunYmvS1/tZqYE1FQh9nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Schremmer, Steven" <Steve.Schremmer-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 12:04:27AM +0000, Schremmer, Steven wrote:
> > From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> > Sent: Wednesday, January 10, 2018 5:03 PM
> > 
> > On Wed, Jan 10, 2018 at 10:07:36AM +0100, Hannes Reinecke wrote:
> > > The module parameter 'iser_pi_guard' has been disabled by commit
> > > 5bb6e543d2a7d58 ("IB/iser: DIX update"), but the functionality
> > > to select the guard algorithm is still required.
> > 
> > Commit should explain why it is still required? What is the actual bug here?
> > 
> > Someone who understands this is going to have to Ack it for it to go
> > through the rdma tree..
> > 
> Without the module parameter, there is no way to actually use the CRC guard format.
> Currently, iscsi_iser_session_create() indicates support for both IP and CRC formats, but 
> sd_dif_config_host() always checks for IP support first, so CRC guard won't be used.

The above paragraph would be a great addition to the commit message.

Still need an ack :)

BTW - not knowing anything, why isn't this knob in the core sd code?
Other drivers need it too from whatI could see?

We really don't like module parameters in the kernel.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
