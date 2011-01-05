From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/24] IB/qib: add thresholds to VendorPortCounters PMA operation
Date: Wed, 05 Jan 2011 09:58:19 -0800
Message-ID: <adalj2zfd1g.fsf@cisco.com>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
	<20101228152711.19960.52491.stgit@kop-dev-sles11-04.qlogic.org>
	<4D1A395D.6040103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D1A395D.6040103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Hal Rosenstock's message
	of "Tue, 28 Dec 2010 14:24:13 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > >   	p->class_version = 1;
 > >   	p->cap_mask = IB_PMA_CLASS_CAP_EXT_WIDTH;
 > >   	/*
 > > -	 * Set the most significant bit of CM2 to indicate support for
 > > +	 * Set the most significant two bits of CM2 to indicate support for
 > >   	 * congestion statistics
 > >   	 */
 > 
 > Where in the IBA spec do these bits come from ? What are they ?
 > 
 > > -	p->reserved[0] = dd->psxmitwait_supported<<  7;
 > > +	p->reserved[0] = (dd->psxmitwait_supported * 3)<<  6;
 > 
 > It looks weird to me to set an IBA reserved field. Should the
 > structure be updated to contain the real field name ?

The reserved field is (I think) actually the IBA "CapabilityMask2" bits
in ClassPortInfo; I agree that it would be better to update the
structure to name this correctly.

However, both the old and the new code look very fishy to me: bit 2 in
CapabilityMask is never set, which is the generic bit that says "If 1,
the management class agent implements additional class-specific
capabilities (CapabilityMask2)" so AFAICT, nothing should ever look in
CapabilityMask2 anyway.  

It seems that the original code was trying to set
ClassPortInfo.PortCountersXmitWaitSupported (bit 12), maybe.  I can't
fathom what the new code is doing.  And I can't find anything in the
spec that suggests that CM2 in this PMA ClassPortInfo should ever be used.

Mike, can you clarify this patch?  I'll hold off on applying this for now.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
