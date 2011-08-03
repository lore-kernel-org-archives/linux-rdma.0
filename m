From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Wed, 03 Aug 2011 09:47:04 -0400
Message-ID: <5C691E518F345F4882FAB9E9839E60BA0BCA4622F4@EXCHMB.ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106230935.07425.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F63B9@ORSMSX101.amr.corp.intel.com>
 <201107211038.23000.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F6691@ORSMSX101.amr.corp.intel.com>
 <26AE60A9-D055-4D40-A830-5AADDBA20ED8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9075@ORSMSX101.amr.corp.intel.com>
 <AE625966-FD97-4DBF-A024-22B83B5F3E39@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9194@ORSMSX101.amr.corp.intel.com>
 <EABE213A-448A-45F8-B131-AE1EE3F9547F@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F962C@ORSMSX101.amr.corp.intel.com>
 <DE779D97-F54F-45E4-B3D4-DBEB10F9302D@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F967E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1828884A29C6694DAF28B7E6B8A82373136F967E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > BTW, did we have the same limitation/feature (only creating process is
> allowed
> > to modify) in  original XRC driver ?
> 
> I'm not certain about the implementation, but the OFED APIs would allow
> any process within the xrc domain to modify the qp.
> 
> > Hmm, is it way to destroy the QP, when the original process does not exist
> > anymore ?
> 
> The only way to destroy the tgt qp after the creating process exits is for the
> xrc domain to be destroyed.  Jack and I have discussed the possibility of
> having the kernel destroy the qp on error or ib cm disconnect.  I'm not sure
> how likely it would be for a tgt qp will enter the error state.  If it's possible
> under a fairly normal use case, I'll start on a separate patch to handle that
> case.
> 

Well, actually I was thinking about APM. If the "creator" exits, we do not have a way to
upload alternative path.
 

> > Some MPI implements network fall tolerance mechanisms over IB. It
> means that
> > if QP (or device) enters to error state it should be a way to destroy the
> > specific QP and open new one.
> 
> Note that a tgt qp should consume minimal resources, so it may not be a big
> deal to just leave it around.  A new qp can be connected regardless.
>

Agree.

Regards,
Pasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
