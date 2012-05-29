From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] {NET,IB}/mlx4: 64 byte CQE/EQE support
Date: Tue, 29 May 2012 10:45:33 -0700
Message-ID: <CAL1RGDVibQjUE2Jh0JTc-Z_OxO8ekwAOVpFmCKmysF8M-2b4NQ@mail.gmail.com>
References: <1337869844-30259-1-git-send-email-ogerlitz@mellanox.com> <4FC4E016.4070607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC4E016.4070607-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2012 at 7:41 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Jack is now fixing that with the SRIOV IB patches he's working on,
> so please hold off with accepting this patch. I would still love to get
> feedback on
> the design re user space, etc compatibility and the patch in general.

OK, I'll hold off for now.

In general I'm kind of sad about the way the hardware works: having
to choose the incompatible 64-byte CQE format globally at startup
means we're kind of stuck breaking userspace in some cases.

I would suggest that we merge the fixed version of this into 3.6 with the
default to be compatible, 32-byte CQEs in all cases, and make sure
the 64-byte CQE handling is available in a libmlx4 release before then
(if you send me the change for that I'm happy to make a quick release).

Then around 3.8 or so we can have the kernel default to 64-byte CQEs
for HW that supports it.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
