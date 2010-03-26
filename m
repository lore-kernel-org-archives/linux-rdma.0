From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 10:57:57 -0500
Message-ID: <4BACD985.1070906@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Roland and RDMA experts,

I'd like to raise an issue with the the architecture of the Linux RDMA 
subsystem regarding device removal and RDMA provider deregistration:

IBM/PPC and probably other vendors/platforms have virtual or logical 
partitions running Linux and they want to be able to add or remove 
devices, including rdma devices, in a hot-plug fashion.  They also want 
to be able to "reset" a failed device (EEH events). For other networking 
devices, this works fine.  With RDMA devices, however, it is possible 
for user mode RDMA applications to totally hang the device removal 
process by virtue of the fact that they don't release all their uverb 
contexts and rdma cm ids.  If an application, for example,  allocates 
and binds an rdma cm id, then just goes to sleep forever, that will hang 
the removal of the underlying device.   Here is the path I'm talking about:

0) an evil application has an rdma cm id bound to rdma device A.  The 
application is just sleeping doing nothing else.

1) device A event happens causing the device to unregister itself with 
the RDMA core.  This could be an EEH event requiring full device reset, 
or a OS hot-plug removal event.

2) device A calls ib_unregister_device().  This results in calls to all 
RDMA kernel clients' remove() function.

3) rdma_cm:cma_remove_one() and friends end up posting 
RDMA_CM_EVENT_DEVICE_REMOVAL events to all kernel users.

4) rdma_ucm gets this event and dutifully posts it for the use app to 
reap.   But since the app doesn't reap this event and exit or at least 
destroy the cm id, nothing else happens.

5) rdma_cm blocks awaiting all references on the device to go away.  
Since there is an allocated cm id, it will block forever.

Similar logic exists in uverbs as well, I think, but with a uverbs 
context as the object that must be released by the application. 

I propose that this is actually a denial of service type issue and we 
should consider ways to fix it.   I believe we've had this discussion 
before but punted on it.  However, I think this is pretty important for 
some OS/platform environments, and I'd like to discuss it again with the 
goal to fix the code so this issue never happens.

Thoughts? 




Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
