From: chas williams - CONTRACTOR <chas-vT06rRrALxcmhCb6mdbn6A@public.gmane.org>
Subject: Re: ib_srp and sg_tablesize
Date: Wed, 28 Dec 2011 15:20:54 -0500
Message-ID: <20111228152054.718e5be5@thirdoffive.cmf.nrl.navy.mil>
References: <CAO+b5-ow93i7RuZuzg8XLO-wveVjJuZOG+weaHLvbH8H09=+RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-ow93i7RuZuzg8XLO-wveVjJuZOG+weaHLvbH8H09=+RQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 28 Dec 2011 19:46:14 +0000
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> value of sg_tablesize in the SRP login string but ignores that value
> entirely. Was that on purpose ? Shouldn't the statement
> "target->sg_tablesize = indirect_sg_entries ? : cmd_sg_entries" rather
> have been something like "if (!target->sg_tablesize)
> target->sg_tablesize = indirect_sg_entries ? : cmd_sg_entries" ?

srp_parse_options() happens after target->sg_tablesize is initialized
by this statement.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
