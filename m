From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: need pointer to Understand how to use IBV_WR_RDMA_WRITE_WITH_IMM
Date: Tue, 7 Jun 2011 14:23:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373019210@ORSMSX101.amr.corp.intel.com>
References: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What I understand from IBV_WR_RDMA_WRITE_WITH_IMM:
>=20
> On the server side:
>=20
> 1.=A0=A0=A0=A0=A0 You create your ibv_wr
> 2.=A0=A0=A0=A0=A0 You set the opcode to IBV_WR_RDMA_WRITE_WITH_IMM
> 3.=A0=A0=A0=A0=A0 You fill the imm_data of the wr
>       a.=A0=A0=A0=A0=A0=A0 Question : can i fill the imm_data with ar=
bitrary data?

Yes - but it's limited to 32-bits.

> I would like to use this field on the peer side to identify the
> request
> 4.=A0=A0=A0=A0=A0 Do the =A0ibv_post send
>=20
>=20
>=20
> On the peer side:
>=20
> As i understand , IBV_WR_RDMA_WRITE_WITH_IMM consume a Receive Reques=
t
> in the responder side. So it means i need to post a recv request with
> ibv_post_recv .
>=20
> However i cannot documentation find (maybe i didn't search hard
> enough) =A0how to construct such request.
>=20
> * Should i just create an empty / zeroed =A0: =A0ibv_recv_wr containi=
ng an
> empty ibv_sge (or no sge)?

I'm not sure about the underlying implementations, but I believe this s=
hould work.=20

> * Can i prefill the recv queu with multiple request ?

Yes - up to the size specified for the receive queue.

> On the work completion side within my CQ event handler:
>=20
> * I suppose i should look for IBV_WC_RECV_RDMA_WITH_IMM
> * Then can I use/ check the imm_data in the WC to identify the operat=
ion?

yes

> Any pointer / code example/ explanation will be greatly appreciated.

I'm not aware of any example code, but it sounds like you understand th=
e concepts.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
