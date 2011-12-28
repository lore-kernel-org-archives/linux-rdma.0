From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: ib_srp and sg_tablesize
Date: Wed, 28 Dec 2011 16:04:04 -0500
Message-ID: <1325106244.3004.31.camel@obelisk.thedillows.org>
References: <CAO+b5-ow93i7RuZuzg8XLO-wveVjJuZOG+weaHLvbH8H09=+RQ@mail.gmail.com>
	 <20111228152054.718e5be5@thirdoffive.cmf.nrl.navy.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111228152054.718e5be5-KCdNrDJlFBBhNwqIksvPR6qiWZVw4kCD+aIohriVLy8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chas williams - CONTRACTOR <chas-vT06rRrALxcmhCb6mdbn6A@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-12-28 at 15:20 -0500, chas williams - CONTRACTOR wrote:
> On Wed, 28 Dec 2011 19:46:14 +0000
> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> 
> > value of sg_tablesize in the SRP login string but ignores that value
> > entirely. Was that on purpose ? Shouldn't the statement
> > "target->sg_tablesize = indirect_sg_entries ? : cmd_sg_entries" rather
> > have been something like "if (!target->sg_tablesize)
> > target->sg_tablesize = indirect_sg_entries ? : cmd_sg_entries" ?
> 
> srp_parse_options() happens after target->sg_tablesize is initialized
> by this statement.

Right, we set defaults based on module parameters, then let the user
override them with the login string.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
