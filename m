From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Tue, 02 Aug 2011 12:29:18 -0400
Message-ID: <32D25205-3E9C-4757-B0AB-7117BDF3F2F7@ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <AE625966-FD97-4DBF-A024-22B83B5F3E39@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9194@ORSMSX101.amr.corp.intel.com>
 <201108021344.25284.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201108021344.25284.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jack,
Please see my comments below

> From Pavel Shamis:
>>> We do have unregister on finalization. But this code doesn't introduce any
>>> synchronization across processes on the same node, since kernel manages the
>>> receive qp. If the reference counter will be moved to app responsibility, it
>>> will enforce the app to mange the reference counter on app level , in other
>>> words , it will require some process to be responsible for the QP. In context
>>> of MPI-2 dynamics, such approach will make  MPI community live much more
>>> complicated.
>> 
> Why can't the server allocate a new domain per job?  Who creates the target QP? -- can't the
> target QP creator create the domain (instead of the server), and provide the domain handle to the server? 

XRC domain is created by process that starts first.  All the rest processes, that belong to the same mpi session and reside on the same node, join the domain. 
TGT QP is created by process that receive inbound connection first and it is not necessary the same process that created the domain. Even so we assume that both processes belong to the same domain, and belong to the same mpi session.

> Once the calculation gets started (with other clients opening that domain and
> creating XRC SRQs to receive messages via the TGT QP,
> the TGT QP creator can dealloc the xrc domain and exit (without destroying the TGT QP).
> The xrc domain will not actually be deallocated in the low-level driver until all XRC SRQ clients
> also dealloc the domain (reducing its reference count to zero).
> At that point, all the domain's TGT QPs will be destroyed as well.

Does it mean that TGT QP as well is allocated on low level driver ? If so, I have no problem with this approach.


> 
> We would, in fact, use opening/allocating the XRC domain, which is done anyway, instead of registering
> "interest" in a specific TGT QP, as the means of controlling target QP lifetime.
> 
> Is this an option?

Sure, sounds good.

Regards,

Pasha--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
