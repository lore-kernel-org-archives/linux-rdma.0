From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Wed, 25 May 2011 09:13:44 -0700
Message-ID: <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1105251507140.16147-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2011 at 5:10 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Roland, this is an updated approach and posting for the patch posted
> earlier by Vlad on which you've responded @
> http://www.spinics.net/lists/linux-rdma/msg02136.html
> I've attempted to address your comment and questions, let me know...

Thanks for looking at this again.  Definitely better in terms of
fewer magic numbers... however I still think needing to set this
with a module parameter kind of sucks for the end user.  Can
we think of a better way to handle this?

Is the issue that we trade off VL cap for MTU?
Does anyone really care about max VL cap with 2K MTU?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
