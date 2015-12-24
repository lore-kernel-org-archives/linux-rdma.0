From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 00/32] Soft-RoCE driver
Date: Thu, 24 Dec 2015 06:20:47 -0800
Message-ID: <20151224142047.GA29757@infradead.org>
References: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
 <20151224100228.GB21387@infradead.org>
 <CAJ3xEMiR7gcgScbiCkx3YpXJpJO4LYHvUY=1kpxxwiGtudF-qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiR7gcgScbiCkx3YpXJpJO4LYHvUY=1kpxxwiGtudF-qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 02:58:10PM +0200, Or Gerlitz wrote:
> On Thu, Dec 24, 2015 at 12:02 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > On Thu, Dec 24, 2015 at 11:17:46AM +0200, Kamal Heib wrote:
> >> We've located the driver in the staging subtree. This follows a requirement
> >> to implement an IB transport library - Soft RoCE is in the same boat like the hfi1
> >> driver. We need to define and implement a lib to prevent those code
> >> duplications.
> >
> > Given the trainwreck that the staging process is it might seems more
> > sensible to get it into a stage and then merge it directly.  You'll
> > probably save yourself a lot of work that way.
> 
> I am not sure what you mean by "get it into a stage and then merge it
> directly" --i
> is that not go through staging at all?

Sorry, I should have not finished that email in a hurry before leaving
the house.  Let me rephrase:

Given the trainwreck that the staging process is it, might be more
sensible to get it into shape and then merge it directly.  You'll
probably save yourself a lot of work that way.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
