From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 5/9] IB/core: Add rdma_network_type to wc
Date: Tue, 24 Nov 2015 21:07:41 +0200
Message-ID: <CAAKD3BAO6rNn-Br=MZxvkd+rYSsE9G7wK+9YR9uJ3xdP1U+u0w@mail.gmail.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
	<1444925232-13598-6-git-send-email-matanb@mellanox.com>
	<20151123211916.GA6062@obsidianresearch.com>
	<CAAKD3BCWMrd8A+UgjQg+jtfLmyOCaOB4iGCr2ZAbaazRBZeGxw@mail.gmail.com>
	<20151124181415.GC10391@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124181415.GC10391-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2015 at 8:14 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Nov 24, 2015 at 03:47:51PM +0200, Matan Barak wrote:
>> > It isn't just the hop limit that has to come from the route entry, all
>> > the source information of the path comes from there. Ie the gid table
>> > should accept the route entry directly and spit out the sgid_index.
>> >
>> > The responder side is the same, it also needs to do a route lookup to
>> > figure out what it is doing, and that may not match what the rx says
>> > from the headers. This is important stuff.
>> >
>>
>> The only entity that translates between IPs and GIDs is the RDMACM.
>
> The rocev2 stuff is using IP, and the gid entry is now overloaded to
> specify IP header fields.
>

The GID entry is now overloaded to expose GID metadata. For example,
ndev (for L2 Ethernet attributes) and GID type.

> Absolutely every determination of IP header fields needs to go through
> the route table, so every single lookup that can return a rocev2 SGID
> *MUST* use route data.
>
> The places in this series where that isn't done are plain and simply
> wrong.
>

IMHO, the user is entitles to choose any valid sgid_index for the
interface. Anything he chooses guaranteed to be valid (from security
perspective), but doesn't guarantee to work if both sides don't use
IPs that can be routed successfully to the destination.
Why do we need to block users who use ibv_rc_pingpong and chose the
GID index correctly by hand?

> The abstraction at the gid cache is making it too easy to make this
> mistake. It is enabling callers to do direct gid lookups without a
> route lookup, which is unconditionally wrong. Every call site into the
> gid cache I looked at appears to have this problem.
>

We can and should guarantee rdma-cm users get the right GID every time.
I don't think we should block users of choosing either a correct GID
or an incorrect GID, that's up to them.
We're only providing a correct database that these users can query and
a right rdma-cm model.

> The simplest fix is to have a new gid cache api for rocve2 that
> somehow forces/includes the necessary route lookup. The existing API
> cannot simply be extended for rocev2.
>
>> roce_gid_mgmt, is the part that populates this "dumb" database.
>> IMHO, adding such a "smart" layer to the GID cache is wrong, as this
>> should be part of RDMACM which does the translation. No need to get
>> the gid cache involved.
>
> OK. Change the gid cache so only a RDMA CM private API can return
> rocev2 gids.
>

So you propose to block verbs applications from using the RoCE v2 GIDs? Why?

> Jason

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
