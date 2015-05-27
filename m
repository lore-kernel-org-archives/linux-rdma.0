From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Wed, 27 May 2015 16:42:06 -0600
Message-ID: <20150527224206.GB7855@obsidianresearch.com>
References: <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <1432659226.28905.151.camel@redhat.com>
 <20150526181336.GD11800@obsidianresearch.com>
 <1432672378.28905.178.camel@redhat.com>
 <20150526211114.GB4502@obsidianresearch.com>
 <1432736046.28905.215.camel@redhat.com>
 <20150527171143.GB9909@obsidianresearch.com>
 <1432749191.28905.243.camel@redhat.com>
 <CAJ3xEMjXXKy=DSeksTFEX-GAN=nYm_6nn5msvsYOwnp0roEHJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjXXKy=DSeksTFEX-GAN=nYm_6nn5msvsYOwnp0roEHJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 12:58:59AM +0300, Or Gerlitz wrote:
> On Wed, May 27, 2015 at 8:53 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, 2015-05-27 at 11:11 -0600, Jason Gunthorpe wrote:
> > Well, let's just be clear: netlink/iproute2 screwed the pooch on their
> > implementation of this stuff.  Any solution that doesn't include fixing
> > this up in some way is not really a good solution.
> 
> >>  For instance iproute2 would need IB specific code to format
> >> the 'ip link show' (review print_vfinfo in iproute2) and to length
> >> check 'ip link set vf mac'
> 
> >> If we do use 8, then it would be ideal (and my strong preference) to
> >> also fix the IFLA_VF_MAC message to have a working length. I think
> >> that could be done compatibly with a bit of work. At least that way
> >> iproute2 can be kept clean when it learns to do IB, and we could have
> >> the option again of using 20 someday if we need.
> >>
> 
> > Sounds like a reasonable plan.
> > Or, this is your patch set, are you going to pick up these action items?
> 
> Let see
> 
> >> So to be clear, to go with the 8 byte option I suggest:
> 
> >>  - Engage netdev/iproute and confirm they are philosophically OK
> >>    with IFLA_VF_MAC != IFLA_ADDRESS
> 
> the last thing netdev are is having philosophical views, they are very
> practical (and non-perfect and happy and lively community), the one
> thing before the last  netdev are is caring for the rdma subsystem. If
> something has to change @ their direct part, we should come with
> patches.

Yes, you need to talk in patches, I will suggest you start with this
(totally untested, quickly thrown together):

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8de36824018d..715b59e9925a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1172,7 +1172,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 				nla_nest_cancel(skb, vfinfo);
 				goto nla_put_failure;
 			}
-			if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
+			if (nla_put(skb, IFLA_VF_MAC, sizeof(u32) + dev->addr_len, &vf_mac) ||
 			    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
 			    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
 				    &vf_rate) ||
@@ -1292,7 +1292,8 @@ static const struct nla_policy ifla_vfinfo_policy[IFLA_VF_INFO_MAX+1] = {
 };
 
 static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
-	[IFLA_VF_MAC]		= { .len = sizeof(struct ifla_vf_mac) },
+	[IFLA_VF_MAC]		= { .type = NLA_BINARY,
+				    .len = sizeof(struct ifla_vf_mac) },
 	[IFLA_VF_VLAN]		= { .len = sizeof(struct ifla_vf_vlan) },
 	[IFLA_VF_TX_RATE]	= { .len = sizeof(struct ifla_vf_tx_rate) },
 	[IFLA_VF_SPOOFCHK]	= { .len = sizeof(struct ifla_vf_spoofchk) },
@@ -1447,6 +1448,21 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr *attr)
 		switch (nla_type(vf)) {
 		case IFLA_VF_MAC: {
 			struct ifla_vf_mac *ivm;
+			int sz;
+
+			/* Legacy compatability, old iproute2 will pass in 32
+			 * bytes for everything, assume it is a 6 byte MAC
+			 * because that is all old iproute really supported.
+			 */
+			sz = nla_len(attr);
+			if (sz == 36)
+				sz = 10;
+
+			if (sz != (sizeof(u32) + dev->addr_len)) {
+				err = -EINVAL;
+				break;
+			}
+
 			ivm = nla_data(vf);
 			err = -EOPNOTSUPP;
 			if (ops->ndo_set_vf_mac)

And make the argument why the above is OK.
 - Reader side only ever read 6 bytes anyhow, so it doesn't matter
   that ifla_vf_mac is undersized in the RTA_DATA
 - Confirm any other users of this (openstack?) you know are similarly
   OK.
 - Old write side will always send the full 36 byte struct, so
   assume 6 bytes.
 - Justify this as needing to add IB support next which does not use a
   6 byte addr_len
   New code that wants to work with IB will have to use correct lengths.

Then based on that iproute2 can be fixed in the two areas I pointed
out, doing that at the same time will probably earn some rep.

Finally you can make a patch that switches addr_len to something else
- that would trigger the philosophical question of 'what actually is a
IFLA_VF_MAC', if everyone is OK with changing it then golden.

> >>  - Make a iproute patch to use the IFLA_VF_MAC size in print_vfinfo
> >>    instead of hardcoded ETH_ALEN (using len == 32 mean len 6 for compat)
> 
> I was thinking to patch iproute to sense the link type: if eth print
> six bytes, if ipoib print 8 bytes, simple.

This is against the design ideals of netlink: a tool like iproute
should not need link specific knowledge to parse kernel messages.

Now is the best time to make this fix because we can use the sz == 36
so sz == 10 assumption.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
