From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 3 Aug 2011 22:05:03 -0600
Message-ID: <20110804040503.GA13935@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373136F962C@ORSMSX101.amr.corp.intel.com>
 <DE779D97-F54F-45E4-B3D4-DBEB10F9302D@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F967E@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA4622F4@EXCHMB.ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F97AC@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA462300@EXCHMB.ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9A13@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA462301@EXCHMB.ornl.gov>
 <20110803213642.GE28465@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373136F9A7E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373136F9A7E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 04, 2011 at 12:06:24AM +0000, Hefty, Sean wrote:
> > Where does the ib_verbs async event for APM state change get routed for
> > XRC?
> 
> The OFED APIs route QP events to all processes which register for
> that qp number.
 
?? How do you register for an event? There is only
ibv_get_async_event(3) - I thought it returned all events relevant to
the associated verbs context.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
