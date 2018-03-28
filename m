From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 06:53:36 +0000
Message-ID: <CA+55aFyaZ=WEXFg4KZ0yCWaR=8Dm_FPK-xcA0EYi3fEzm+KZkA@mail.gmail.com>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
 <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca>
 <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org>
 <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
 <20180327151029.GB17494@arm.com>
 <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
 <1522186396.7364.61.camel@kernel.crashing.org>
 <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
 <1522198981.7364.81.camel@kernel.crashing.org>
 <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
 <1522211620.7364.94.camel@kernel.crashing.org>
 <CA+55aFw24R3YAujir59GdG+sBBQOA9WyXySEN3AcEYK99ZHuwQ@mail.gmail.com>
 <1522219376.7364.109.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="001a113f7b6ef26d3905687377f1"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1522219376.7364.109.camel@kernel.crashing.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Alexander Duyck <alexander.duyck@gmail.com>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

--001a113f7b6ef26d3905687377f1
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 27, 2018, 20:43 Benjamin Herrenschmidt <benh@kernel.crashing.org>
wrote:

> >
> > Of course, you'd have to be pretty odd to want to start a DMA with a
> > read anyway - partly exactly because it's bad for performance since
> > reads will be synchronous and not buffered like a write).
>
> I have bad memories of old adaptec controllers ...
>

*Old* adaptec controllers were likely to use the in/out instructions for
status and command data.

Those are actually even more ordered than UC reads and writes: the in/out
instructions are not just fully ordered, but are fully *synchronous* on
x86.

So not just doing accesses in order, but actually waiting for everything to
drain before they start executing, but they also wait for the operation
itself to complete (ie "out" will not just queue the write, it will then
wait for the queue to empty and the write data to hit the line).

That's why in/out were *so* slow, and why nobody uses them any more (well,
the address size limitations and the lack of any remapping of the address
obviously also are a reason).

    Linus

>

--001a113f7b6ef26d3905687377f1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr">=
On Tue, Mar 27, 2018, 20:43 Benjamin Herrenschmidt &lt;<a href=3D"mailto:be=
nh@kernel.crashing.org">benh@kernel.crashing.org</a>&gt; wrote:</div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">
&gt;<br>
&gt; Of course, you&#39;d have to be pretty odd to want to start a DMA with=
 a<br>
&gt; read anyway - partly exactly because it&#39;s bad for performance sinc=
e<br>
&gt; reads will be synchronous and not buffered like a write).<br>
<br>
I have bad memories of old adaptec controllers ...<br></blockquote></div></=
div><div dir=3D"auto"><br></div><div dir=3D"auto">*Old* adaptec controllers=
 were likely to use the in/out instructions for status and command data.</d=
iv><div dir=3D"auto"><br></div><div dir=3D"auto">Those are actually even mo=
re ordered than UC reads and writes: the in/out instructions are not just f=
ully ordered, but are fully *synchronous* on x86.=C2=A0</div><div dir=3D"au=
to"><br></div><div dir=3D"auto">So not just doing accesses in order, but ac=
tually waiting for everything to drain before they start executing, but the=
y also wait for the operation itself to complete (ie &quot;out&quot; will n=
ot just queue the write, it will then wait for the queue to empty and the w=
rite data to hit the line).</div><div dir=3D"auto"><br></div><div dir=3D"au=
to">That&#39;s why in/out were *so* slow, and why nobody uses them any more=
 (well, the address size limitations and the lack of any remapping of the a=
ddress obviously also are a reason).</div><div dir=3D"auto"><br></div><div =
dir=3D"auto">=C2=A0 =C2=A0 Linus</div><div dir=3D"auto"><div class=3D"gmail=
_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex">
</blockquote></div></div></div>

--001a113f7b6ef26d3905687377f1--
