From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: handling rdma apps using chroot
Date: Wed, 15 Aug 2012 19:44:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A89506@ORSMSX101.amr.corp.intel.com>
References: <SNT114-DS11B5280C71EEE30408772DADB60@phx.gbl>
 <20120815193214.GB2957@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120815193214.GB2957-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Somehow you need to open the verbs device before doing the choot.. I
> think once verbs is open there is no further need for sysfs and dev..

I could hook chroot to force this.   That should fix the /sys issue.  However, the librdmacm accesses /dev when creating an event channel, which occurs after chroot.  (Maybe that call is just hopelessly broken trying to support chroot.)

> Sounds like you are chrooting before creating the listening socket?

Correct - this is one of the results of supporting fork.  The ftp daemon listens on a normal socket, then switches to an rsocket on the first data transfer, after any fork presumably has occurred.

Btw, I've tried using symlinks and running from '/'.  The symlinks don't work, but running from '/' does for rstream.  Neither work for vsftpd, likely from other security calls that it makes.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
