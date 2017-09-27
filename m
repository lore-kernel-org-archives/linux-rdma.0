From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-next v3 0/2] iw_cxgb4 pr_debug() changes for 4.14-rc
Date: Wed, 27 Sep 2017 09:13:31 -0500
Message-ID: <006301d3379a$cc4dac10$64e90430$@opengridcomputing.com>
References: <1506497750-19972-1-git-send-email-bharat@chelsio.com> <1506519604.82712.19.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506519604.82712.19.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, 2017-09-27 at 13:05 +0530, Potnuri Bharat Teja wrote:
> > Hi Doug,
> > Current "v3" series is generated on top of your "for-next" branch
> > overriding previous submissions.
> > Please consider these for smoother application of subsequent patches.
> >
> > Changes since "v2"
> > - Revert pr_debug()->pr_warn() change in fw4_ack().
> >
> > Changes since original submission
> > - Make patches on top of "for-next" branch.
> 
> OK, I've taken your v3 of these patches.  But something that jumped out
> at me as a big issue, far bigger than I realized, is just how many
> places in the iw_cxgb4 driver do BUG()s.  Unless the official answer is
> "This can never happen" (in which case we just need to remove the
> conditional and the BUG() behind the conditional, because they can
> never happen), someone needs to spend some time making the iw_cxgb4
> driver more tolerant of things that it might not like, but which
> shouldn't bring the computer to a grinding halt.  In particular, I
> think things like if (skb_cloned(skb)) BUG() does not seem appropriate
> to me.  Are you really telling me that you can't find a way to
> gracefully drop the skb you are working on and simply fail the current
> operation instead of BUG()ing?

Hey Doug,  I agree.  

We will clean up the BUG()s and remove them if they really aren't needed, or perhaps make them WARN_ONCE(), and fail the operations w/o crashing.

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
