From: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [RFC] RDMA CM + XRC, take two
Date: Fri, 13 May 2011 08:16:45 +0200
Message-ID: <984CAD75-D012-4725-B294-99B1AF32E49B@systemfabricworks.com>
References: <4DC86BB2.1020002@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373F23B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373F23B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some comments but first I  glad this is getting attention

Frank managed to get xrc to work with user space rdmacm without any changes to ibcm. This probably depends on faking ibcm into acting like it is connecting an rc qp but it just worked

After trying to combine srqn exchange with req/rep I think it should be separate. As you also seem to do.

The typical use case foe xrc is for lots of related processes on each node. In this case it would be helpful to cache these to avoid P^2 effects. The CM seems like a nice place to do this. The usual problem is knowing when to stop.

I'm not thrilled with 3. Seems to me like these concepts don't merge well.
The idea behind the implementation is to let apps use the file system permissions to control who can join. Whatever we do has to preserve this.

My thumbs are wearing out more later

Bob

Sent from my iPhone

On May 13, 2011, at 12:33 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> The big hack is that the SRQ number needs to be transmitted to the remote
>> side. This patch hijacks the private data, so it's not acceptable. Ideally the SRQ
>> number should be transmitted either in the REQ or REP packet (depending
>> on which side the sender or the receiver) alongside the QP number. But that
>> would need a change in the specs. Any suggestions ?
>> 
>> Also a good chunk of the patch is to deal with the XRC verbs API. I wonder
>> whether XRC could/should be more integrated into the existing verbs:
>> - sender should not need a domain,
>> - there should be 2 types of xrc QPs (send and receive) instead of one,
>> - *_xrc_rcv_qp verbs should be abstracted under the cover in libibverbs,
> 
> I've spent some time reading over the XRC patches in Roland's git tree and the XRC patches to OFED's version of libibverbs.  These are some of the ideas that I've jotted down to support XRC through the librdmacm and mainline libibverbs, in no specific order.   (There may very well be implementation issues with these.)
> 
> 1. The IB CM needs to be updated to connect XRC INI QPs to XRC TGT QPs.  This should be fairly simple.
> 
> 2. As mentioned, there's no standard way of obtaining the SRQN.  I will submit a comment to the IBTA on this.  My recommendation will be to use the IB CM SIDR protocol.
>    2a. As an optimization, the IB CM REP could optionally return an SRQN in the EECN.
>    2b. It may be useful if the SIDR REQ carried the XRC INI/TGT QPNs
> 
> 3. I don't see an easy way to hide the 'XRC domain'.  However, if I look at the existing libibverbs and librdmacm APIs, it may be simpler for the user and API compatibility if it were abstracted behind a PD (struct ibv_pd).  For example, a kernel XRC domain could be created the first time an XRC object is allocated on a PD.  In order to share an XRC domain among multiple processes, we would need a new call (ibv_share_pd?  ibv_modify_pd?).
> 
> 4. There doesn't seem to be a strong reason to expose the XRC TGT QP to user space.  A kernel XRC component could accept and manage XRC target connections.
> 
> 5. Assuming that XRC TGT QP is not exposed, libibverbs would use IBV_QPT_XRC only as the send side QP.  In order to support this QPT through the librdmacm, we would need to know what port space XRC QPs use, to know what SID range to map to, if any.  I will submit a comment to the IBTA on how XRC makes use of the RDMA IP CM Service.
> 
> 6.  The XRC SRQ is more troubling to fit under the existing APIs.  The one idea I had was to treat the XRC SRQ as a QP (struct ibv_qp) rather than like an SRQ (struct ibv_srq).  This would require defining an IBV_QPT_SRQ type.  The SRQN ends up being a QPN for all purposes, though I don't know if this would cause other issues if the SRQNs and real QPNs overlap.
> 
> 
> With these changes, the librdmacm usage model would be:
> 
> Passive side:
>    rdma_create_ep()  /* qp_type = IBV_QPT_SRQ */
>    rdma_listen()  /* listen for SIDR REQ */
>    rdma_get_cm_event()
>    rdma_accept()
> 
> Active side:
>    rdma_getaddrinfo() /* qp_type = IBV_QPT_XRC */
>    rdma_create_ep()
>    rdma_connect() /* connects to XRC TGT QP */
> 
>    rdma_getaddrinfo() /* qp_type = IBV_QPT_SRQ */
>    rdma_create_ep()
>    rdma_connect() /* resolves XRC SRQN */
> 
> This doesn't include code necessary to share the 'XRC domain' among multiple processes on the passive side.  On the passive side, the kernel XRC component would respond to IB CM REQs based on whether there was an associated SRQ listen.
> 
> I realize this model would deviate from the OFED libibverbs APIs, but I don't want to break the librdmacm ABI, or necessarily add an entire new set of APIs just to support XRC.
> 
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
