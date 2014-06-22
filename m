From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: why flipping responder_resources/initiator_depth?
Date: Sun, 22 Jun 2014 10:42:51 +0300
Message-ID: <53A688FB.6070600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

So we just noted that the IB CM @ cm_format_req_event() flips the values 
of RDMA READ initiator-depth and responder-resources advertized in the 
client through the REQ when before it delivers the event to the server 
(and the same is done the other way around in cm_format_rep_event()).

Any special reason for that? specifically, it doesn't comply with our 
common sense (...) and the text in the  rdma_connect/rdma_accept man 
pages http://linux.die.net/man/3/rdma_connect that say:

responder_resources - The maximum number of outstanding RDMA read and 
atomic operations that the local side will accept from the remote side. 
[...]

initiator_depth - The maximum number of outstanding RDMA read and atomic 
operations that the local side will have to the remote side. [...]

Agree? if you do, how do we fix it... the bug is there from day one.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
