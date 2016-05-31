From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 31 May 2016 17:56:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05CA92@ORSMSX109.amr.corp.intel.com>
References: <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
 <20160526233612.GA4396@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
 <20160527131956.GY25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05BD12@ORSMSX109.amr.corp.intel.com>
 <20160529081646.GA25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160529081646.GA25500-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I am referring to the creation of an ioctl handling framework that is suitable for use by the rdma
> cm, ib cm (if kept), verb devices, and non-verbs drivers that do not plug into the kernel verbs
> framework.  The kernel clients are the items I mentioned.  Having a common ioctl handling framework
> will maximize code reuse.
> 
> It looks too generic for RDMA subsystem. What does it make this IOCTL framework specific to RDMA?

I'm not sure how something can be too generic.  Everything I mentioned above exists as part of the RDMA subsystem.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
