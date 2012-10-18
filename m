From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-3.7 0/4] mlx4 SRIOV fixes, 64B CQE/EQE patches re-spin
Date: Thu, 18 Oct 2012 16:58:34 -0700
Message-ID: <CAL1RGDVxogkdm0BUOE6nrFsJiSOWtqG_BrQ6p8qZddixgwaL+Q@mail.gmail.com>
References: <1350492181-13471-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350492181-13471-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 17, 2012 at 9:42 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> Also, a respin of the 64B CQE/EQE patches (kernel and user-space), over the V1 posting
> you were asking for max flexibility - e.g expose/force update of guests only if needed
> and similarily for libmlx4, I think I have this now, would love feedback though.
>
> I tested this with both modified/non-modified mlx4 guest drivers, and with
> both modified/non-modified libmlx4. The only pain point I was hitting,
> if non modified libmlx4 on systems with CX3 and modified kernel, on
> the V1 discussion Roland -- you made a comment we might need a module param
> here to provide admins a way to let systems with old libmlx4 to work
> with fresh kernels?!

So I don't think this change (which changes the kernel ABI) is appropriate
for 3.7 after the merge window in any case.

With that said I think we need a stronger compatibility story even for 3.8.
Suppose I'm running a virtualized system with SR-IOV, and I have a stable
guest that is working perfectly.  Then I want to update the hypervisor to
a newer kernel to get more KVM features or something.

If that kernel update enables 64B CQEs, then my guest is now broken.
And I don't want to force a guest update just to get a new hypervisor.

So I think we need some flag passed to the mlx4_core (that drives the
PPF) that lets the user opt into 64B CQEs.  I would suggest that we
start with the default value be "disabled" and then flip that after a few
kernel versions (and print something in the kernel log when we detect
64B-CQE-capable HW when we're running with 64B CQEs disabled).

Unfortunately because the 64B CQE setting is global for the whole
adapter (instead of being per-CQ), I don't see any better way to
support old userspace/guest kernels.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
