From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Thu, 21 Jul 2011 15:47:31 +0300
Message-ID: <201107211547.31850.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201107211038.23000.jackm@dev.mellanox.co.il> <D8276D45-5FE8-464C-B3A4-14404DE8C760@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D8276D45-5FE8-464C-B3A4-14404DE8C760-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Shamis, Pavel (shamisp-1Heg1YXhbW8@public.gmane.org)" <shamisp-1Heg1YXhbW8@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 21 July 2011 14:58, Jeff Squyres wrote:
> > If MPI can use a different XRC domain per job (and deallocate the domain
> > at the job's end), this would solve the tgt qp lifetime problem (-- by
> > destroying all the tgt qp's when the xrc domain is deallocated).
> 
> What happens if the MPI job crashes and does not properly deallocate the XRC domain / tgt qp?
> 
I assume that you mean with Sean's new interface. Sean should verify what I write below.

If you use file descriptors for the XRC domain, then when the last user of the domain exits, the domain
gets destroyed (at least this is in OFED.  Sean's code looks the same).

In this case, the kernel cleanup code for the process should close the XRC domains opened by that
process, so there is no leakage.

When the last user of an XRC domain exits cleanly (or crashes), the domain should be destroyed.
In this case, with Sean's design, the tgt qp's for the XRC domain should also be destroyed.

Sean, is this correct?

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
