From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] debian: Update changelog to include
 Debian upload
Date: Wed, 15 Nov 2017 10:23:51 +0100
Message-ID: <1510737831.4026.59.camel@profitbricks.com>
References: <20171114113330.2715-1-benjamin.drung@profitbricks.com>
         <20171114113330.2715-4-benjamin.drung@profitbricks.com>
         <20171114202823.GQ4263@ziepe.ca>
         <1510691646.4026.50.camel@profitbricks.com>
         <20171114204244.GU4263@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114204244.GU4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 14.11.2017, 13:42 -0700 schrieb Jason Gunthorpe:
> On Tue, Nov 14, 2017 at 09:34:06PM +0100, Benjamin Drung wrote:
> 
> > I can often find debian packaging from upstream projects that
> > either
> > use their complete own packaging or a very outdated fork of the
> > packaging from Debian.
> 
> But it creates a technical problem, eg now that you are going to make
> a -2, where will the changelog commit go?

When all commits for -2 are accepted in the master branch, I would
update debian/changelog to have the 15-2 entry between 15-1 and 16-1.

An alternative would be to just have one changelog entry in the master
branch and document the basis, e.g.:

rdma-core (16-1) unstable; urgency=low

  * New upstream release.
  * Packaging is based on rdma-core 15-2 from Debian
  * Downgrade debhelper to >= 9 to support Debian 7 & 8

 -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Tue, 14 Nov 2017 12:24:09 +0100

> Ideally the changelog commit should match the actual git tree that
> was
> used to produce the debian source tar ball. Otherwise things start to
> get very confusing :)
> 
> Jason
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
