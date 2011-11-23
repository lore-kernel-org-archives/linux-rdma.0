From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Upstream support for multicast IBoE
Date: Tue, 22 Nov 2011 23:03:34 -0800
Message-ID: <CAL1RGDVQYsy8iLSN2S21E74A8Qfedo=Su7Bp3Lz8B3a7LcT=Ew@mail.gmail.com>
References: <20111122223812.GB2131@BohrerMBP.rgmadvisors.com>
 <CAL1RGDVF5FuVuToN56pmue1cUvHRw9kjaKC9xLOt51zeDJwMag@mail.gmail.com> <20111123000735.GF11469@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111123000735.GF11469-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2011 at 4:07 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I thought that was deliberate because of the lack of specification and
> the strange reliance on IPv6 MLD for IBoE packet types...
>
> AFAIK none of that has changed?

I honestly can't remember the discussion.  But we have the ad hoc
MGID -> ethernet address mapping in the kernel, did we really decide
just to leave it out of userspace?

The current situation is pretty embarassing -- is the IBTA still pretending
no standard needs to be written?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
