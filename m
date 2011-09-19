From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] adding support for FDR/FDR-10 link speed
Date: Mon, 19 Sep 2011 18:34:29 +0300
Message-ID: <CAN+0-cY0EdONB601kwy1+M36KEXsqb2RzkcwABwQUTi3N5gNJA@mail.gmail.com>
References: <CAN+0-cahigghDbptYHxA1pHOV59CMuWSdXjkPTKTN1uGCcfdRg@mail.gmail.com>
	<CAN+0-cZ8fuPH_C+mxHFJHwBa1GvH5kZRBxz5X8EVcdpXBmUm5w@mail.gmail.com>
	<CAN+0-cavjwR4eLCgQVUZayJ+xJ7LZgBtqNN3YbMN34+7WL6vmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN+0-cavjwR4eLCgQVUZayJ+xJ7LZgBtqNN3YbMN34+7WL6vmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry, there is a problem with patches format, I'll send them again aft=
er fix.
Marcel


On Mon, Sep 19, 2011 at 6:05 PM, Marcel Apfelbaum
<marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> ---------- Forwarded message ----------
> From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Date: Mon, Sep 19, 2011 at 6:01 PM
> Subject: [PATCH RFC 0/4] adding support for FDR/FDR-10 link speed
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
>
> The purpose of the RFC is to introduce FDR/FDR-10:
> =A0- FDR10 is a proprietary link speed which is 10.3125 Gbps at 64/66
> encoding rather than 8b10b encoding.
> =A0- FDR represents an extended speed: 14.0625 Gbps
> =A0- EDR represents an extended speed: 25.78125 Gbps (EDR)
>
> The aim is to show correct speeds and link encoding in:
> =A0 - Ibstat
> =A0 - Ibv_devinfo
> =A0 - /sys/class/infiniband/mlx4_0/ports/1/rate
> =A0 - Other user space modules
>
> [PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
> Handle EDR/FDR extended speeds.
> Extended speeds are introduced and a new formula is used for
> speed computation (because of different encodings)
>
> [PATCH RFC 2/4] ib/core: handle FDR-10 link encoding
> Deals with issues related to FDR-10 link encoding:
> For QDR with FDR-10 encoding, =A0the rate is change accordingly to
> LinkEncodingEnable flag
>
> [PATCH RFC 3/4] ib/mlx4: get extended active speed from port info
> Gets extended active speed from Port Info packet(used for FDR/EDR)
>
> [PATCH RFC 4/4] ib/mlx4: get extended port capabilities
> An Extended Port Info packet is sent to each hw port during HCA init
> and if returns wihtout error it is assumed the port supports
> extended port capabilities.
>
> If the port supports extended capabilities and the active speed is
> QDR, FDR-10 link encoding is set according to Extended Port Info.
>
>
> Marcel
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
