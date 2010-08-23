From: "Yossi Etigin" <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 22:34:38 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F8013249@exil.voltaire.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home><20100823174110.GK26549@obsidianresearch.com><alpine.DEB.2.00.1008231254300.10719@router.home><20100823182859.GL26549@obsidianresearch.com> <alpine.DEB.2.00.1008231427130.12815@router.home>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.2.00.1008231427130.12815-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Christoph,

I think you'll first want to check the wc_flags field in the work
completion to see whether GRH is present (and it must be present in
multicast packets, normally not present in unicast). Then, extract the
destination gid from grh, and compare the first 6 bytes of it to the
dev->broadcast address bytes 4...9 (once with dev->broadcast which is
IPv4, second time with dev->broadcast with the IP version nibble changed
to 6). The first 4 bytes of dev->broadcast are QPN.
Of course, you'll be doing this before pulling any other headers from
the skb because GRH comes first.

The QPN you get in the completion is the QP from which it was sent -
src_qp. You don't get the QPN which was put in the UD header by the
sender, which is 0xFFFFFF for multicast. In userspace (aka struct
ibv_wc), you get the qp number from which the receive buffer was taken,
and in kernel space (aka struct ib_wc, no 'v') you get the pointer to
the QP.

You can do multicast on UC QP.
You can't do multicast on RC QP.

BTW In your first patch looks like you are doing htonl when you should
be doing htons (or cpu_to_be16 which is good with constants)

> -----Original Message-----
> From: Christoph Lameter [mailto:cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org]
> Sent: Monday, August 23, 2010 22:28
> To: Jason Gunthorpe
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz; Yossi Etigin; Roland
Dreier
> Subject: Re: IPoIB: Broken IGMP processing
> 
> On Mon, 23 Aug 2010, Jason Gunthorpe wrote:
> 
> > src_qp is just the send QPN, you need to look at qp_num (aka dest
qp).
> > I'm not entirely sure what it will be, I didn't find anything too
clear
> > in the spec. If it is 0xFFFFFF then the HCA is copying the dest QP
> > directly into the WC and this can work, if it is something else then
> > the HCA is setting it to the QPN of the RQ that recieved the packet,
> > which is not useful for this.
> 
> AFAICT the spec has a QP for RC and one for UD packets. How do these
> relate to multicast?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
