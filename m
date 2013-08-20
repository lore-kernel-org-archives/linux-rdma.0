From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Tue, 20 Aug 2013 13:43:15 -0400
Message-ID: <1377020595.22321.6.camel@frustration.ornl.gov>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org>
	 <52138C6E.6080201@mellanox.com> <5213917B.3020403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5213917B.3020403-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2013-08-20 at 17:55 +0200, Bart Van Assche wrote:
> On 08/20/13 17:34, Sagi Grimberg wrote:
> > Question,
> > If srp now will allow larger queues while using a single global FMR pool
> > of size 1024, isn't it more likely now that in stress environment srp
> > will run out of FMRs to handle IO commands?
> > I mean that let's say that you have x scsi hosts with can_queue size of
> > 512 (+-) and all of them are running IO stress, is it possible that all
> > FMRs will be inuse and no FMR is available to register the next IO SG-list?
> > Did you try out such a scenario?
> >
> > I guess that in such a case IB core will return EAGAIN and SRP will
> > return SCSI_MLQUEUE_HOST_BUSY.
> > I think it is a good Idea to move FMR pools to be per connection rather
> > than a global pool, what do you think?
> 
> That makes sense to me. And as long as the above has not yet been 
> implemented I'm fine with dropping patch 8/8 from this patch set.

Don't drop it; most configs won't have all that many connections and
shouldn't have an issue; even those that do will only see a potential
slowdown when running with everything at once.

We can address the FMR/BMME issues on top of this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
