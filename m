From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: Launchpad linux-rdma group and rdma-core daily builds
Date: Tue, 07 Nov 2017 17:20:58 +0100
Message-ID: <1510071658.32330.18.camel@profitbricks.com>
References: <1510062606.32330.13.camel@profitbricks.com>
         <20171107155838.GE21466@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107155838.GE21466-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 07.11.2017, 08:58 -0700 schrieb Jason Gunthorpe:
> On Tue, Nov 07, 2017 at 02:50:06PM +0100, Benjamin Drung wrote:
> 
> > The package was built successfully for Ubuntu 16.04 (xenial) and
> > newer.
> > The build fails for Ubuntu 14.04 (trusty) due to the missing
> > libsystemd-dev package.
> 
> Yes, to build on trusty a patch to the control file would be needed..
> 
> IIRC libsystemd-dev is called something else on trusty.
> 
> I am fine not building on trusty.
> 
> What can be done if developers join the launchpad group?

You can change the description of the team, adjust subscriptions (e.g.
once rdma-core is in Ubuntu, linux-rdma could subscribe to the bug
reports), create new PPAs, adjust the daily build recipe (e.g. trigger
builds, add/remove series), configure the rdma-core project (e.g.
description, create series and milestones). I am not sure which of the
listed things need administrator permission.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
