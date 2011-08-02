From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Tue, 02 Aug 2011 19:00:03 -0400
Message-ID: <DE779D97-F54F-45E4-B3D4-DBEB10F9302D@ornl.gov>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1828884A29C6694DAF28B7E6B8A82373136F962C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Aug 2, 2011, at 5:25 PM, Hefty, Sean wrote:

>> If the target QP is opened in low level driver, then it's owned by group of
>> processes that share the same XRC domain.
> 
> Can you define what you mean by 'owned'?
> 
> With the latest patches, the target qp is created in the kernel.  Data received on the target qp can go to any process sharing the associated xrc domain.  However, only the creating process is permitted to modify the qp.

Owned - the group of process may use the tgt qp to receive data.
So it seems that we are on the same page here.

BTW, did we have the same limitation/feature (only creating process is allowed to modify) in  original XRC driver ?


> 
>> And , as I mentioned in the reply to Jack, I totally agree that maximum life
>> time of target QP is bound to XRC domain life time,
> 
> This is the main point I was trying to get agreement on from the MPI developers, and it appears that everyone agrees now.

Indeed.

> 
>> even so it should be a way to destroy the QP before XRC domain distraction.
> 
> This is also doable with the latest patches.  The process which creates the tgt qp has the ability to explicitly destroy it.

Hmm, is it way to destroy the QP, when the original process does not exist anymore ?
Some MPI implements network fall tolerance mechanisms over IB. It means that if QP (or device) enters to error state it should be a way to destroy the  specific QP and open new one.


> 
>> main point is that the target qp should be maintained by low level driver and
>> not specific MPI process (like send qp)
> 
> As with 'owned', can you clarify what you mean by 'maintained'?
> 
> The target qp can continue to exist even after the creating process exits.

This is what I was talking about.


Regards,
P--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
