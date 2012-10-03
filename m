From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: APM support for IPoIB
Date: Wed, 3 Oct 2012 03:03:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A98B11@FMSMSX151.amr.corp.intel.com>
References: <506A17EA.8080400@oracle.com>
 <20121001235303.GH22342@obsidianresearch.com> <506A2F01.8000605@oracle.com>
 <CAL1RGDWmywbGg0vVb_MqRCHbdgMCZTGN5Y-dX6NkpWRB6P23ug@mail.gmail.com>
 <CD250C48050CFB4D95E78C95F2FDDD6E87470513@MTLDAG01.mtl.com>
 <506B8365.9010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506B8365.9010507-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bang Nguyen <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Just a crazy thought but IPoIB could use RDMA-CM for all of its
> connection management stuff..this way it can leverage the APM support in
> RDMA-CM..
> 
> comments?...

ipoib predates the rdma cm, which is why it's written to the ib_cm directly.  Communication setup with the rdma cm follows these 3 steps.

1. address resolution - The rdma cm indirectly ends up using ipoib for this.  With ipoib, this step isn't necessary.  I think having AF_IB support would help this by avoiding this step, plus it restricts the rdma cm to using IB devices.
2. route resolution (aka path record query) - Ipoib maintains its own path record cache.  It can set the rdma cm paths manually, or there would need to be some sort of rework.
3. connection setup - formats the ib cm private data and exchanges messages.  The rdma cm would need to know the ipoib private data format.

Sooo... ipoib wouldn't use address resolution.  It maintains its own path record cache, which is a significant piece of supporting APM.  Ipoib probably doesn't need to maintain its own cache, but there's no decent alternative for kernel clients currently.  And connection setup using the rdma cm is only slightly easier than using the ib cm.  (I have no idea what APM support in the rdma cm looks like.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
