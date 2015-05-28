From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 for-next 07/14] IB/core: GID attribute should be
 returned from verbs API and cache API
Date: Thu, 28 May 2015 16:50:09 +0300
Message-ID: <CAAKD3BDJtpEhfhsB=o4hc=ARWMt7JgpqvbjXJVvsL_vLZRn8yQ@mail.gmail.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
	<1432045637-9090-8-git-send-email-matanb@mellanox.com>
	<20150519180649.GC18675@obsidianresearch.com>
	<CAAKD3BAifeMcHbDwcaK7F6cjj=mAn3W0Ms2mOmoXDhaquFqKTA@mail.gmail.com>
	<20150520181718.GD28496@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150520181718.GD28496-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 9:17 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, May 20, 2015 at 07:27:15PM +0300, Matan Barak wrote:
>> On Tue, May 19, 2015 at 9:06 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Tue, May 19, 2015 at 05:27:10PM +0300, Matan Barak wrote:
>> >
>> >> +#define __IB_ONLY
>> >
>> > What is this?
>> >
>>
>> I annotated functions that should be called with IB link layer only as
>> __IB_ONLY. I think it's make the code more readable and it could be
>> verified by tools/scripts (like coccinelle) that we're calling those
>> functions under an IB link layer if statement.
>
> Why not add:
>
> BUG_ON(!rdma_is_ib(...))
>
> [or whatever the name ended up as]
>
> To the function prolog?
>
> Then it actually does something..
>

I think static checks suffice here - they have a clear advantage by
forcing users to call these functions under rdma_is_ib if statement.
However, since static checks (still) aren't widely used by all
developers, I can change that to BUG_ON like you suggested.

>> >> + * @gid_type: The GID type to search for.
>> >> + * @net: In RoCE, the namespace of the device.
>> >> + * @if_index: In RoCE, the if_index of the device. Zero means ignore.
>> >>   * @port_num: The port number of the device where the GID value was found.
>> >>   * @index: The index into the cached GID table where the GID was found.  This
>> >>   *   parameter may be NULL.
>> >> @@ -66,10 +82,36 @@ int ib_get_cached_gid(struct ib_device    *device,
>> >>   */
>> >>  int ib_find_cached_gid(struct ib_device *device,
>> >>                      union ib_gid     *gid,
>> >> +                    enum ib_gid_type gid_type,
>> >> +                    struct net         *net,
>> >> +                    int                 if_index,
>> >>                      u8               *port_num,
>> >>                      u16              *index);
>> >
>> > Why are we adding net namespace stuff here? We don't even have a
>> > proposal for roce net namespaces. Same comment for all net adds.
>> >
>>
>> In order to get a netdev, you need to have if_index and namespace.
>> I prefer to introduce a correct API from the beginning than to assume
>> we only use &init_net and changing the API afterwards.
>> roce_gid_table and ib_cache should present a clean API no matter
>> if their consumers use a custom namespace or init_net.
>
> No, this needs to be a cleanup series - get to the point where we are
> sharing the gid table code between the drivers that need it.
>
> Don't change the APIs speculatively for rocev2 or namespaces, those
> series can deal with it on their own.
>

The argument for removing the gid_type seems reasonable to me.
However, I don't think we should be removing net.
if_index should always come with net - passing only if_index makes
roce_gid_table's API a bit broken.

> To be more clear, the goal of this series should only be to get
> patches 11,12,13,14 merged, and the minimum set of other patches to
> get there.
>
> That means we don't need these API changes. We don't need ib_gid_attr.
> Drop patch 8 and 9.
>

Patch 8 (the ndev part) is relevant. GID is now related to a ndev and
we would like
to expose this information to the user.
In non rdma-cm applications, how would a user select the gid_index he wants?

Patch 9 is used by 10, so if we don't drop 10 - we need 9.

> I'm also not sure about patch 10, that looks like a functional
> change? It should not be in a cleanup series.
>

We drop smac and vlan_id from path and av. Instead, it's taken
from the netdev in roce_gid_table. That's a crucial part of the new
architecture.
It's not worth adding roce_gid_table and not taking the parameters
based on its information.

> Is 6 new functionality? Are drivers already handling bonding?
>

The mlx4 driver currently supports bonding - dropping this patch means
functionality regression.

> A cleanup series should have *no functional change*.
>
> So, it looks roughly like 7,8,9,10 can be dropped?
>

So if we sum everything up -
do you agree with:
Patch 7 - Change to BUG_ON, delete gid_type from API
Patch 8 - delete gid_type from sysfs

> Jason

Thanks for looking at this patch.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
