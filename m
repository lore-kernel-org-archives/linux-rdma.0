From: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: need pointer to Understand how to use IBV_WR_RDMA_WRITE_WITH_IMM
Date: Tue, 7 Jun 2011 13:23:01 +0100
Message-ID: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I am uncertain if this is the correct place for such email, please
point me to an appropriate mailing list place if not.

I would like to use IBV_WR_RDMA_WRITE_WITH_IMM , however I am facing
difficulty to find documentation or example on how to use such
feature. =A0The idea would be to do an RDMA write and wake up the peer
upon reception in order to process the received data.

What I understand from IBV_WR_RDMA_WRITE_WITH_IMM:

On the server side:

1.=A0=A0=A0=A0=A0 You create your ibv_wr
2.=A0=A0=A0=A0=A0 You set the opcode to IBV_WR_RDMA_WRITE_WITH_IMM
3.=A0=A0=A0=A0=A0 You fill the imm_data of the wr
      a.=A0=A0=A0=A0=A0=A0 Question : can i fill the imm_data with arbi=
trary data?
I would like to use this field on the peer side to identify the
request
4.=A0=A0=A0=A0=A0 Do the =A0ibv_post send



On the peer side:

As i understand , IBV_WR_RDMA_WRITE_WITH_IMM consume a Receive Request
in the responder side. So it means i need to post a recv request with
ibv_post_recv .

However i cannot documentation find (maybe i didn=92t search hard
enough) =A0how to construct such request.

* Should i just create an empty / zeroed =A0: =A0ibv_recv_wr containing=
 an
empty ibv_sge (or no sge)?
* Can i prefill the recv queu with multiple request ?

On the work completion side within my CQ event handler:

* I suppose i should look for IBV_WC_RECV_RDMA_WITH_IMM
* Then can I use/ check the imm_data in the WC to identify the operatio=
n?



Basically at the moment i am struggling to understand how to handle /
detect the rdma write with imm on the receiver side.



Any pointer / code example/ explanation will be greatly appreciated.



Regards

Benoit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
