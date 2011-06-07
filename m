From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: need pointer to Understand how to use IBV_WR_RDMA_WRITE_WITH_IMM
Date: Tue, 07 Jun 2011 07:18:14 -0700
Message-ID: <4DEE3326.9050105@redhat.com>
References: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/07/2011 05:23 AM, Benoit Hudzia wrote:
> I am uncertain if this is the correct place for such email, please
> point me to an appropriate mailing list place if not.
>=20
> I would like to use IBV_WR_RDMA_WRITE_WITH_IMM , however I am facing
> difficulty to find documentation or example on how to use such
> feature.  The idea would be to do an RDMA write and wake up the peer
> upon reception in order to process the received data.
>=20
> What I understand from IBV_WR_RDMA_WRITE_WITH_IMM:

I would recommend against using IMM modes.  I believe they are not
supported on non-infiniband hardware, which limits your application fro=
m
being used on Ethernet rdma systems.

>=20
> On the server side:
>=20
> 1.      You create your ibv_wr
> 2.      You set the opcode to IBV_WR_RDMA_WRITE_WITH_IMM
> 3.      You fill the imm_data of the wr
>       a.       Question : can i fill the imm_data with arbitrary data=
?
> I would like to use this field on the peer side to identify the
> request
> 4.      Do the  ibv_post send
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
> However i cannot documentation find (maybe i didn=92t search hard
> enough)  how to construct such request.
>=20
> * Should i just create an empty / zeroed  :  ibv_recv_wr containing a=
n
> empty ibv_sge (or no sge)?
> * Can i prefill the recv queu with multiple request ?
>=20
> On the work completion side within my CQ event handler:
>=20
> * I suppose i should look for IBV_WC_RECV_RDMA_WITH_IMM
> * Then can I use/ check the imm_data in the WC to identify the operat=
ion?
>=20
>=20
>=20
> Basically at the moment i am struggling to understand how to handle /
> detect the rdma write with imm on the receiver side.
>=20

I would expect on receiver side you would use the normal ibv_post_recv
calls to contain references to the memory regions that received message=
s
should come into.  Then you can use completion queue events
ibv_create_qp() just as you have mentioned in your email.

A better choice to using IMM would be to stuff the data directly into
your message as a header.

Regards
-steve
>=20
>=20
> Any pointer / code example/ explanation will be greatly appreciated.
>=20
>=20
>=20
> Regards
>=20
> Benoit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
