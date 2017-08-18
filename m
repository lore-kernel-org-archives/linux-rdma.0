From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user
 verbs
Date: Fri, 18 Aug 2017 12:07:45 -0400
Message-ID: <1503072465.2598.19.camel@redhat.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
         <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
         <20170628095422.GA1248@mtr-leonro.local>
         <BN3PR07MB25788193EFA21CEB5C430201F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <20170628101124.GD1248@mtr-leonro.local>
         <CY1PR0701MB1337A8E7B1E40CC4C1EC230A90DD0@CY1PR0701MB1337.namprd07.prod.outlook.com>
         <1503068404.2598.9.camel@redhat.com>
         <20170818155808.GN23648@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170818155808.GN23648-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-08-18 at 18:58 +0300, Leon Romanovsky wrote:
> On Fri, Aug 18, 2017 at 11:00:04AM -0400, Doug Ledford wrote:
> > On Wed, 2017-06-28 at 10:23 +0000, Elior, Ariel wrote:
> > > > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > > > Sent: Wednesday, June 28, 2017 1:11 PM
> > > > To: Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior,
> > > > Ariel
> > > > <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > > Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in
> > > > multiple
> > > > user verbs
> > > > 
> > > > On Wed, Jun 28, 2017 at 10:02:45AM +0000, Amrani, Ram wrote:
> > > > > > > Most user verbs pass user data to the kernel with the
> > > > > > > inclusion of the
> > > > > > > ib_uverbs_cmd_hdr structure. This is problematic because
> > > > > > > the
> > > > > > > vendor has
> > > > > > > no ideas if the verb was called by a legacy verb or an
> > > > > > > extended verb.
> > > > > > 
> > > > > > Why vendor should know about it? It has midlayer (ib/core)
> > > > > > between him
> > > > > > and user to handle it.
> > > > > > 
> > > > > 
> > > > > Knowing the inlen can be used to determine if the library is
> > > > > newer than
> > > > > the kernel and what features it supports or not.
> > > > 
> > > > It is not interesting case, because we are not breaking UAPI,
> > > > only
> > > > extending. It ensures that kernel will fill as much as possible
> > > > and
> > > > will
> > > > always have success in it. After that it is library
> > > > responsibility
> > > > to
> > > > understand if everything was filled.
> > > > 
> > > > Thanks
> > > 
> > > In our case, kernel driver needs to know whether library supports
> > > a
> > > certain
> > > feature (doorbell overflow recovery). It doesn't care if it was
> > > an
> > > extended
> > > verb or not, but it cares whether the lib is sufficiently new to
> > > have
> > > provided
> > > the required information. If the library is sufficiently new
> > > (supports) then
> > > kernel will register the library's doorbell address with the
> > > overflow
> > > recovery
> > > mechanism, and perform recovery if required, otherwise it would
> > > not
> > > (as the
> > > library is not supplying the necessary information for recovery
> > > to
> > > take place).
> > > This is not something the library needs to know, but the kernel
> > > driver. Having
> > > correct input len is required for successfully avoiding breaking
> > > the
> > > UAPI.
> > 
> > Leon, does this explanation resolve your objections?  Also, have
> > you
> > checked the mlx5/mthca portions of this patch?
> 
> Yes, let's me recheck/rerun the patch and post results.
> If for any reasons you don't hear from me till Wednesday, take it.
> 
> Thanks

Works for me, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
