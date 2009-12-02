From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 2 Dec 2009 14:12:19 +0200
Message-ID: <20091202121219.GC19284@mtls03>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
 <4B0CDBEC.1030203@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B0CDBEC.1030203-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2009 at 09:25:32AM +0200, Or Gerlitz wrote:
> Liran, where this limitation comes from? isn't the HCA supporting
> bridging (loopback connections) for RDMAoE? if this is the case
> maybe you should add a device capability to mark that.
> 

Loopback support is not complete and is a temporary limitation. It
will be fixed in the near future.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
