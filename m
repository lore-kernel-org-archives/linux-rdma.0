From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Thu, 20 Oct 2011 09:47:47 -0700
Message-ID: <CAL1RGDVWUGgm=jNsGyPqdEJvP+dbh_BbGKWhjnX=AieD9gXLrg@mail.gmail.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com>
 <1319049335.18132.34.camel@haakon2.linux-iscsi.org> <CAO+b5-oJ38L7t=spKQPnEZxNOA6zoqG9DA3uw9q+eOTVvELRUA@mail.gmail.com>
 <1319051341.18132.53.camel@haakon2.linux-iscsi.org> <CAO+b5-quJkZdSsAmL1gZz1V6mwB3Q8abOu_Q+96MxO89bhg6EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-quJkZdSsAmL1gZz1V6mwB3Q8abOu_Q+96MxO89bhg6EA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 11:24 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> If you have a look at the output of the command ibv_devices -v
> (maintained by Roland), you will see that in the output of that
> command ports are identified by a 64-bit GUID.

Where would I see that?  Seriously, I don't know where ibv_devices
prints anything about ports.  It lists device by "node GUID" which is
a globally unique ID, but that is per-adapter (and of course 2-port
adapters are very common).

It is true that every port does have a port GUID, but those are not
used in most places -- typically we use a port GID.  Again, it is
true that GID table entry 0 must be formed by taking the subnet
prefix (assigned by the subnet manager) and appending the
port GUID.

To be honest I've kind of lost track of where this leads: what
exactly are we trying to figure out how to identify?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
