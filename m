From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for datagram mode
Date: Tue, 28 Aug 2012 19:35:01 +0300
Message-ID: <CAJZOPZJWGWO7vXtKhv_UFp8hdtApWsAKCeduksMJti03i1=DEg@mail.gmail.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg@mail.gmail.com>
	<CAJZOPZJL+qhk4CcUpmXffrTsS85fMJtxvuQePzpjN902Eg5h5g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A30177@ORSMSX101.amr.corp.intel.com>
	<CACZyyF8o1ift2-rkV6yL7EM_iys2kWHJ=ZHNe2xMihu4jSW5+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACZyyF8o1ift2-rkV6yL7EM_iys2kWHJ=ZHNe2xMihu4jSW5+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 13, 2012 at 5:27 PM, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
> Sean =96 thanks for the feedback.
> Reg the XRC semantics and object model:

Sean,

Can you let us know your thoughts here?

Or.

> - XRC domain object allows many to many mappings where multiple XRC
> TGT QPs and multiple XRC SRQs can be mapped to each other, thus a
> notion of domain needs to be creates to define such group. With
> RSS/TSS we only have many to one mapping where child QPs are mapped
> directly to single parent. The RSS indirection table defines which
> child QP will receive the ingress, there=92s no remote mapping contro=
l
> like in the XRC case where the initiator defines the destination
> receive queue.
> - The XRC protection domain attribute was established to allow
> verification of a match between the destined XRC TGT QP and the
> targeted XRC SRQ, with RSS/TSS we don=92t enforce such a match.
> From the above reason=92s we didn=92t find justification for creating=
 yet
> another new object =96 RSS/TSS domain.
>
> Reg ib_qp_init_attr and ib_qp_type, since RSS/TSS child/parent
> attributes can be defined for multiple QP types (today IB_QPT_UD and
> IB_QPT_RAW_PACKET), we believe it is cleaner to have another attribut=
e
> of ib_qpg_type.
>
> Reg ib_open_qp() and sharing the parent QP across multiple process,
> currently we don=92t support it, user mode API will provide RSS/TSS
> parent QP creation and children in user space in the same process.
> Having said that, we may add such support in future and current schem=
e
> allows such future expansion where RSS/TSS parent QP may be defined a=
s
> shared, where in such case it will be allocated in kernel using the
> open_qp semantics and may use shared protection domain to do so.
>
> Tzahi
>
>
> On Tue, Jun 12, 2012 at 11:44 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> =
wrote:
>>> Do you have something more specific re how to actually align (say) =
the
>>> RSS QP group into the framework used by XRC?
>>
>> Not really.  That was more of a conceptual statement regarding the d=
esign.  The operation, particularly on the receive side, just seems sim=
ilar.
>>
>> I don't think we should force a fit if it doesn't, but what's missin=
g from the XRC framework to support RSS?
>>
>> I guess more specifically, if I look at the changes to ib_verbs.h, c=
an we avoid the changes to ib_qp_init_attr and ib_qp?  I.e. why can't t=
he qp_type indicate the type of group, or why couldn't ib_open_qp() be =
used?  Should the associated QPs share some sort of common protection d=
omain, like an XRCD, to provide some security on sharing the underlying=
 QP across processes?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
