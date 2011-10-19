From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Wed, 19 Oct 2011 13:47:48 -0600
Message-ID: <20111019194748.GA12501@obsidianresearch.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com>
 <1319049335.18132.34.camel@haakon2.linux-iscsi.org>
 <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA@mail.gmail.com>
 <1319051341.18132.53.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1319051341.18132.53.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 12:09:01PM -0700, Nicholas A. Bellinger wrote:

> Are sport->gid.global.interface_id going to be different for each struct
> srpt_port..?

Infiniband GID suffixes (interface_id) are not guaranteed to be
unique. The GID is expected to be unique, the portGUID (which is
sometimes the same as the interface_id) is also expected to be unique.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
