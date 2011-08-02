From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Tue, 02 Aug 2011 15:08:57 -0400
Message-ID: <EABE213A-448A-45F8-B131-AE1EE3F9547F@ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106230935.07425.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F63B9@ORSMSX101.amr.corp.intel.com>
 <201107211038.23000.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F6691@ORSMSX101.amr.corp.intel.com>
 <26AE60A9-D055-4D40-A830-5AADDBA20ED8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9075@ORSMSX101.amr.corp.intel.com>
 <AE625966-FD97-4DBF-A024-22B83B5F3E39@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9194@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1828884A29C6694DAF28B7E6B8A82373136F9194-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> We do have unregister on finalization. But this code doesn't introduce any
>> synchronization across processes on the same node, since kernel manages the
>> receive qp. If the reference counter will be moved to app responsibility, it
>> will enforce the app to mange the reference counter on app level , in other
>> words , it will require some process to be responsible for the QP. In context
>> of MPI-2 dynamics, such approach will make  MPI community live much more
>> complicated.
> 
> I'm not sure we're fully communicating here.  I understand the usage model for xrc.

Ok.

> 
> The basic problem is determining the lifetime of the xrc target qp.  One process creates the xrc target qp.  A process also owns connecting the target qp.  Any process can create the xrc domain.

If the target QP is opened in low level driver, then it's owned by group of processes that share the same XRC domain.
And , as I mentioned in the reply to Jack, I totally agree that maximum life time of target QP is bound to XRC domain life time,
even so it should be a way to destroy the QP before XRC domain distraction. My main point is that the target qp should be maintained by low level driver and not specific MPI process (like send qp)

Regards,

Pasha--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
