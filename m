From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Fri, 29 Sep 2017 11:22:39 -0400
Message-ID: <1506698559.2919.16.camel@redhat.com>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
         <1506518845.82712.15.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506518845.82712.15.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-27 at 09:27 -0400, Doug Ledford wrote:
> On Wed, 2017-09-20 at 08:39 +0300, Michal Kalderon wrote:
> > Initialize the rdma_type (iWARP or RoCE) which is set according to
> > device configuration in qed.
> > 
> > Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an
> > iWARP
> > device")
> > 
> > Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > 
> > ---
> > This patch applies cleanly on k.o/for-next-merged
> > 
> > Changes from V0:
> > - Added Fixes in commit comment.
> 
> Sorry, I was wrong in my email to the previous posting of this
> patch. 
> I had pulled this v1 patch from patchworks, not the original patch,
> and
> so the Fixes: line was yours.  Patchworks did not add the Fixes: line
> to the v0 patch when I downloaded it just now.
> 
> That being said, I still can't build with this patch ;-)

OK, the build failure was my fault.  As this was a minor patch, I had
lumped it into a bundle I labeled as "misc".  That by itself is fine,
but I then applied that to a clean for-next head of v4.14-rc2, without
the merge of the qedr branch, and so the build failed.  Putting this
into a branch with the qedr patches already merged resolves the issue. 
So, thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
