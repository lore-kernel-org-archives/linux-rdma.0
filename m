From: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: need pointer to Understand how to use IBV_WR_RDMA_WRITE_WITH_IMM
Date: Wed, 8 Jun 2011 19:35:58 +0100
Message-ID: <BANLkTimeoB1hfr++=7=70E9KJWuJM6roNg@mail.gmail.com>
References: <BANLkTikC6jPFJm=MxT5oNDoJH4Ex+j41XA@mail.gmail.com>
	<20110607164333.GB24005@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110607164333.GB24005-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks all for your input.

As i am using SoftIwarp currently to do most of my test/ dev i will be
sticking to the RDMA+SEND for the moment.

At the same time i discovered that if i place some malformed or
unsupported request on the queue  through librdmacm/ libibverbs to the
softiwarp lib / module  crash the kernel.
I will probably have to look into the code and submit a patch in order
to provide "verbs command " checking into softiwarp.

On another note: Jason talked about a  design a fall back into the
protocol to use RDMA + SEND..
After browsing through the spec and the different library i didn't
find any function   allowing  to probe/query the supported
capabilities of the device.
Does anyone  know if its programmatically possible?
Ex : checkingDMA+IMM is supported , i suppose that for the atomic op i
just need to check  if ibv_query_device returns a postive value for
the max_qp_rd_atom and consor .

Regards
Benoit






On 7 June 2011 17:43, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>=
 wrote:
> On Tue, Jun 07, 2011 at 01:23:01PM +0100, Benoit Hudzia wrote:
>
>> I would like to use IBV_WR_RDMA_WRITE_WITH_IMM , however I am facing
>> difficulty to find documentation or example on how to use such
>> feature. ?The idea would be to do an RDMA write and wake up the peer
>> upon reception in order to process the received data.
>
> You basically have it correct, but generally you also need to mix SEN=
D
> traffic on the same QP as you are doing these RDMAs, at a minimum to
> manage the allocation of receive resources. Since you can't know if
> the remote will place a RDMA+IMM or a SEND into your receive WR you
> need to ensure that all of them that are posted are able to handle a
> SEND. If you get an IMM then ignore the payload, process the imm_data
> recycle the WR back into the HCA, and schedule a signal to the far
> side you now have additional receive WR space.
>
>> =A0 =A0 =A0 a.?????? Question : can i fill the imm_data with arbitra=
ry data?
>> I would like to use this field on the peer side to identify the
>> request
>
> Keep in mind the imm_data is copied byte-for-byte so you should put i=
t
> in a sensible endian-ness for your application.
>
> A simple example of a protocol using this might be:
>
> =A0SEND [My RDMA Recv buffer is XX-YY, I have RR recv WRs posted]
> =A0 =A0 =A0 =A0 =A0 SEND [OK, I have RR recv WRs posted]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0SEND [I have RR recv WRs posted]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0SEND [I have RR recv WRs posted]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 SEND [I have RR recv WRs posted]
> =A0SEND [I have RR recv WRs posted]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> =A0 =A0 =A0 =A0 =A0 RDMA WRITE [IMM =3D I wrote ZZ bytes]
> [etc..]
>
> With a scheme like this all recive work posts would include a recv
> buffer to handle a SEND receive completion, and each side would stop
> sending when it runs out of recv completion space on the far
> side. Generally with a scheme like this some care is needed to avoid
> deadlocking because you want to be a bit lazy with flow control sends=
=2E
>
> Jason
>



--=20
" The production of too many useful things results in too many useless =
people"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
