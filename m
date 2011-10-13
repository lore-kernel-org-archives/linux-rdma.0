From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: create new library project and few queries to open source
Date: Thu, 13 Oct 2011 10:32:13 -0700
Message-ID: <CAL1RGDUybg1bVooqAo1Bt9F2r1hrHtthRtGQE+nzGXELMi136g@mail.gmail.com>
References: <88B766C272F2C64B944B21AD078333151BB18C09A2@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88B766C272F2C64B944B21AD078333151BB18C09A2-/SwythR3zqxVRK6PHKByhFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2011 at 9:40 AM,  <Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> 2. For adding hardware driver for a new RDMA adapter, to which git tree(s) do I need to submit patches?
> openfabrics.org as well as kernel.org or just openfabrics is sufficient?
>
> git://git.openfabrics.org/ofed_1_5/linux-2.6.git, branch ofed_kernel_1_5?
> and
> git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git, branch for-next?
>
> 4. I am little confused.
> pub/scm/linux/kernel/git/roland/infiniband.git is not showing up in the list at http://git.kernel.org.
> Am I looking at wrong place? Or?
>
> 5. my_new_rdma_hw_driver that will be located in drivers/infiniband/hw/my_new_rdma_hw_driver directory, does it have to compile for all backports or only my desired kernel versions are sufficient for OFED 1.5.x, as I don't plan to support 2.6.22 and older kernel version?

Please focus on upstream kernel first, then worry about OFED backports.

My for-next tree is temporarily at https://github.com/rolandd/infiniband
while kernel.org recovers from the security break.

But really it's fine to work against Linus's 3.1-rc as well.  At this point
it's probably not realistic to expect your code to get into 3.2, but it's the
perfect time to start reviewing for a 3.3 merge.

Looking forward to seeing another RDMA adapter supported upstream...
 - Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
