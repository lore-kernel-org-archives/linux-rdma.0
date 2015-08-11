From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Tue, 11 Aug 2015 12:47:03 +0000
Message-ID: <HE1PR05MB1418DE9D40F9B2B20FD1AC3BB17F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
 <1438697008-26209-7-git-send-email-yishaih@mellanox.com>
 <20150804220903.GE10934@obsidianresearch.com>
 <55C22739.5060808@dev.mellanox.co.il>
 <20150805182117.GA15583@obsidianresearch.com>
 <HE1PR05MB1418EA195D579C09EB1FB746B1740@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20150811054852.GC13314@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150811054852.GC13314-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> 
> It does if you want a planned 'gental' removal to be possible..
> 

There could be a lot of design options for a 'gentle' removal, such as first sending a 'prepare' event, and only then doing the flow proposed here.
I do not want to address this now.

> > When you do a surprise removal, you disconnect the application from
> > both ucma and uverbs device references.  In this state, the only
> > thing that the application can do is close all handles.  It doesn't
> > matter if you succeed closing a resource on a device that is still
> > accessible, or "close" an already destroyed resource...
> 
> Hurm. That makese sense, but that isn't entirely what this patch set
> does - it is rough when facing the user, but the kernel side is
> actually quite gental.. Ie the RDMA CM still sends GMPs on this
> shutdown path.. Looks like the various storage ULP shutdowns are
> pretty gental too.
> 

Right.
Kernel removal is always gentle, because kernel ULPs are trusted to close within a finite time.

> As an example, I think it is important, if you
> want to hot-unplug a storage controller the admin expects a clean
> storage shutdown. I think in-kernel storage drivers do that
> already. IB shouldn't really be much different.
> 

If a storage stack has user-space components, then our future 'gentle' closing will take care of that.

> > Anyway, let's get this patch-set done.
> 
> Still needs to have the locking fixed..

As pointed out (https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg27023.html), this "barrier" scheme is used in several places including in the RDMA stack.
If there is no functional issue with the code, we can discuss how to address this scheme systematically later.

--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
