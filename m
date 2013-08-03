From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 FIXES for-3.11 0/4] Pkey fixes for IB core and IPoIB
Date: Sun, 4 Aug 2013 01:12:20 +0300
Message-ID: <CAJZOPZ+_MbfUVjvdjuBBWexGx-++PRoW=7rb8bofaeTNGZqVPQ@mail.gmail.com>
References: <1374145352-27816-1-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZLVQhZtWyCJLt3W-COdHZnsrBaN+KOpj83d0GyS+RY+QA@mail.gmail.com>
	<51FA2D98.5000707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51FA2D98.5000707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 1, 2013 at 12:42 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> I think its perfectly OK to expect a written answer from you on the iser
> patches. Are you OK with merging them for 3.11 or they will have to wait for 3.12?
>
> They bring in the benefit of avoiding bounce buffer when used over
> ConnectX Virtual Functions or ConnectIB devices AND ONLY touch
> iser code, so no risk to other kernel components.

OK, Roland, I see that you didn't pick this for 3.11, probably as you
consider this non-fix, well the patches makes the initiator to avoid
bounce buffer for IOs > 4K, which saves kernel memory and CPU - which
I think can be considered a fix for the system behaviour.

If you still don't agree, let it be, tough life... but you're the
maintainer. So in that respect && taking into account 3.11-rc3 is
already here, can you the door (== for-next branch) be opened right
away (please) for 3.12 patches, specifically this series? its
impossible to let kernel work towards a merge window be done only in
the 1-2 weeks before the window open. E.g I'd like to know that the
iser series is safe and ready to go from your POV, and f not fix what
ever needs to be changed now and not in two months just a little
before 3.11 is out, fair-enough?

Or.

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
