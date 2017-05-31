From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 31 May 2017 20:06:35 +0000
Message-ID: <1496261194.2608.13.camel@sandisk.com>
References: <20170529082423.1180-1-leon@kernel.org>
         <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
         <20170531040437.GE5406@mtr-leonro.local>
         <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
         <03c501d2da35$d10a22f0$731e68d0$@opengridcomputing.com>
         <20170531182050.GL5406@mtr-leonro.local>
         <03f901d2da3c$7e0f23a0$7a2d6ae0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <03f901d2da3c$7e0f23a0$7a2d6ae0$@opengridcomputing.com>
Content-Language: en-US
Content-ID: <2F2387F36F339C4E8B6ECD83EA79E827-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-31 at 13:34 -0500, Steve Wise wrote:
> > > I would hate to introduce an iwarp regression vs solving your issue w=
/o
> > > reverting.  If I recall, the flow control is need so as to not drop m=
essages
> > > flowing from the kernel to the iwpmd.  I'm not sure how that could be=
 fixed
> > > in the user daemon?
> >=20
> > Assume that netlink is unreliable and set socket timeout.
>=20
> It seems that netlink is becoming more and more a message API between ker=
nel and
> user.  Wouldn't everyone benefit from make it reliable?  And I think we c=
an
> certainly provide blocking/reliable mode as an option to be used only by =
those
> subsystems that require it. =20

Sorry Steve but I'm not sure that's a good idea. Netlink uses fixed size
buffers for sending messages to user space. Making netlink reliable means
making the kernel wait if the buffer is full. That would introduce the
possibility of a kernel deadlock if the user space application hangs. I
don't think we want that.

BTW, are you aware netlink reports buffer overflows to user space through
the ENOBUFS error code? Any user space software that reads from a netlink
socket should check the error code returned by recv() and resynchronize the
state if recv() fails with ENOBUFS. I'm writing here "should" because there
are several examples of user space software that doesn't do this correctly.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
