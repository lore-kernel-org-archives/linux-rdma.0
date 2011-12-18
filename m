From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/14] ib_srp: Disallow duplicate logins
Date: Sun, 18 Dec 2011 16:40:45 -0500
Message-ID: <1324244446.17849.39.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112011958.17339.bvanassche@acm.org>
	 <1323976101.16703.42.camel@lap75545.ornl.gov>
	 <CAO+b5-r6dHt-vmbNjeD4zvcAaRVqhiEm5eZF7hgF6ei35kqjdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-r6dHt-vmbNjeD4zvcAaRVqhiEm5eZF7hgF6ei35kqjdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2011-12-18 at 19:20 +0000, Bart Van Assche wrote:
> On Thu, Dec 15, 2011 at 7:08 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Thu, 2011-12-01 at 19:58 +0100, Bart Van Assche wrote:
> > > Currently the ib_srp driver allows to log in multiple times to the
> > > same target via its sysfs interface. This leads to each target LUN
> > > being imported multiple times at the initiator side, something that
> > > should not be allowed.
> >
> > I'm of mixed opinion on this one. It seems like we're working around a
> > broken target -- we request single RDMA channel operation in our login
> > requests, so the standard says that the target should disconnect all
> > other connections for that I_T nexus when it receives a new login
> > request. That should keep us from having multiple instances of LUNs from
> > the same target over a single srp_host (HCA).
> >
> > In the past, we've seen connections having issues but not going away,
> > and the only way to kill them was to create a new connection to the RAID
> > controller, which would then kill the old one. It's been a few years
> > since I've seen this, so the details are a bit fuzzy, but I recall the
> > current behavior being useful.
> >
> > However, I'm not adverse to going beyond the standard if it makes sense,
> > and your later patch to allow disconnecting channels without removing
> > the module would fix the use case above. What problem are we solving
> > here other than a potentially confused admin?
> 
> I agree that relogin is a useful feature. But I doubt the way it works
> now is fine because during a certain time window all LUNs appear twice
> at the initiator side - half of them working, half of them not.
> Relogin is still possible with this patch set, but it requires an
> extra step: deleting a target before attempting to log in again.

According to the spec, they should only appear once -- the old
connection should be disconnected before the new login request is
accepted. Of course, the spec does not always match reality, though it
has worked that way on the HW I've tested. But as I said, I'm fine with
adding this to the initiator -- I just want good justification.

> > > +     spin_lock(&host->target_lock);
> > > +     list_for_each_entry(t, &host->target_list, list) {
> > > +             WARN_ON(t == target);
> > > +             if (target->id_ext == t->id_ext &&
> > > +                 target->ioc_guid == t->ioc_guid &&
> > > +                 memcmp(target->orig_dgid, t->orig_dgid, 16) == 0 &&
> > > +                 target->path.pkey == t->path.pkey &&
> > > +                 target->service_id == t->service_id) {
> >
> > The spec discusses the I_T nexus defined by the initiator and target
> > port identifiers as the unit for disambiguation when running in single
> > channel mode. The initiator port identifier is controlled by the port's
> > GUID combined with target->initiator_ext and the target port identifier
> > is defined by target->{id_ext,ioc_guid}.
> >
> > From the standard's perspective, why should we care about pkey, dgid (or
> > orig_dgid as above) or the service id? Those don't change the I_T nexus,
> > so the target should disconnect previous channels appropriately.
> 
> I'm fine with leaving out the PKey and the service ID. But I'm not
> sure it's fine to leave the DGID out because leaving out the DGID will
> prevent setting up redundant connections from an initiator to a target
> with multiple active IB ports. The reason the orig_dgid is being used
> in the above comparison instead of dgid is because these two ID's may
> differ due to automatic path migration.

A SRP target port (for the purposes of an I_T nexus) is defined by the
IOC GUID and extension; if you want to have redundant connections to a
port, multi-channel logins must be supported. The way most targets avoid
this issue is to present a different IOC on each IB port, though you
should be also able to export multiple ServiceEntries in the
IOControllerProfile response to allow different service extensions to be
selected.

As for APM, I thought we had determined the last time it came up that
implementing that would require protocol changes to SRP. I haven't gone
back to refresh my memory -- and it isn't implemented yet either way, so
we could go back and relax this check as part of the implementation.

> > > +     ret = srp_target_exists(host, target);
> > > +     if (ret)
> > > +             goto err;
> > > +
> >
> > We need to tell the user that we didn't create a new connection because
> > one already exists.
> 
> Does that mean that you'd like to see a pr_err() in addition to the
> error code returned via the sysfs write() call ?

Yes, similar to what we do for bad parameters in srp_parse_options().
Most scripts use echo to add a target, and only see succeed/fail; the
admin will need a way to see what failed. The errno is useful to daemons
using write(), though.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
