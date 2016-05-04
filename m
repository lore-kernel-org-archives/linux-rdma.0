From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 4 May 2016 16:49:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
 <5721C3AD.8050407@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
 <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0480DB@ORSMSX109.amr.corp.intel.com>
 <20160502175011.GB32096@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
 <20160502190619.GB32613@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502190619.GB32613-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> LSO says, 'take this WR, in HW perform a split and transform operation
> and create multiple SEND WRs'.
> 
> The end result is still SEND, LSO does not change anything about the
> layers below the WR. A SEND on a UD, RC, or RAW QP is still exactly the
> same as before LSO was involved.

Okay - this isn't what I think about when I read LSO at all (i.e. large segment offload, not large send [WR] offload).  We have chained WRs.  What your describing sounds like some sort of optimized version of that.

> Critically, the operation of LSO should be indistinguishable on the
> wire from actually generating the final WRs directly by the
> application in the SQ.

This concept should apply to the receive side as well.

And generically, I don't think we even need to restrict WR offload to being the same type of operation.  E.g. WRITE_WITH_SEND type of operation.

> Typically an IP focused LSO will work like this:
> 
>  'SEND' WR for 32k.
>  Split it into 1500 byte chunks, and make a new SEND for each chunk
>  Replicate bytes 0->NN of header onto every new SEND
>  Edit bytes XX->YY assuming they are an IPv4 header (update lengths,
>   checksum, sequence, etc)
>  Edit bytes YY->ZZ assuming they are a TCP or UDP header
>   (length,checksum,etc)
> 
> In all cases the LSO is simply a transformation of a single SEND into
> multiple SEND according to certain rules.
> 
> The rules *must* be specified in the API. I think this is what you are
> thinking about when you say 'protocol', but this is not IB or iWarp,
> it is 'LSO packet format protocol #1' or something.

I was under the impression that this was actually working at a protocol level that was above the transport level of the QP -- i.e. TCP/UDP/IP segmentation offload.
 
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
