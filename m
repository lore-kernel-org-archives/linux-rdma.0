From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Thu, 17 Dec 2015 12:04:29 +0200
Message-ID: <CAG9sBKNL9HOczuGDQkk+WmMds51M9jWuyWvQAjeCAQ3H4huKsQ@mail.gmail.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
	<CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
	<567089F1.30004@redhat.com>
	<CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA@mail.gmail.com>
	<5671CBF4.4060602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5671CBF4.4060602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> No, not true.  You are implementing RoCEv2 support, which is an entirely
> new feature.  So this feature can't have had a security hole since
> forever as it has never been in the kernel before now.  The objections
> are arising because of the ordering of events.  Specifically, we added
> the core namespace support (even though it isn't complete, so far it's
> the infrastructure ready for various upper portions of the stack to
> start using, but it isn't a complete stack wide solution yet) first, and
> so this new feature, which will need to be a part of that namespace
> infrastructure that other parts of the IB stack can use, should have its
> namespace support already enabled (ideally, but if it didn't, it should
> at least have a clear plan for how to enable it in the future).  Jason's
> objection is based upon this premise and the fact that a technical
> review of the code makes it look like the core namespace infrastructure
> becomes less complete, not more, with the inclusion of these patches.
>
> As I understand it, prior to these patches there would always be a 1:1
> mapping of GID to gid_index because you would never have duplicate GIDs
> in the GID table.  That allowed an easy, definitive 1:1 mapping of GID
> to namespace via the existing infrastructure for any received packet [1].
>

Incorrect. Even with RoCEv1 you can have 2 GID table entries with the same
GID value but with different VLANs. The conflict in looking for a matching index
was resolved by making the pair <GID, VLAN> as a key for this table. The value
of VLAN was obtained from the completion BTW. All we do now is widen the
definition to include network_type (or L3 protocol if you like) to the
key (and therefore
to the completion structure)

> These patches add the concept of duplicate GIDs that are differentiated
> by their RoCE version (also called network type).  So, now, an incoming
> packet could match a couple different gid_indexes and we need additional
> information to get back to the definitive 1:1 mapping.  The submitted
> patches are designed around a lazy resolution of the namespace,
> preferring to defer the work of mapping the incoming packet to a unique
> namespace until that information is actually needed.  To enable this
> lazy resolution, it provides the network_type so that the resolution can
> be done.
>
You could say that even for native IB. Now, you resolve sgid_index
only when you really
need it (with ib_init_ah_from_wc()) and you don't fill the completion
structure with gid_index
every time you poll.

> This is a fair assessment of the current state of things and what these
> patches do, yes?
>
> Jason's objections are this:
>
> 1)  The lazy resolution is wrong.
> 2)  The use of network_type as the additional information to get to the
> unique namespace is vendor specific cruft that shouldn't be part of the
> core kernel API.

Not true. This is not vendor specific information. Spec says that network_type
be a part of the completion. Honestly, I really don't understand the resistance
from implementing the spec as it is written.
>
> Jason's preference would be that the above issues be resolved by
> skipping the lazy resolution and instead doing proactive resolution on
> receipt of a packet and then probably just pass the namespace around
> instead of passing around the information needed to resolve the
> namespace.  Or, at a minimum, at least make the information added to the
> core API not something vendor specific like network_type, which is a
> detail of the Mellanox implementation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
