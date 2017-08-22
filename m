From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [for-next 0/3] Add congestion control capability
Date: Tue, 22 Aug 2017 09:11:43 -0600
Message-ID: <20170822151143.GB1201@obsidianresearch.com>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
 <20170822123246.GX1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170822123246.GX1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 22, 2017 at 03:32:46PM +0300, Leon Romanovsky wrote:
> On Tue, Aug 22, 2017 at 07:49:44AM -0400, Devesh Sharma wrote:
> > This patch series is to support congestion control capability
> > on Broadcom NetXtreme-E 10/25/40/50 RDMA Ethernet Controllers.
> >
> > The implementation exposes congestion control related parameters
> > to administrator using configfs.
> >
> 
> We have RDMAtool and netlink for configurations now, please use it.

Yes, +1

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
