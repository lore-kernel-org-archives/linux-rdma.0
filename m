From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upstream support for multicast IBoE
Date: Tue, 22 Nov 2011 17:07:35 -0700
Message-ID: <20111123000735.GF11469@obsidianresearch.com>
References: <20111122223812.GB2131@BohrerMBP.rgmadvisors.com>
 <CAL1RGDVF5FuVuToN56pmue1cUvHRw9kjaKC9xLOt51zeDJwMag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDVF5FuVuToN56pmue1cUvHRw9kjaKC9xLOt51zeDJwMag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2011 at 03:44:01PM -0800, Roland Dreier wrote:
> On Tue, Nov 22, 2011 at 2:38 PM, Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org> wrote:
> > $ mckey -m 239.1.1.1 -b 10.0.202.3
> > mckey: starting server
> > mckey: joining
> > mckey: joined dgid: ff0e::ffff:ef01:101 mlid 0x0 sl 0
> > mckey: failure creating address handle
> > test complete
> > return status 0
> >
> > Debugging this I can see it fails in libmlx4 in mlx4_create_ah(). ?In
> > this case mlx4_resolve_grh_to_l2() returns 1.
> 
> Or, looks like the libmlx4 patches I applied from you are missing
> multicast AH support?

I thought that was deliberate because of the lack of specification and
the strange reliance on IPv6 MLD for IBoE packet types...

AFAIK none of that has changed?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
