From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Thu, 21 May 2015 22:55:20 +0300
Message-ID: <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	<1432226406.28905.22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432226406.28905.22.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 7:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> The MAC/GUID mapping isn't the only thing that has to be faked here

Exactly nothing is faked here, Virtualization systems such as
open-stack provision unique 48 bit mac values to VMs, and it's
perfectly legitimate and viable to derive 64 bit guid value from that
mac.

> Why are we suggesting to make this work with unmodified software?  Why
> aren't we doing this right and adding a new ndo entry point for the GUID?

Because rome wasn't built in a day and nor will be the support for IB
in today's/tomorrow's virtualization systems, e.g if you follow on
this layering

[1] Open-Stack / ODL controller
[2] Open-Stack neutron / ODL agent
[3] libvirt
[4] user/kernel netlink API
[5] kernel ndo API
[6] ipoib
[7] kernel verbs API
[8] PF IB driver

with the approach presented here,  we only simply (yeah, simplicity
could turn to be critical criteria in engineering) to few kernel only
patches that deal with layers 6-8 and we are ready for all sorts of
bring-ups, testing and even production!

For reasons which I don't really see the practical / real life use
case where there's a must to get them to work (but I will happy to
hear on) one can go & change the world, namely patch layers 5 ---> 1
too and deal with all sort of dependencies for setting up a system.
But guess what, this can be perfectly done in parallel with this small
change.

> you would also have to fake the vlan/pkey mapping.  This just
> seems the wrong thing to do.

Repeating the above argument --- virt systems provision 12bit vlan-id
to be set for VM traffic, which can be nicely map to 16 bit IB pkey
doing the same job.

I understand that you have sort of  desire to see IB ala the full spec
going into libvirt and from there up to the whole virtualization
management space, but this doesn't need as an argument to not enable
doing thing in the right direction. The upstream kernel supports SRIOV
for IB over mlx4 for 3 years now, but this can't work with libvirt as
is. Using these patches can make the thing.

Couple of months ago, we both attended a call with the libvirt
developers / maintainers from red-hat and they really liked this
staged approach.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
