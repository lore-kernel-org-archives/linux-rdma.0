From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Wed, 13 Jul 2011 17:40:57 -0700
Message-ID: <CAL1RGDVXJd7Sq0-CcYR6heN_HCsrmc1CtrkKfxLWxYe3WN=ghA@mail.gmail.com>
References: <20110710120442.GA11284@localhost.localdomain> <20110712162740.29e2d7d1.weiny2@llnl.gov>
 <20110712235222.GG10216@obsidianresearch.com> <20110712165817.16076a3d.weiny2@llnl.gov>
 <20110713041441.GA26663@obsidianresearch.com> <20110713082640.GA2024@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110713082640.GA2024-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2011 at 1:26 AM, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> +dnl Where to place opensm.pid
> +piddir=/var/run

FWIW the future seems to be /run instead of /var/run, eg
http://lists.fedoraproject.org/pipermail/devel/2011-March/150031.html

Not sure what the best way to handle this in a way that doesn't cause
hassles for packagers is.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
