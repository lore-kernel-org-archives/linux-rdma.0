From: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Mon, 01 Aug 2011 12:20:58 -0400
Message-ID: <AE625966-FD97-4DBF-A024-22B83B5F3E39@ornl.gov>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <201106230935.07425.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F63B9@ORSMSX101.amr.corp.intel.com>
 <201107211038.23000.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F6691@ORSMSX101.amr.corp.intel.com>
 <26AE60A9-D055-4D40-A830-5AADDBA20ED8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A82373136F9075@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1828884A29C6694DAF28B7E6B8A82373136F9075-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Actually I think it is really not so good idea manage reference counter
>> across OOB communication.
> 
> But this is exactly what the current API *requires* that users of XRC do!!!  And I agree, it's not a good idea. :)

We do have unregister on finalization. But this code doesn't introduce any synchronization across processes on the same node, since kernel manages the receive qp. If the reference counter will be moved to app responsibility, it will enforce the app to mange the reference counter on app level , in other words , it will require some process to be responsible for the QP. In context of MPI-2 dynamics, such approach will make  MPI community live much more complicated.

> 
>> IMHO, I don't see a good reason to redefine existing API.
>> I afraid, that such API change will encourage MPI developers to abandon XRC
>> support.
> 
> 
> The only reason reference counting was added at all was to support a questionable usage model of sharing an xrc domain across jobs.  

Well, actually it is  a primary reason why XRC was introduced in first place. XRC helps reduce number off all-to-all connections from NP^2 ( N - number of nodes, P - number of processes per node) to NP. 
You may find more details, 
here: 
http://www.open-mpi.org/papers/euro-pvmmpi-2008-xrc/euro-pvmmpi-2008-xrc.pdf
and here:
http://nowlab.cse.ohio-state.edu/publications/conf-papers/2008/koop-cluster08.pdf



> I'm suggesting that *only those apps* that want that usage model can implement it over the provided APIs.  They can continue to use OOB connections, pass XRC numbers, replace ibv_reg_recv_xrv() with atomic_inc(), and let the persistent server destroy the xrc recv qp when those processes are done.  For everyone else (and it sounds like this is really everyone at this point), there's

Who will provide this persistent server ? If verbs or some other OFED library will provide such service  + api add/remove/register QPs on such server , then I have no problem.

Regards,
Pasha.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
