From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [BUG] SRP daemon and SM migration
Date: Mon, 4 Dec 2017 12:08:32 +0100
Message-ID: <bd47faf6-eae0-d520-42ce-eb3d6bce4376@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi

A bug was reported to SUSE concerning the srp_daemon.
When it's running and the matser SM changes host (host shutdown, or new higher priority SM started), srp_daemon outputs these errors at every scan:
srp_daemon[25394]: No response to inform info registration
srp_daemon[25394]: Fail to register to traps, maybe there is no opensm running on fabric or IB port is down

It seems this was introduced by this commit:
commit 4952e5f7df0c93d6f3972975106c5e06623a301d
Author: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Mar 21 17:38:11 2013 +0200

    Fix a memory leak
   
    Avoid leaking one IB AH per rescan. Only allocate a new AH if the
    port LID changed or after a LID has been assigned by the SM.
   
    Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
    Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


One of the side effect of the leak fix is that create_ah is only called when the local port lid changes.
And register_to_traps uses the sm_id from ud_res which is filled by create_ah.

Thus if the SM lid changes but not the local LID, it keeps trying to contact the previous LID.

I tried fixing it by getting get_port_lid to also return the SM lid and calling create_ah on local lid OR SM lid changes.
It seems to be working at first (at least the call is always done to the right lid).
But after a while (doing ping pong between 2 SM by changing the priority) I still end up getting the error above.
Even through the LID is right this time.

It may not be the same bug though. Is there some calls to do to unregister from the previous SM before registering to the new one ?
Any idea on what could cause this ? I don't seem to get any more infos in all the logs I've checked...

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
