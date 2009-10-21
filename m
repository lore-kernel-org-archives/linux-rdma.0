From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1?
Date: Wed, 21 Oct 2009 14:23:46 -0600
Message-ID: <20091021202346.GO14520@obsidianresearch.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com> <f0e08f230910201152g476383ffp8e7392dc0c48e41@mail.gmail.com> <C28CB83A-CF52-4603-91DF-D56865CBEA98@routingdynamics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C28CB83A-CF52-4603-91DF-D56865CBEA98-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 02:16:47PM -0500, stuarts wrote:

> I did a lot more tracing on the sender side. I think I see what is  
> happening: The sender uses the IP_ADD_MEMBERSHIP socket op. The IP
> stack (via the dev->mc_list multicast list) tries to create the  
> following MGIDs:
> ff12:401b:ffff:0000:0000:0000:0100:0025
> ff12:601b:ffff:0000:0000:0000:0000:00fb
> ff12:601b:ffff:0000:0000:0001:ff03:2431
> ff12:601b:ffff:0000:0000:0000:0000:0001
> ff12:401b:ffff:0000:0000:0000:0000:0001
> ff12:401b:ffff:0000:0000:0000:0000:00fb
> 
> The first one is mine, and the others are in the admin band (***1 is  
> all-hosts, for example).
>
> This looks like it is valid, BUT, the call to  
> ipoib_mcast_addr_is_valid occurs BEFORE the pkey is folded in from the  
> ipoib_dev_priv structure. Printing out the pre-fold-in values shows:
> 00ffffffff12601b0000000000000000000000fb
> 
> (This is the dev_mc_list -> dmi_addr value)
> 
> Oops, that pkey is "wrong" (0 vs ffff). Out this address goes!

Hmm, I created the ipoib_mcast_addr_is_valid last month and it seemed
correct in my testing. I'm surprised to see this.

The intention was to catch groups that don't have the right pkey
set. Everything should be compeltely consistent by this point in the
code, the dmi_addr should have the pkey included in it. If this is not
true then the ip tools and other diagnostics will not function
properly.

What does IP say for your setup? Mine reports this:

$ ip link show dev ib0
4: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast state UP qlen 256
    link/infiniband 80:2e:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:00:14:a5 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff

$ ib1{jgg}~#~/work/iproute2.git/ip/ip maddr show dev ib0
4:      ib0
        link  33:33:ff:fe:f9:2d:00:00:00:00:00:00:00:00:00:e2:e4:f5:00:df static
        link  00:ff:ff:ff:ff:12:60:1b:ff:ff:00:00:00:00:00:01:ff:00:14:a5
        link  00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:00:00:00:01
        link  00:ff:ff:ff:ff:12:60:1b:ff:ff:00:00:00:00:00:00:00:00:00:01

So:
          brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
        link  00:ff:ff:ff:ff:12:60:1b:ff:ff:00:00:00:00:00:00:00:00:00:01
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Seems OK to me.

All mcast groups are created in the IP stack using this function:

static inline void ip_ib_mc_map(__be32 naddr, const unsigned char *broadcast, char *buf)
{
[..]
        buf[8]  = broadcast[8];         /* P_Key */
        buf[9]  = broadcast[9];
}

So I can't see how you can possibly get a mismatching pkey.

Are you using an upstream kernel or a backport to some RH kernel? What
does your ip_ib_mc_map function look like? It is a bit of a problem
for backports because it is inlined and built into the main kernel
code, if the original RH source for their kernel does not include the
above then it is broken and backporting the ipoib_mcast_addr_is_valid
just catches a pre-existing bug (as it was intended, actually)

Can you point me to where you see the 'pkey folding'? Is that present
in the mainline kernel?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
