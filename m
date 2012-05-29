From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] {NET,IB}/mlx4: 64 byte CQE/EQE support
Date: Tue, 29 May 2012 22:09:16 +0300
Message-ID: <CAJZOPZ+i6RM7GNnpRYxGrmP1nXpaMTE9Y-UyGPSu__E1ncJcDw@mail.gmail.com>
References: <1337869844-30259-1-git-send-email-ogerlitz@mellanox.com>
	<4FC4E016.4070607@mellanox.com>
	<CAL1RGDVibQjUE2Jh0JTc-Z_OxO8ekwAOVpFmCKmysF8M-2b4NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVibQjUE2Jh0JTc-Z_OxO8ekwAOVpFmCKmysF8M-2b4NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2012 at 8:45 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> In general I'm kind of sad about the way the hardware works: having
> to choose the incompatible 64-byte CQE format globally at startup
> means we're kind of stuck breaking userspace in some cases.

yes, indeed, that's the way CX3 works.

> I would suggest that we merge the fixed version of this into 3.6 with the
> default to be compatible, 32-byte CQEs in all cases, and make sure
> the 64-byte CQE handling is available in a libmlx4 release before then
> (if you send me the change for that I'm happy to make a quick release).

I'm not sure to be with you, you saying that you'd like for the
default to be compatible, 32-byte CQEs in **all** cases, how would
one, even with patched libmlx4 get the 64-byte CQE ability to come
into play??

Note that from the FW POV, we need to decide by INIT_HCA time, if to
arm the HCA to work in 64B CQE (&& EQE) mode, so the approach I took
in the patch was that on init hca time, we go that 64B way when the FW
supports that. When user space libmlx4 issues a get context call, bump
the ABI and advertize 64B support ONLY when the driver went the 64B
way.  Could you clarify this a little further?

Sure, I will post you a batch of libmlx4 and libibverbs patches once
3.5-rc1 is out, 1st and most we have on the plate the RAW QP patches
and this one (64B), also some more fixes/cleanups.

BTW, I posted two libmlx4 patches in response to Sean's question on
the query device capabilities kernel patch I posted. They somehow
relate (but are NOT dependent) on patch #2 in the little series I
posted last week @
http://marc.info/?l=linux-rdma&m=133786506100747&w=2 , are you looking
on these patches for 3.5?


> Then around 3.8 or so we can have the kernel default to 64-byte CQEs
> for HW that supports it.

Again, I'm not with you, how are you suggesting for the kernel patch
to come into action under 3.6 / 3.7?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
