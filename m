From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 3 Aug 2011 15:36:43 -0600
Message-ID: <20110803213642.GE28465@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373136F9194@ORSMSX101.amr.corp.intel.com>
 <EABE213A-448A-45F8-B131-AE1EE3F9547F@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F962C@ORSMSX101.amr.corp.intel.com>
 <DE779D97-F54F-45E4-B3D4-DBEB10F9302D@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F967E@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA4622F4@EXCHMB.ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F97AC@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA462300@EXCHMB.ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9A13@ORSMSX101.amr.corp.intel.com>
 <5C691E518F345F4882FAB9E9839E60BA0BCA462301@EXCHMB.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5C691E518F345F4882FAB9E9839E60BA0BCA462301-vxojlfkN5A++qDdrU24kdQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 03, 2011 at 05:16:17PM -0400, Shamis, Pavel wrote:
> > 
> > > Well, in Open MPI we have XRC code that uses APM.
> > > If Mellanox cares about the feature, they would have to rework this part of
> > > code in Open MPI.
> > > I don't know about other apps.
> > 
> > But does the APM implementation expect some other process other than
> > the creator to be able to modify the QP?
> 
> It was long time ago and I do not remember all the details. From
> first glance it seems that it is not bounded to specific process.  I
> would suggest to Mellanox to review this par of code.

I'd say a basic starting point would be this question:

Where does the ib_verbs async event for APM state change get routed for
XRC? Does the event have enough info to identify all the necessary
parts? Can the process that receives the event do something about it?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
