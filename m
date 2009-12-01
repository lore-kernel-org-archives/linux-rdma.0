From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Tue, 1 Dec 2009 18:46:37 +0200
Message-ID: <20091201164637.GA17672@mtls03>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
 <20091125001136.GP6188@obsidianresearch.com>
 <20091130133406.GA32123@mtls03>
 <adaiqcrx2xx.fsf@roland-alpha.cisco.com>
 <5AEC2602AE03EB46BFC16C6B9B200DA81691763FEA@MNEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5AEC2602AE03EB46BFC16C6B9B200DA81691763FEA-e4KNYiSEog6Xx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 30, 2009 at 02:01:45PM -0600, Todd Rimmer wrote:
> 
> If a given architecture rounds sizeof(transport) up to 16 bits or 32 bits, then the replacement field should be uint16_t or uint32_t respectively, otherwise existing binary applications which fetch transport will fetch additional undefined bytes which follow it in the new structure.
> 
> The big question is whether all presently supported architectures use the same size for enum?
> 
> I did a quicky test program and on SLES10 x86_64 sizeof(an enum) is 32 bits.  Hence uint8_t would break binary compatibility on that platform.
> 
You probably refer to binary compatibility between defferent versions
of the RDMAoE libibverbs (e.g. the one with enum and the one with
uint8_t). I think this is not a big issue and recompiling should solve
that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
