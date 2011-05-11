From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwcm: Get rid of enum iw_cm_event_status
Date: Wed, 11 May 2011 10:56:19 -0700
Message-ID: <BANLkTi=7C3+H2BwYpsnooeLHck-DyVfYtQ@mail.gmail.com>
References: <1305005199-4943-1-git-send-email-roland@kernel.org> <4DCA2756.3060900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DCA2756.3060900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Roland, so how did you manage to see that warning, is it your plane gcc
> (what version?) or through using some static checker? for example, I don't
> see it with the latest sparse.

Just the normal gcc 4.5 from Ubuntu 11.04:

    gcc (Ubuntu/Linaro 4.5.2-8ubuntu4) 4.5.2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
