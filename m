From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Thu, 13 Jul 2017 11:29:39 -0700
Message-ID: <1499970579.7987.8.camel@haakon3.daterainc.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
         <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB25786338EADC77A369A6D493F8DD0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ram & Co,

(Adding Potnuri CC')

On Wed, 2017-06-28 at 11:32 +0000, Amrani, Ram wrote:
> > > We are hitting SQ overflow on iSER target side with high block sizes over RoCE
> > > (see dmesg output below).
> > >
> > > We are using Q-Logic/Cavium NIC with a capability of 4 sges.
> > 
> > That's somewhat expected if the device has low max_sge. It was decided
> > that queue_full mechanism is not something that iser-target should
> > handle but rather the iscsi-target core on top.
> > 
> > You probably should not get into aborts though... Does the I/O complete?
> > or does it fail?
> 
> The IOs complete
> 
> > 
> > Is this upstream? is [1] applied?
> > 
> > I could come up with some queue-full handling in isert that will be more
> > lightweight, but I'd let Nic make a judgment call before I do anything.
> > 
> > [1]:
> > commit a4467018c2a7228f4ef58051f0511bd037bff264
> > Author: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> > Date:   Sun Oct 30 17:30:08 2016 -0700
> > 
> >      iscsi-target: Propigate queue_data_in + queue_status errors
> > 
> 
> Yes, the patch is applied.
> 

Just to confirm, the following four patches where required to get
Potnuri up and running on iser-target + iw_cxgb4 with a similarly small
number of hw SGEs:

7a56dc8 iser-target: avoid posting a recv buffer twice
555a65f iser-target: Fix queue-full response handling
a446701 iscsi-target: Propigate queue_data_in + queue_status errors
fa7e25c target: Fix unknown fabric callback queue-full errors

So Did you test with Q-Logic/Cavium with RoCE using these four patches,
or just with commit a4467018..?

Note these have not been CC'ed to stable yet, as I was reluctant since
they didn't have much mileage on them at the time..

Now however, they should be OK to consider for stable, especially if
they get you unblocked as well.









--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
