From: Nicolas Carlier <chronidev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Why is Infiniband a "Lossless" medium?
Date: Mon, 21 Apr 2014 16:30:53 +0200
Message-ID: <CAGFOLLcmanOYG-QQ2WNigWWS6aDyj937t3mMT_jWVPCPQMgc7w@mail.gmail.com>
References: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g@mail.gmail.com>
	<6B2A6E60C06CCC42AE31809BF572352B9ABACD98@MTLDAG01.mtl.com>
	<alpine.DEB.2.10.1403171149370.12043@nuc>
	<CAGFOLLetw+jYJBRotyvk8iYyEB+_b8D6KZrcwzxQnneOA5vSmw@mail.gmail.com>
	<alpine.DEB.2.10.1404191223070.16272@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1404191223070.16272-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 19, 2014 at 7:25 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, 18 Apr 2014, Nicolas Carlier wrote:
>
>> > If the receiving QP does not have buffers available then the HCA will
>> > silently drop UD packets. This is somethig that tripped us up initialy. So
>> > its lossless only from HCA to HCA not QP to QP.
>> >
>> >     Christoph, I'm very interesting by this. Do you have any documentation
>> related to this mechanisms? I'm troubleshooting an infiniband fabric where
>> I use heavily ipoib to collect multicast traffic. I see lot of gaps on the
>> application, but I can't map any of this gaps to drop counters or dropwatch
>> output.
>
> There was a promise that MOFED 2.1 or 2.2 should support a counter for QP
> overrun but I have never seen that work. The counter is there but does not
> increment.
>
Interresting, I don't see this counter neither on fw/sw release notes nor on the
systems. What the name of this counter ? On which HCA do you see this
counter ?

>> I'm sure drops don't occur upstream because I'm able to dump traffic before
>> the Infiniband Fabric without observing them.
>> I'm also able to dump traffic on another server inside the Infiniband Fabric
>> connected to the same leaf switch without observing them.
>
> Well looks like silent drops to me. One way to check is to verify the
> sequence ids in each multicast packet.
>
It is through this that I discovered that I was losing packets. But it
need to dissect
packet. I dreamed to use the psn, but it was a wrong direction.

> We finally ended up with looking at all the counters in the fabric and if
> we could not account for it we assumed it was QP overrun.
>

Yes. Do you have clue how interpret XmitWait and how a port is
notified to wait when
we use UD mode ?


--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
