From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 for-next 2/7] IB/core: Add support for idr types
Date: Wed, 05 Apr 2017 14:51:41 -0400
Message-ID: <1491418301.2923.10.camel@redhat.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
         <1491301907-32290-3-git-send-email-matanb@mellanox.com>
         <1828884A29C6694DAF28B7E6B8A82373AB10F5A5@ORSMSX109.amr.corp.intel.com>
         <CAAKD3BD=dM8B+bnGu_DTR220wWeo2ce2Sgoy1WwBpUYs6XHoQA@mail.gmail.com>
         <1491413639.2923.0.camel@redhat.com>
         <20170405174943.GI20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405174943.GI20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-05 at 20:49 +0300, Leon Romanovsky wrote:
> On Wed, Apr 05, 2017 at 01:33:59PM -0400, Doug Ledford wrote:
> > 
> > On Wed, 2017-04-05 at 13:55 +0300, Matan Barak wrote:
> > > 
> > > Thanks for the review.
> > > Regarding the simple cosmetic changes - If Doug prefers, I can
> > > send
> > > another round. However, I think integrating these patches so
> > > people
> > > could start evaluate them
> > > and send these cosmetic changes as fixups is preferrable.
> > 
> > I agree, I've pulled in the v3 patchset.  I'll push it out today
> > and
> > further changes can be incremental.
> 
> Thanks Doug,
> 
> Are you going to merge it into your for-4.12 branch? I need to know
> it,
> so I'll be able to properly build our development branches.

Well, I can't merge it into that branch because that's where I was when
I applied the patches ;-)

They've been pushed out, so you should be able to see what you need.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
