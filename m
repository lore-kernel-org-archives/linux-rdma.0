From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 5/9] IB/core: Add rdma_network_type to wc
Date: Wed, 25 Nov 2015 16:18:25 +0200
Message-ID: <CAAKD3BAEMD47cScunGNnx2iitL6uFWicDHALJt5w-szoSZwOwg@mail.gmail.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
	<1444925232-13598-6-git-send-email-matanb@mellanox.com>
	<20151123211916.GA6062@obsidianresearch.com>
	<CAAKD3BCWMrd8A+UgjQg+jtfLmyOCaOB4iGCr2ZAbaazRBZeGxw@mail.gmail.com>
	<20151124181415.GC10391@obsidianresearch.com>
	<CAAKD3BAO6rNn-Br=MZxvkd+rYSsE9G7wK+9YR9uJ3xdP1U+u0w@mail.gmail.com>
	<20151125065542.GC4326@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151125065542.GC4326-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2015 at 8:55 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Nov 24, 2015 at 09:07:41PM +0200, Matan Barak wrote:
>
>> IMHO, the user is entitles to choose any valid sgid_index for the
>> interface. Anything he chooses guaranteed to be valid (from security
>> perspective)
>
> No, the namespace patches will have to limit the sgid_indexes that can
> be used with a QP to those that fall within the namespace. This is
> another reason I don't like this approach for the kapi.
>

By saying namespace, do you mean net namespaces?
If so, the gid cache allows to search by net device (and there's a
"custom" search that the user can define a filter function which can
filter by net).
Anyway, I don't think this cache should be used other than a simple database.

>> Why do we need to block users who use ibv_rc_pingpong and chose the
>> GID index correctly by hand?
>
> I'm not really concerned with user space, we are stuck with exporting
> the gid index there.
>

So why do we need to block kernel applications from doing the same
things user-space application can do?

>> > OK. Change the gid cache so only a RDMA CM private API can return
>> > rocev2 gids.
>>
>> So you propose to block verbs applications from using the RoCE v2 GIDs? Why?
>
> Just the kernel consumers, so the in-kernel users are correct.
>

If there are kernel consumers that want to work with verbs directly,
they should use ib_init_ah_from_wc and ib_resolve_eth_dmac (or we can
rename that for other L2 attributes).
The shared code shouldn't be in the cache.

> Jason

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
