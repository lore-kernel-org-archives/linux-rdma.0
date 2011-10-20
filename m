From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
Date: Thu, 20 Oct 2011 09:06:04 -0700
Message-ID: <CAL1RGDXw9kkxAM8_pJ=jRhFTgRRt52QygDpQ+89RfEN=7QU=HQ@mail.gmail.com>
References: <1318494090-9996-1-git-send-email-kumaras@chelsio.com>
 <CAL1RGDU9Ka7-sGVnCnobgQjoh7p2bsXbSLp-Fnn6aA1Q9of36w@mail.gmail.com>
 <4E970E02.2090207@opengridcomputing.com> <88B766C272F2C64B944B21AD078333151BEE2E947E@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88B766C272F2C64B944B21AD078333151BEE2E947E-/SwythR3zqxVRK6PHKByhFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2011 at 2:11 AM,  <Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> http://lxr.linux.no/#linux+v3.0.4/Documentation/infiniband/core_locking.txt
>
> Line no 66 to 97 states that - at a given point of time, there should be only one callback per CQ should be active.
> Is this ensured?
>
> compl_handler() is invoked from multiple places flush_qp() and post_qp_event() to my mind.

Yes, does look like an issue with this patch :(

  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
