From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] IB: merge struct ib_device_attr into struct ib_device
Date: Sun, 11 Oct 2015 18:24:30 +0200
Message-ID: <20151011162430.GA6450@lst.de>
References: <1443023567-13259-1-git-send-email-hch@lst.de> <1443023567-13259-2-git-send-email-hch@lst.de> <8BE4B1B3-54CD-46D1-9BBD-9149F6219468@oracle.com> <20150923184106.GA7759@lst.de> <56038CFD.8030908@mellanox.com> <20150924133519.GA6291@lst.de> <561A8B5B.1010309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561A8B5B.1010309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 11, 2015 at 07:16:27PM +0300, Sagi Grimberg wrote:
> Christoph, would you mind rebasing it on top of 4.3-rc4 or so? I
> want to develop over it so I can test it on the fly.

I can do a rebase to whatever you want.  Initially this was
over your reg_api branch.  Is a rebase to the latest reg_api.6
fine?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
