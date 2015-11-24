From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 5/9] IB/core: Add rdma_network_type to wc
Date: Tue, 24 Nov 2015 15:47:51 +0200
Message-ID: <CAAKD3BCWMrd8A+UgjQg+jtfLmyOCaOB4iGCr2ZAbaazRBZeGxw@mail.gmail.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
	<1444925232-13598-6-git-send-email-matanb@mellanox.com>
	<20151123211916.GA6062@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151123211916.GA6062-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 11:19 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> +     /* Use the hint from IP Stack to select GID Type */
>> +     network_gid_type = ib_network_to_gid_type(addr->dev_addr.network);
>> +     if (addr->dev_addr.network != RDMA_NETWORK_IB) {
>> +             route->path_rec->gid_type = network_gid_type;
>> +             /* TODO: get the hoplimit from the inet/inet6 device */
>> +             route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;
>
> Uh, that is more than a TODO, that is showing this is all messed up.
>
> It isn't just the hop limit that has to come from the route entry, all
> the source information of the path comes from there. Ie the gid table
> should accept the route entry directly and spit out the sgid_index.
>
> The responder side is the same, it also needs to do a route lookup to
> figure out what it is doing, and that may not match what the rx says
> from the headers. This is important stuff.
>

The only entity that translates between IPs and GIDs is the RDMACM.
The GID cache is like a database. It allows one to store, retrieve and
query the GIDs and GID attrs it stores.
roce_gid_mgmt, is the part that populates this "dumb" database.
IMHO, adding such a "smart" layer to the GID cache is wrong, as this
should be part of RDMACM which does the translation. No need to get
the gid cache involved.


> I really don't like the API changes that went in with the last series
> that added net_dev and gid_attr everywhere, that just seems to be
> enabling mistakes like the above. You can't use rocev2 without doing
> route lookups, providing APIs that don't force this to happen just
> encourages broken flows like this.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
