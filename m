From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Tue, 26 Jul 2011 16:04:33 -0400
Message-ID: <26AE60A9-D055-4D40-A830-5AADDBA20ED8@ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106230935.07425.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F63B9@ORSMSX101.amr.corp.intel.com>
 <201107211038.23000.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F6691@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1828884A29C6694DAF28B7E6B8A82373136F6691-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please see my notes below.

>>> I've tried to come up with a clean way to determine the lifetime of an xrc
>> tgt qp,\
>>> and I think the best approach is still:
>>> 
>>> 1. Allow the creating process to destroy it at any time, and
>>> 
>>> 2a. If not explicitly destroyed, the tgt qp is bound to the lifetime of the
>> xrc domain
>>> or
>>> 2b. The creating process specifies during the creation of the tgt qp
>>> whether the qp should be destroyed on exit.
>>> 
>>> The MPIs associate an xrc domain with a job, so this should work.
>>> Everything else significantly complicates the usage model and
>> implementation,
>>> both for verbs and the CM.  An application can maintain a reference count
>>> out of band with a persistent server and use explicit destruction
>>> if they want to share the xrcd across jobs.
>> I assume that you intend the persistent server to replace the reg_xrc_rcv_qp/
>> unreg_xrc_rcv_qp verbs.  Correct?
> 
> I'm suggesting that anyone who wants to share an xrcd across jobs can use out of band communication to maintain their own reference count, rather than pushing that feature into the mainline.  This requires a code change for apps that have coded to OFED and use this feature.


Actually I think it is really not so good idea manage reference counter  across OOB communication. 

Few years ago we had a long discussion among OFED and MPI communities (HP MPI, Intel MPI, Open MPI, Mvapich) about XRC interface definition in OFED.
All of us agreed about the interface that we have today and so far we have not heard about any complains. 
I don't say that it is ideal interface, but I would like to clarify motivation behind the idea of XRC and XRC API that we have today.

The purpose of XRC is to decrease the amount of resources (QPs) that are required for user level communication between multicore nodes. The primary customer of this protocol is middleware HPC software and MPI specifically (but not only). The original intend was to allow to share single receive QP between multiple in-depended processes on the same node.
In order to manage the single resource between multiple process couple of options have been discussed:

1. OOB synchronization on MPI level.
Pros:
- It makes life easier for verbs developer :-)

Cons:
- All MPIs will have to implement the same OOB synchronization mechanism. 
Potentially it adds a lot of overhead and synchronization code to MPI implementation, and to be honest, we already have more than 
enough MPI code that tries to workaround open fabrics API limitations. As well it will make MPI2 dynamic process management much more complicated.

- By definition the XRC QP is owned  by group of processes, that share the same XRC domain, consequently VERBS API
should provide usable API that will allow group management for XRC QP. Luck of such API makes
XRC problematic for integration to HPC communication libraries.

2. Reference counter on verbs level.   

Cons:
- Probably it will make life more complicated for verb developer. 
( Even so, it is not relevant anymore, since the code already exist and no new code development is required )

Pros:
- This solution does not introduce any additional overhead for MPI implementation. 
We have elegant increase/decrease call that manages the reference counter and alows efficient XRC QP management without any extra overhead. 
As well it does not require any special code for MPI-2 dynamic process management.


Obviously, we decided to go with option #2. As result XRC support was easily adopted by multiple MPI implementation. 
And as I mentioned earlier, we haven't heard any complaints.

IMHO, I don't see a good reason to redefine existing API.
I afraid, that such API change will encourage MPI developers to abandon XRC support.

My 0.02$

Regards,

Pavel (Pasha) Shamis
---
Application Performance Tools Group
Computer Science and Math Division
Oak Ridge National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
