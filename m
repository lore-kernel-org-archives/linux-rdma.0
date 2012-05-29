From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] {NET,IB}/mlx4: 64 byte CQE/EQE support
Date: Tue, 29 May 2012 11:57:12 -0600
Message-ID: <20120529175712.GB17863@obsidianresearch.com>
References: <1337869844-30259-1-git-send-email-ogerlitz@mellanox.com>
 <4FC4E016.4070607@mellanox.com>
 <CAL1RGDVibQjUE2Jh0JTc-Z_OxO8ekwAOVpFmCKmysF8M-2b4NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDVibQjUE2Jh0JTc-Z_OxO8ekwAOVpFmCKmysF8M-2b4NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2012 at 10:45:33AM -0700, Roland Dreier wrote:

> Then around 3.8 or so we can have the kernel default to 64-byte CQEs
> for HW that supports it.

Can things also be tweaked so the old libmlx4 won't load at all on
these kernels? Bump one of the abi_ver values or something?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
