From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Wed, 11 Nov 2009 21:41:47 -0800
Message-ID: <alpine.LFD.1.10.0911112140000.24052@topaz.mv.qlogic.com>
References: <4AF9CACE.8070700@Sun.COM> <adaskclvta4.fsf@roland-alpha.cisco.com> <4AFAFF7A.4090602@oracle.com> <4AFB3677.6050603@Sun.COM> <4AFB3E6B.3080606@oracle.com> <20091111231338.GZ1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091111231338.GZ1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 11 Nov 2009, Jason Gunthorpe wrote:

| On Wed, Nov 11, 2009 at 05:44:59PM -0500, Richard Frank wrote:
| 
| > Would anyone like to through out the list of HCAs that do this... I
| > can guess at a few...  and can ask the vendors directly.. if not.. .
| > 
| > It would be much nicer to not hardcode names of adapters.. but that won't
| > stop us.. :)
| 
| Isn't it more complex than this? AFAIK the PCI-E standard does not
| specify the order which data inside a single transfer becomes visible,
| only how different transfers relate. To work on the most agressive
| PCI-E system the HCA would have to transfer the last XX bytes as a
| seperate PCI-E transaction without relaxed ordering.

I can't speak to the specifics of this on PCIe, but yes, by default
the pcie transfers within a single tag can be unordered.

| This is the sort of thing that might start to matter on QPI and HT
| memory-interleaved configurations. A multi-cache line transfer will be
| split up and completed on different chips - it may not be fully
| coherent 100% of the time.

HT is fine, by design, at least on AMD processors (probably don't care
too much about the older sibyte cpus, since they weren't fully
HT-compliant).

I don't know about QPI.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
