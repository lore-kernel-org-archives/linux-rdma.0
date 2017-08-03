From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Thu, 03 Aug 2017 15:23:28 +0200
Message-ID: <1501766608.3581.6.camel@profitbricks.com>
References: <1501590709.2725.10.camel@redhat.com>
         <20170801200846.GA3808@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801200846.GA3808-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 01.08.2017, 14:08 -0600 schrieb Jason Gunthorpe:
> On Tue, Aug 01, 2017 at 08:31:49AM -0400, Doug Ledford wrote:
> 
> > This is a little bit late, so it would be best to keep -rc cycles
> > on it
> > to a minimum and get the final version pushed out soon.  With the
> > "excitement" of this last release cycle/merge window, this slipped
> > my
> > mind.  My apologies.
> 
> Benjamin,
> 
> What more do you need in this release to start submitting to to the
> debian archive?

I am waiting for the common udev/systemd based module auto loading
support (#174) to be merged to master and the release of v15.

> #174 wasn't merged yet, and there is one more minorish patch needed
> to
> rework the systemd targets.
> 
> Are you OK with taking those last few things at this point?

Since #174 is a bigger patch set, I prefer to have it merged before the
release of version 15 (but I can ship it as patches in the packaging if
you want to get v15 out of the door). Shipping following more minorish
patches as patches to the packaging is fine for me.

IMO #174 is ready to be merged to master. I still have problems with
bringing up IPoIB InfiniBand partitions (see other topic), but that can
be resolved afterwards (if that is really caused by rdma-core).

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
