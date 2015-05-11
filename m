From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 04/14] xprtrdma: Use ib_device pointer safely
Date: Mon, 11 May 2015 18:26:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FCE01F@ORSMSX109.amr.corp.intel.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net>
 <20150504175720.3483.80356.stgit@manet.1015granger.net>
 <554B37CF.2070206@dev.mellanox.co.il>
 <E1ADA91B-45DA-46B6-A114-E2600613969A@oracle.com>
 <554B6F2A.6000608@dev.mellanox.co.il>
 <BDE22240-DC37-4C54-B71E-D88EF54D3119@oracle.com>
 <554B80B7.8090900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554B80B7.8090900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > ia->ri_device is never updated. The only place it is set is in
> > rpcrdma_ia_open().
> 
> So you assume that each ri_id that you will recreate contains the
> same device handle?
> 
> I think that for ADDR_CHANGE event when the slave belongs to another
> device you will hit a mismatch. CC'ing Sean for more info...

I'm not familiar with the xprtrdma code.  From the perspective of the rdma_cm, if a listen is associated with a specific IP address, then it will also be associated with a specific device.  If an address change occurs, and the address moves to another device, then the app is essentially left with an unusable listen.  Received connection requests will not find a matching listen and be dropped.

If the address moves ports on the same device, then I think this works out fine in the case where the app ignores the ADDR_CHANGE event.

> > It might be saner to construct a virtual ib_device in this
> > case that consumers can depend on.
> 
> I'm not sure how does a virtual ib_device can work - that goes
> to the verbs themselves... Seems like a layering mis-match to me...

I interpreted Chuck as asking for some lower-level way of handling this, so that all ULPs don't need to re-implement this.  I agree that this would be hard (impossible?) without ULPs operating at a slightly higher level of abstraction.  Maybe the rdma_cm could be extended for this purpose, for example, by exposing its own devices, which either map directly to a verbs device, or handle a virtual mapping.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
