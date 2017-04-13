From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/3] srp_daemon/srp_daemon.c: Don't rely on
 attribute offset, in get_shared_pkeys
Date: Thu, 13 Apr 2017 15:24:47 +0000
Message-ID: <1492097083.3298.3.camel@sandisk.com>
References: <b3cbb29e-25bf-1785-7a60-8e8d7cab74e3@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b3cbb29e-25bf-1785-7a60-8e8d7cab74e3-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Content-ID: <FF64930EC6C5684A89944B3C88B48358-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-13 at 10:48 -0400, Hal Rosenstock wrote:
> get_shared_pkeys has been using SubAdmGet rather than SubAdmGetTable sinc=
e
> commit 2ad09524931dbf98d412e1912c1bdbf22f8ac81d
> srp_daemon: Work around SM bug over non-default P_Key support
>=20
> so RMPP is no longer used in response so it's not safe to
> rely on AttributeOffset field. Good MAD status is sufficient
> to say that valid PathRecord was returned.
>=20
> Found-by: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> using embedded subnet manager running on an Intel True Scale
> Edge Switch 12300.
>=20
> This has been broken since srptools-1.0.1 which was first
> release containing commit mentioned above.

Reviewed-by: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
