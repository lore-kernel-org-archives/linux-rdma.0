From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Save the device attributes on the device structure
Date: Fri, 18 Dec 2015 19:50:57 -0500
Message-ID: <20151219005057.GB3860@phlsvsds.ph.intel.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com> <1450358340-19361-2-git-send-email-ogerlitz@mellanox.com> <5672BC33.9050606@dev.mellanox.co.il> <20151217174138.GB26015@obsidianresearch.com> <5672FF78.40401@sandisk.com> <20151218051632.GE13023@phlsvsds.ph.intel.com> <CAJ3xEMiUnmybdSb9v_WWNxHXZ4NvKfHbK5j4Vum9_8ux1AUo6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiUnmybdSb9v_WWNxHXZ4NvKfHbK5j4Vum9_8ux1AUo6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 18, 2015 at 11:01:24AM +0200, Or Gerlitz wrote:
> On Fri, Dec 18, 2015 at 7:16 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > More than anything what I hate is all the places that allocate struct
> > ib_device_attr just to free it after the query call.
> 
> did you care to look on patches 2-6, this is exactly what they are doing.

Yes I did.  And I don't see how this statement is a problem as that is what
both your's and Christophs patches do.

If anything this was a statement in support of your series.  I'm sorry you
don't see it that way.

However, if we are getting rid of query_device and the last remaining call is
in this first patch why not go all the way and remove that call site as well?

Which is why I also said:

"We discussed this patch ages ago and decided against it and FWIW It does not
hurt my feelings at all to drop it."

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
