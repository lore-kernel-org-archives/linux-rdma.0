From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: How to build SDP module
Date: Mon, 25 Apr 2011 10:20:13 +0200 (CEST)
Message-ID: <4066855.1303719613659.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <BANLkTikDGaucXzqN8+uotCbqLE+UFW_Djw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikDGaucXzqN8+uotCbqLE+UFW_Djw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Apr 25, 2011 10:12 AM, bhavinkumar thumar
<bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
>=20
> OFED 1.5.2 has already been installed in my system and now I want to
> build and install the sdp module of OFED after making some change in
> it.
>=20
> I tried 'configure' script in /usr/src/ofa_kernel-1.5.2/ and then gav=
e
> 'make' and 'make install' with required parameters. Then when I am
> trying to load the ib_sdp module it gives me following error:
>=20
> FATAL: Error inserting ib_sdp
>
> (/lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband/ulp/sd=
p/ib_sdp.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>=20
> I checked dmesg, it shows:
>=20
> ib_sdp: disagrees about version of symbol ib_unregister_client
> ib_sdp: Unknown symbol ib_unregister_client
> ib_sdp: disagrees about version of symbol ib_fmr_pool_unmap
> ib_sdp: Unknown symbol ib_fmr_pool_unmap
> ib_sdp: disagrees about version of symbol ib_create_cq
> ib_sdp: Unknown symbol ib_create_cq
> ib_sdp: disagrees about version of symbol rdma_resolve_addr
> ib_sdp: Unknown symbol rdma_resolve_addr
> ib_sdp: disagrees about version of symbol ib_create_fmr_pool
> ib_sdp: Unknown symbol ib_create_fmr_pool
> ib_sdp: disagrees about version of symbol ib_dereg_mr
> ib_sdp: Unknown symbol ib_dereg_mr
> ib_sdp: disagrees about version of symbol rdma_reject
> ib_sdp: Unknown symbol rdma_reject
> ib_sdp: disagrees about version of symbol rdma_disconnect
> ib_sdp: Unknown symbol rdma_disconnect
> ib_sdp: disagrees about version of symbol rdma_resolve_route
> ib_sdp: Unknown symbol rdma_resolve_route
> ib_sdp: disagrees about version of symbol rdma_bind_addr
> ib_sdp: Unknown symbol rdma_bind_addr
> ib_sdp: disagrees about version of symbol ib_register_client
> ib_sdp: Unknown symbol ib_register_client
> ib_sdp: disagrees about version of symbol rdma_create_qp
> ib_sdp: Unknown symbol rdma_create_qp
> ib_sdp: disagrees about version of symbol ib_destroy_cq
> ib_sdp: Unknown symbol ib_destroy_cq
> ib_sdp: disagrees about version of symbol rdma_create_id
> ib_sdp: Unknown symbol rdma_create_id
> ib_sdp: disagrees about version of symbol ib_set_client_data
> ib_sdp: Unknown symbol ib_set_client_data
> ib_sdp: disagrees about version of symbol rdma_notify
> ib_sdp: Unknown symbol rdma_notify
> ib_sdp: disagrees about version of symbol ib_get_client_data
> ib_sdp: Unknown symbol ib_get_client_data
> ib_sdp: disagrees about version of symbol rdma_listen
> ib_sdp: Unknown symbol rdma_listen
> ib_sdp: disagrees about version of symbol ib_query_device
> ib_sdp: Unknown symbol ib_query_device
> ib_sdp: disagrees about version of symbol ib_get_dma_mr
> ib_sdp: Unknown symbol ib_get_dma_mr
> ib_sdp: disagrees about version of symbol ib_alloc_pd
> ib_sdp: Unknown symbol ib_alloc_pd
> ib_sdp: disagrees about version of symbol rdma_connect
> ib_sdp: Unknown symbol rdma_connect
> ib_sdp: disagrees about version of symbol ib_modify_cq
> ib_sdp: Unknown symbol ib_modify_cq
> ib_sdp: disagrees about version of symbol rdma_destroy_id
> ib_sdp: Unknown symbol rdma_destroy_id
> ib_sdp: disagrees about version of symbol rdma_accept
> ib_sdp: Unknown symbol rdma_accept
> ib_sdp: disagrees about version of symbol ib_destroy_qp
> ib_sdp: Unknown symbol ib_destroy_qp
> ib_sdp: disagrees about version of symbol rdma_port_get_link_layer
> ib_sdp: Unknown symbol rdma_port_get_link_layer
> ib_sdp: disagrees about version of symbol ib_dealloc_pd
> ib_sdp: Unknown symbol ib_dealloc_pd
> ib_sdp: disagrees about version of symbol ib_unregister_client
> ib_sdp: Unknown symbol ib_unregister_client
> ib_sdp: disagrees about version of symbol ib_fmr_pool_unmap
> ib_sdp: Unknown symbol ib_fmr_pool_unmap
> ib_sdp: disagrees about version of symbol ib_create_cq
> ib_sdp: Unknown symbol ib_create_cq
> ib_sdp: disagrees about version of symbol rdma_resolve_addr
> ib_sdp: Unknown symbol rdma_resolve_addr
> ib_sdp: disagrees about version of symbol ib_create_fmr_pool
> ib_sdp: Unknown symbol ib_create_fmr_pool
> ib_sdp: disagrees about version of symbol ib_dereg_mr
> ib_sdp: Unknown symbol ib_dereg_mr
> ib_sdp: disagrees about version of symbol rdma_reject
> ib_sdp: Unknown symbol rdma_reject
> ib_sdp: disagrees about version of symbol rdma_disconnect
> ib_sdp: Unknown symbol rdma_disconnect
> ib_sdp: disagrees about version of symbol rdma_resolve_route
> ib_sdp: Unknown symbol rdma_resolve_route
> ib_sdp: disagrees about version of symbol rdma_bind_addr
> ib_sdp: Unknown symbol rdma_bind_addr
> ib_sdp: disagrees about version of symbol ib_register_client
> ib_sdp: Unknown symbol ib_register_client
> ib_sdp: disagrees about version of symbol rdma_create_qp
> ib_sdp: Unknown symbol rdma_create_qp
> ib_sdp: disagrees about version of symbol ib_destroy_cq
> ib_sdp: Unknown symbol ib_destroy_cq
> ib_sdp: disagrees about version of symbol rdma_create_id
> ib_sdp: Unknown symbol rdma_create_id
> ib_sdp: disagrees about version of symbol ib_set_client_data
> ib_sdp: Unknown symbol ib_set_client_data
> ib_sdp: disagrees about version of symbol rdma_notify
> ib_sdp: Unknown symbol rdma_notify
> ib_sdp: disagrees about version of symbol ib_get_client_data
> ib_sdp: Unknown symbol ib_get_client_data
> ib_sdp: disagrees about version of symbol rdma_listen
> ib_sdp: Unknown symbol rdma_listen
> ib_sdp: disagrees about version of symbol ib_query_device
> ib_sdp: Unknown symbol ib_query_device
> ib_sdp: disagrees about version of symbol ib_get_dma_mr
> ib_sdp: Unknown symbol ib_get_dma_mr
> ib_sdp: disagrees about version of symbol ib_alloc_pd
> ib_sdp: Unknown symbol ib_alloc_pd
> ib_sdp: disagrees about version of symbol rdma_connect
> ib_sdp: Unknown symbol rdma_connect
> .................
>=20
>=20
> Can somebody tell me what's wrong?
>=20
> Please Help.
>=20
>=20
> Thanks,
> Bhavin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Hi Bhavin,

I try SDP module with RDMA code to test some cards, but I had a lot of
problem.
Please read the bugzilla web site at bug 2027 and 2028.
https://lkml.org/lkml/2010/4/23/192

Search on line SDP with my name.

Good Easter.
Thanks,
Andrea Gozzelino

PhD Universit=C3=A0 di Padova=20
Dipartimento di Fisica Galileo Galilei
Via Marzolo, 8 - I - 35131 - Padova (PD) - Italia
Ufficio @ Padova: 138
Tel: +39 049 8277103

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 - I - 35020 - Legnaro (PD)- Italia
Ufficio @ LNL: E-101
Tel: +39 049 8068346
=46ax: +39 049 641925
							=09

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
