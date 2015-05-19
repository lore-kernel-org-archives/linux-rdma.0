From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] IB/core: Check the presence of netlink multicast
 group listeners
Date: Tue, 19 May 2015 11:43:32 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2411@CRSMSX101.amr.corp.intel.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-3-git-send-email-kaike.wan@intel.com>
 <555AC156.7070106@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555AC156.7070106-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 5/18/2015 10:00 PM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > This patch adds a function to check if listeners for a netlink
> > multicast group are present.
> >
> 
> [...]
> 
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -49,6 +49,14 @@ static DEFINE_MUTEX(ibnl_mutex);
> >   static struct sock *nls;
> >   static LIST_HEAD(client_list);
> >
> > +int ibnl_chk_listeners(unsigned int group) {
> > +	if (netlink_has_listeners(nls, group) == 0)
> > +		return -1;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ibnl_chk_listeners);
> 
> I don't see anything here which is special to the IB subsystem, please make it
> generic helper residing in more of a common place.
> 
> Or.

IB specific netlink support is located in this file and we are making use of the nls (netlink socket) variable in this patch.

Kaike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
