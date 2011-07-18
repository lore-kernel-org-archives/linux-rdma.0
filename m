From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] libmthca 1.0.5 and libmlx4 1.0.2 are released
Date: Mon, 18 Jul 2011 12:20:01 -0700
Message-ID: <CAL1RGDXseg920=-PYi1q8GXQwMMSwzRvci=nUM1fkQ9kG-WigA@mail.gmail.com>
References: <1309981353-14301-1-git-send-email-roland@kernel.org>
 <CD250C48050CFB4D95E78C95F2FDDD6E071C09B6@mtldag02.mtl.com>
 <CAG4TOxN7iWn7JN7Yg_FMO1qdKFhhPXaujC-Chc=DfCyFMpxO5A@mail.gmail.com>
 <CD250C48050CFB4D95E78C95F2FDDD6E071C9C38@mtldag02.mtl.com> <20110718171230.GA26012@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110718171230.GA26012-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Why is that test even in libmlx4?

We need some way for userspace drivers to know which devices to bind.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
