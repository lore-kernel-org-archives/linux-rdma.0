From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 9 Jun 2016 10:45:55 -0400
Message-ID: <20160609144554.GA14212@phlsvsds.ph.intel.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com> <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 09, 2016 at 04:17:15PM +0300, Moni Shoua wrote:
>2.  Trying to force SoftRoCE on this model will end up with rxe driver
>registers to rvt with all ib_device hooks implemented. This makes the
>reason to use rvt irrelevant in this case.

Everything? What about AH, MR, PD? Aren't those pretty generic constructs.  
In fact you folks submitted the change for AH.

>3.  Modifying rvt model to make it more suitable for a generic lower
>driver model can have a big effect on QIB/HF1 performance. This
>probably will raise objections from QIB/HF1 owners. In that context I
>want to say that attempts to influence rvt model months ago, when rvt
>was still an idea, were rejected with this exact reason (being bad for
>QIB/HF1 performance).

Yes, performance trumps, that's the nature of the game.

I'm not saying that you have to use rdmavt, however I believe it could be 
possible.  Also I want to make it clear that we are not against changes in 
rdmavt to further its use in other drivers. In fact quite the contrary.  
Changes are welcomed, of course with the caveat that it does not harm 
performance.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
