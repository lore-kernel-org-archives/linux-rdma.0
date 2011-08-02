From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Tue, 2 Aug 2011 13:44:24 +0300
Message-ID: <201108021344.25284.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <AE625966-FD97-4DBF-A024-22B83B5F3E39@ornl.gov> <1828884A29C6694DAF28B7E6B8A82373136F9194@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373136F9194-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday 01 August 2011 21:28, Hefty, Sean wrote:

>From Pavel Shamis:
> > We do have unregister on finalization. But this code doesn't introduce any
> > synchronization across processes on the same node, since kernel manages the
> > receive qp. If the reference counter will be moved to app responsibility, it
> > will enforce the app to mange the reference counter on app level , in other
> > words , it will require some process to be responsible for the QP. In context
> > of MPI-2 dynamics, such approach will make  MPI community live much more
> > complicated.
> 
Why can't the server allocate a new domain per job?  Who creates the target QP? -- can't the
target QP creator create the domain (instead of the server), and provide the domain handle to the server? 
Once the calculation gets started (with other clients opening that domain and
creating XRC SRQs to receive messages via the TGT QP,
the TGT QP creator can dealloc the xrc domain and exit (without destroying the TGT QP).
The xrc domain will not actually be deallocated in the low-level driver until all XRC SRQ clients
also dealloc the domain (reducing its reference count to zero).
At that point, all the domain's TGT QPs will be destroyed as well.

We would, in fact, use opening/allocating the XRC domain, which is done anyway, instead of registering
"interest" in a specific TGT QP, as the means of controlling target QP lifetime.

Is this an option?
-Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
