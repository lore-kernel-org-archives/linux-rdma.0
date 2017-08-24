From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 0/3] Add congestion control capability
Date: Thu, 24 Aug 2017 17:25:08 -0400
Message-ID: <1503609908.78641.62.camel@redhat.com>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
         <20170822123246.GX1724@mtr-leonro.local>
         <20170822151143.GB1201@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822151143.GB1201-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-22 at 09:11 -0600, Jason Gunthorpe wrote:
> On Tue, Aug 22, 2017 at 03:32:46PM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 22, 2017 at 07:49:44AM -0400, Devesh Sharma wrote:
> > > This patch series is to support congestion control capability
> > > on Broadcom NetXtreme-E 10/25/40/50 RDMA Ethernet Controllers.
> > > 
> > > The implementation exposes congestion control related parameters
> > > to administrator using configfs.
> > > 
> > 
> > We have RDMAtool and netlink for configurations now, please use it.
> 
> Yes, +1

Indeed.  I'm putting this version out to pasture as "Changes
Requested".

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
