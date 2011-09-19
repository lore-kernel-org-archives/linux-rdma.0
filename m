From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
Date: Mon, 19 Sep 2011 14:26:13 -0400
Message-ID: <CAKzyTsxxuB=k+N+rxPmfx8zZZApDdr-_FfajDstDVa7M1nV8xg@mail.gmail.com>
References: <201109191906.05360.marcela@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A8237316E64FDC@ORSMSX101.amr.corp.intel.com>
	<CAKzyTszd0LSOaY4RFCw2WpNBBQcgfkUYFSOy6q+rC1SjSb4q3A@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E6508C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6508C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2011 at 2:17 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> It maps to what was done in the PortInfo attribute to add the new
>> extended speeds. There was no room for expansion in the existing
>> original link speed fields so a "parallel" set of fields had to be
>> added there..
>
> That's was an issue with the wire protocol format, correct?

Right.

> Why carry that same concept into a software interface? =C2=A0It seems=
 complex.

So as not to break existing verbs apps by inventing new values to
existing fields which wouldn't be understood.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
