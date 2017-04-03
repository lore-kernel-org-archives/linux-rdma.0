From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Infiniband-general] Subnet manager and multicast RDMA
Date: Mon, 3 Apr 2017 15:14:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB10EE4D@ORSMSX109.amr.corp.intel.com>
References: <018701d2aa0a$c899c040$59cd40c0$@mireo.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1250"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <018701d2aa0a$c899c040$59cd40c0$@mireo.hr>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miljen Mikic <miljen.mikic-52g2zqqi4Es@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replacing infiniband-general mail list (which I wasn't aware even existed, =
let alone a subscriber to) with linux-rdma.

> I went through the source code of mckey utility (available e.g. here:
> https://github.com/ofiwg/librdmacm/blob/master/examples/mckey.c ).
> There is an interesting comment at the line 524:
>=20
> /*
>   *  Pause to give SM chance to configure switches. We don't want to
>  *  handle reliability issue in this simple test program.
>   */
>   sleep(3);
>=20
> If we remove sleep function call, mckey does not work properly anymore
> (receiver side does not get all messages that were sent). Does anyone
> know how long does it take for SM to =84configure switches=93, and what i=
s
> the proper way to =84handle reliability issue=93?

The SM time depends on the size of the fabric and how busy the SM is.  I ca=
n't guess on the expected time; maybe someone who works closer with the SM =
will be able to guess.  My comment about reliability was that the test assu=
mes no dropped packets.  If you wanted reliable multicast, you would need t=
o add some sort of retry/acknowledgement protocol.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
