From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 03/11] IB/core: Change ah_attr.dlid from 16 to 32 bits
Date: Thu, 8 Dec 2016 23:19:01 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0BCCEC@ORSMSX109.amr.corp.intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BCAD7@ORSMSX109.amr.corp.intel.com>
 <9400a611-e37a-3e1f-2233-5650b4856831@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9400a611-e37a-3e1f-2233-5650b4856831-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I don’t like the overloading of the term 'lid' to sometimes mean a
> 16-bit value and other times a 32-bit value, with no way of
> distinguishing which one we have.  Maybe we need to call out a version
> (lidv2 = 32-bits) or carry the size.  I don't have a strong idea here.
> But when looking at this patch, lid is re-defined to u32, then nearly
> everywhere cast back to u16, which looks questionable.
> The intention was to not cause too many changes to the underlying
> drivers when the lid field was increased. Casting was a simpler
> approach.

The problem is this is how most of the stack has evolved, and the resulting architecture is a mess.  This is fundamentally changing the definition of what a LID is.
 
For example, why stop at 4 bytes?  Why not let the LID store a MAC address?

At some point we need to deal with the fact that we have devices that support completely different L2, L3, and/or L4 addresses.  And even where the addresses are the same size, they aren't from the same domain.

Does anyone know how the net stack handles this?  Are we looking at an array of bytes + length?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
