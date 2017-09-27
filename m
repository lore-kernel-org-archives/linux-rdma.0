From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Wed, 27 Sep 2017 09:23:15 -0400
Message-ID: <1506518595.82712.13.camel@redhat.com>
References: <1505842717-26646-1-git-send-email-Michal.Kalderon@cavium.com>
         <20170919174721.GL5788@mtr-leonro.local>
         <CY1PR0701MB2012B48FC05034ED663DB1D188610@CY1PR0701MB2012.namprd07.prod.outlook.com>
         <1a07af53-0729-956e-129c-2c914e0e3d0c@intel.com>
         <20170926061005.GD1230@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926061005.GD1230-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 09:10 +0300, Leon Romanovsky wrote:
> On Mon, Sep 25, 2017 at 08:29:58AM -0400, Dennis Dalessandro wrote:
> > On 9/20/2017 1:42 AM, Kalderon, Michal wrote:
> > > From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Sent: Tuesday, September 19, 2017 8:47 PM
> > > 
> > > On Tue, Sep 19, 2017 at 08:38:37PM +0300, Michal Kalderon wrote:
> > > > > Initialize the rdma_type (iWARP or RoCE) which is set
> > > > > according to
> > > > > device configuration in qed.
> > > > > 
> > > > > Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > > > Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > > > ---
> > > > 
> > > > Please add Fixes.
> > > > 
> > > > Thanks
> > > 
> > > sure, i'll send v1
> > 
> > Does just responding with a "Fixes" tag get appended automagically
> > by
> > Patchworks?
> 
> I don't think so, but let's check with fixes line from v1.
> Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an iWARP
> device")

Patchworks does, in fact, add the Fixes: line (although not in the
format we normally tell people to use as there is empty space between
the Fixes: line and the start of the Signed-off-by: lines).

However, that's all irrelevant, as this patch breaks the build for me. 
Is there a prerequisite patch in net-next for this?

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
