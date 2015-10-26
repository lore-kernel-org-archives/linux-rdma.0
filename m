From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-RC] IB/cm: Fix rb-tree duplicate free and
 use-after-free
Date: Mon, 26 Oct 2015 17:39:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A9738711@ORSMSX109.amr.corp.intel.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734333@ORSMSX109.amr.corp.intel.com>
 <561FC309.2030102@mellanox.com> <5626A39D.6030906@redhat.com>
 <5627EE5A.7030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5627EE5A.7030303-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Sean, I need to close on this patch.  What is your position after
> > Matan's explanation?
> >
> 
> Absent an objection from Sean, I've pulled this in.  A use after free
> bug is a pretty serious issue, and you've listed an error flow that
> triggers it.  The only thing bugging me is that this code is 10+ years
> old and this didn't show up until now, which makes me think that some
> recent change is the cause of this.  I've made note of that fact in my
> tag commit and I think this warrants further examination in the next
> kernel cycle.  But since we are so close to out of time on 4.3, I deemed
> it better to fix the use after free issue, even if it isn't necessarily
> the perfect fix, than leave that hanging about.

I was out last week.  I think one of the reasons that this bug hasn't shown up is that very few apps use UD QPs, and those that do likely exchange QP information using some other out of band mechanism.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
