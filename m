From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Enable QP creation which is
 associated to underlay QP
Date: Wed, 7 Jun 2017 15:23:35 +0300
Message-ID: <CAFgAxU-=i2=yNnjE2kYHV0Re6Vrd=LyTB55q=p_1fc+zuotwvA@mail.gmail.com>
References: <20170530071602.8139-1-leon@kernel.org> <20170530071602.8139-2-leon@kernel.org>
 <20170530160447.GA21513@obsidianresearch.com> <1d799662-bc2b-ed12-882c-42d12d1ed8a1@dev.mellanox.co.il>
 <20170605153644.GA6749@obsidianresearch.com> <CAFgAxU9c1SwehkCY3o0RZPO_CTHGJb2A1omjVvJvyabO0V57iQ@mail.gmail.com>
 <20170606163320.GC8671@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606163320.GC8671-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 6, 2017 at 7:33 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Jun 06, 2017 at 06:49:52PM +0300, Alex Rosenbaum wrote:
>>    IPoIB is a tunneled protocol. The underlay part, a UD QP, has a set of
>>    properties that define its L2-L4 characteristics. In this suggestion we
>>    wanted to make sure the overlay will use the same QP so that there are
>>    no mismatches between the IB layer properties. An example for such a
>>    mistake can be if the overlay sets a PKey which is different than the
>>    IPoIB UD QP. A mistake example on the receive flow; when setting
>>    multiple ingress steering on using multiple different PKey's into a
>>    single user space UD QP.
>
> That seems like a strange thing to worry about, any user of this
> already has to closely track all of the IB parameters as they are
> required to issue path records.
>
> So this underlay/overlay complexity really doesn't do much for
> safety/usability, IMHO - it just introduces more complexity and more
> failure modes.
>
>>    Naming it "source_qpn" instead of associated, as you suggest, sound
>>    more appropriate.
>
> Simpler, certainly if you completely eliminate the notion of a linkage
> to another QP. This is just creating a TX QP with a specified QPN that
> can overlap an existing bidir QP's QPN.
>
> This could then also be potentially used for applications that desire a
> fixed QPN.
>

We reviewed your suggestion in deeper details and agree with your
suggested semantics to allow user to create a QP with user defined
wire QPN, without mandating association of an overlay with underlay
QP. This will allow each vendor to implement this feature according to
his HW capabilities. Thus the new attribute we will add to
ib_create_qp will be 'source_qpn' and matching flag.
Obviously this will require root privileges from user application, and
thus in v2 we will extend the existing CAP_NET_RAW check on creation
of this kind of QP with source QPN, as done in RAW_PACKET QP.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
