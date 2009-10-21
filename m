From: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1?
Date: Wed, 21 Oct 2009 16:43:53 -0500
Message-ID: <A53D7B2B-EE41-4ABC-BC02-EE9A100C5DD8@routingdynamics.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com> <f0e08f230910201152g476383ffp8e7392dc0c48e41@mail.gmail.com> <C28CB83A-CF52-4603-91DF-D56865CBEA98@routingdynamics.com> <20091021202346.GO14520@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091021202346.GO14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Oct 21, 2009, at 3:23 PM, Jason Gunthorpe wrote:

> On Wed, Oct 21, 2009 at 02:16:47PM -0500, stuarts wrote:
<snip>
> Hmm, I created the ipoib_mcast_addr_is_valid last month and it seemed
> correct in my testing. I'm surprised to see this.

Looks like you did it right.. see below!

>
> The intention was to catch groups that don't have the right pkey
> set. Everything should be compeltely consistent by this point in the
> code, the dmi_addr should have the pkey included in it. If this is not
> true then the ip tools and other diagnostics will not function
> properly.
>
> What does IP say for your setup? Mine reports this:
>
> $ ip link show dev ib0
> 4: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast  
> state UP qlen 256
>    link/infiniband 80:2e:00:48:fe: 
> 80:00:00:00:00:00:00:00:02:c9:03:00:00:14:a5 brd 00:ff:ff:ff:ff: 
> 12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>
> $ ib1{jgg}~#~/work/iproute2.git/ip/ip maddr show dev ib0
> 4:      ib0
>        link  33:33:ff:fe:f9:2d: 
> 00:00:00:00:00:00:00:00:00:e2:e4:f5:00:df static
>        link  00:ff:ff:ff:ff:12:60:1b:ff:ff:00:00:00:00:00:01:ff: 
> 00:14:a5
>        link  00:ff:ff:ff:ff:12:40:1b:ff:ff: 
> 00:00:00:00:00:00:00:00:00:01
>        link  00:ff:ff:ff:ff:12:60:1b:ff:ff: 
> 00:00:00:00:00:00:00:00:00:01
>
> So:
>          brd 00:ff:ff:ff:ff:12:40:1b:ff:ff: 
> 00:00:00:00:00:00:ff:ff:ff:ff
>        link  00:ff:ff:ff:ff:12:60:1b:ff:ff: 
> 00:00:00:00:00:00:00:00:00:01
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Seems OK to me.

5:	ib0
	link  00:ff:ff:ff:ff:12:60:1b:00:00:00:00:00:00:00:00:00:00:00:fb
	link  00:ff:ff:ff:ff:12:60:1b:00:00:00:00:00:00:00:01:ff:03:24:31
	link  00:ff:ff:ff:ff:12:60:1b:00:00:00:00:00:00:00:00:00:00:00:01
	link  00:ff:ff:ff:ff:12:40:1b:00:00:00:00:00:00:00:00:00:00:00:01
	link  00:ff:ff:ff:ff:12:40:1b:00:00:00:00:00:00:00:00:00:00:00:fb

1b:00:00. oops!

>
> All mcast groups are created in the IP stack using this function:
>
> static inline void ip_ib_mc_map(__be32 naddr, const unsigned char  
> *broadcast, char *buf)
> {
> [..]
>        buf[8]  = broadcast[8];         /* P_Key */
>        buf[9]  = broadcast[9];
> }

And there we have it. I am stuck with the RHEL based kernel. The  
ip_ib_mc_map I have does not even have the broadcast parameter at all  
(naddr and buf only).

>
> So I can't see how you can possibly get a mismatching pkey.
>
> Are you using an upstream kernel or a backport to some RH kernel? What
> does your ip_ib_mc_map function look like? It is a bit of a problem
> for backports because it is inlined and built into the main kernel
> code, if the original RH source for their kernel does not include the
> above then it is broken and backporting the ipoib_mcast_addr_is_valid
> just catches a pre-existing bug (as it was intended, actually)
>
> Can you point me to where you see the 'pkey folding'? Is that present
> in the mainline kernel?

It's in ipoib_mcast_restart_task:
         /* Mark all of the entries that are found or don't exist */
         for (mclist = dev->mc_list; mclist; mclist = mclist->next)  
{                union ib_gid mgid;
                 if (!ipoib_mcast_addr_is_valid(mclist->dmi_addr,
                                                mclist- 
 >dmi_addrlen,                                               dev- 
 >broadcast,priv)) {
ipoib_dbg_mcast(priv, "skipping invalid \n");
                 //      continue;
}
                 memcpy(mgid.raw, mclist->dmi_addr + 4, sizeof mgid);

                 /* Add in the P_Key */
                 mgid.raw[4] = (priv->pkey >> 8) & 0xff;
                 mgid.raw[5] = priv->pkey & 0xff;


Sorry for the extra goop in there. This is gone from the mainline  
kernel, so it is RHEL5.4 + backport that seems to be the problem.

I'll try to check out if these boxes are fully up to date tomorrow.  
Thank you again for the help.

--stuart
--
Stuart Stanley
M: 952-457-3790
stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org
--
"I can only conclude that I'm paying off karma at a vastly accelerated  
rate." - Susan Ivanova in Babylon 5:"Points of Departure"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
