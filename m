From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
Date: Fri, 14 Oct 2011 13:22:32 -0700
Message-ID: <CAL1RGDUz7jSgA=BHDi3oPEGfJ6oy49ptsiXm9c+vTp+gONO=Ow@mail.gmail.com>
References: <1318494090-9996-1-git-send-email-kumaras@chelsio.com>
 <CAL1RGDU9Ka7-sGVnCnobgQjoh7p2bsXbSLp-Fnn6aA1Q9of36w@mail.gmail.com> <4E970E02.2090207@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E970E02.2090207-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2011 at 9:12 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
> I'm not sure other drivers have this issue. =A0For example, when a ml=
x or
> mthca QP moves out of RTS, does the HW flush the pending recv WRs? =A0=
=46or
> Chelsio devices, the provider driver/library must handle this.

Yeah, mthca will generate the flush events in hardware IIRC.

So OK, this change makes sense to me... only risk is a spurious
event for empty queues.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
