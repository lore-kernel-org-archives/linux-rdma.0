From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] use setup_timer() helper function.
Date: Fri, 29 Sep 2017 11:23:53 -0400
Message-ID: <1506698633.2919.17.camel@redhat.com>
References: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
         <1506519781.82712.21.camel@redhat.com>
         <CAOMdWSKD-h4y-ggh7m-_kNV+0PMJC+Nf7Bj02CF7Q6rjMtRniw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOMdWSKD-h4y-ggh7m-_kNV+0PMJC+Nf7Bj02CF7Q6rjMtRniw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Allen <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-29 at 12:36 +0530, Allen wrote:
> > 
> > This patch series is rejected.  If you are doing a "thing", such as
> > update a driver to use setup_timer(), then you do one patch for an
> > entire driver, and on trivial items such as this, even better would
> > be
> > just one patch for all of the drivers under infiniband/hw.  But you
> > do
> > *not* do one patch per timer.
> > 
> 
> I'll get that done and send out v2.

Keep in mind that I just took a patch to the timer code in the qib
driver, so you might need to wait until I've pushed my tree out today
and then rebase your work on it and drop out anything that's already
been done.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
