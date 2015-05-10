From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] IB/core, cma: Nice log-friendly string helpers
Date: Sun, 10 May 2015 23:22:14 +0300
Message-ID: <CAJ3xEMj8XwCFt0YTT36Ty50+FYJeVVaB0mQkkV2ig24PAx6jtA@mail.gmail.com>
References: <1431254186-23554-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431254186-23554-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 10, 2015 at 1:36 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Some of us keep revisiting the code to decode IB/RDMA_CM enumerations
> that appear in our logs. Let's borrow the nice logging helpers xprtrdma
> has for CMA events, IB events and WC statuses.

cool,  but as I wrote you earlier today, align RDS too.

> Also, have srp, iser and isert be early adopters.

cool (again), but in a separate patch which follows on the cleanup one
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
