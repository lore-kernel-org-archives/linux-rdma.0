From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1? (OFED BACKPORT BUG)
Date: Wed, 21 Oct 2009 16:08:37 -0600
Message-ID: <20091021220837.GP14520@obsidianresearch.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com> <f0e08f230910201152g476383ffp8e7392dc0c48e41@mail.gmail.com> <C28CB83A-CF52-4603-91DF-D56865CBEA98@routingdynamics.com> <20091021202346.GO14520@obsidianresearch.com> <A53D7B2B-EE41-4ABC-BC02-EE9A100C5DD8@routingdynamics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A53D7B2B-EE41-4ABC-BC02-EE9A100C5DD8-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 04:43:53PM -0500, stuarts wrote:

>> All mcast groups are created in the IP stack using this function:
>>
>> static inline void ip_ib_mc_map(__be32 naddr, const unsigned char  
>> *broadcast, char *buf)
>> {
>> [..]
>>        buf[8]  = broadcast[8];         /* P_Key */
>>        buf[9]  = broadcast[9];
>> }
>
> And there we have it. I am stuck with the RHEL based kernel. The  
> ip_ib_mc_map I have does not even have the broadcast parameter at all  
> (naddr and buf only).

Ah, that is what I suspected, OK this makes sense now.

This is a bug in the backport, it is very serious since multicast
does not work as it is.

The code you identified in ipoib_mcast_restart_task is part of
the backport, and is designed to work around the above limitations.

I would remove it, and do the following (untested) instead:

--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -814,6 +814,13 @@ void ipoib_mcast_restart_task(struct work_struct *work)
        for (mclist = dev->mc_list; mclist; mclist = mclist->next) {
                union ib_gid mgid;
 
+               /* Work around broken ip_ib_mc_map */
+               if (mclist->dmi_addrlen == INFINIBAND_ALEN) {
+                       mclist->dmi_addr[5] = 0x10 | (dev->broadcast[5] & 0xF);
+                       mclist->dmi_addr[8] = dev->broadcast[8];
+                       mclist->dmi_addr[9] = dev->broadcast[9];
+               }
+
                if (!ipoib_mcast_addr_is_valid(mclist->dmi_addr,
                                               mclist->dmi_addrlen,
                                               dev->broadcast))

This is better than the current stuff since it preserves the intent of
the ip_ib_mc_map patches, and it adjusts the dmi_addr directly so ip
maddr reports the correct address to aid in debugging.

> Sorry for the extra goop in there. This is gone from the mainline  
> kernel, so it is RHEL5.4 + backport that seems to be the problem.

Correct. We need someone to pick up the above patch for the
backports. I don't know who that is (someone please speak up?)

If you can confirm the above does it for you then it would probably
help the backporter.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
