From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v2] IB/qib: add thresholds to VendorPortCounters PMA
 operation
Date: Tue, 1 Feb 2011 13:56:44 -0800
Message-ID: <20110201135644.b6371e08.weiny2@llnl.gov>
References: <20110201142348.9826.83896.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110201142348.9826.83896.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org" <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 1 Feb 2011 06:23:48 -0800
Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:

> The patch has been reworked so that the fields used are no longer reserved.
> 
> The QLogic PMA has a vendor specific capability.  We are using the top
> 2 bits of the CapabilityMask2 to indicate the behavior is available.
> 
> By not setting the bit 2 in the CapabilityMask, we are indicating that
> other PMA clients should ignore CapabilityMask2.

I'm confused, does this mean you never plan to support any capabilities which
will be indicated in CapabilityMask2?

There are only 2 bits left in CapabilityMask at this time, with a proposal
already submitted to use one of them.

I think it would be better to suggest to the IBTA to either A) reserve some
bits for vendor specific use in CapabilityMask2 or better yet B) suggest this
as a standard use of those bits.

Another option, if you don't want this included as part of the standard is to
use the Vendor specific class to communicate this information.

Am I missing something?
Ira

> 
> As such no other tools should be confused by our setting of the 2 bits
> (because they should not look in CapabilityMask2 anyway).
> 
> We purposely do not set the PortXmitWait CapabilityMask bit, this
> driver does not implement that capability.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
