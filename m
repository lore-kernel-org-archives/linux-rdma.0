From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/7] libmlx4: add IBoE support
Date: Tue, 19 Jul 2011 23:18:57 +0300
Message-ID: <CAJZOPZJshO3hTRec6KjoEQHgnMcA7+8QRM6n+b8+qPL7CUw3MQ@mail.gmail.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1107191231540.5580@ogerlitz.voltaire.com>
	<20110719164906.GA18090@obsidianresearch.com>
	<CAJZOPZLsy-EcbCC3FSOLVGL05XBRcdKSYPpt4H+mwAHWrV73vA@mail.gmail.com>
	<20110719195528.GF18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110719195528.GF18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> Or Gerlitz wrote:

>> Jason, as the change log explains, under Ethernet link type the code
>> (see mlx4_resolve_grh_to_l2) goes and extracts the Ethernet L2 info
>> (mac and vlan, look on the last patch) from the GID.
>
> Looking at the control flow of the actual code, there is no reason it
> needs to know the link type, except to generate that error code. Why
> can't it set the slid, dlid and MAC fields in mlx4_ah simultaneously?

If you look on patch 6/7 @ mlx4_resolve_grh_to_l2, you would see this section

+               if (vid != 0xffff) {
+                       ah->av.port_pd |= htonl(1 << 29);
+                       ah->vlan = vid | ((attr->sl & 7) << 13);
+               }

this bit in the PD tells the HW  to add VLAN header to the packet and
sets the user priority bits for that vlan from the SL, we want to do
that only for Ethernet link type.

>> AH creation is app's slow path, e.g the equivalent of session
>> creation, so I wouldn't bother too much on perf, on the being elegant
>> side, I'll check if/how I can plant/cache the link type for the ah
>> creation code to use.

> Still, the MPI people regularly seem to have job startup problems, no
> idea how many AH's they end up creating at startup though..


Under IB job startup problems relates to SA scalability, generally under any
transport @ large scale there could be more issues, I don't think AH
creation time
is among them.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
