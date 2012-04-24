From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 0/5] Mkey support in infiniband-diags
Date: Mon, 23 Apr 2012 17:53:57 -0700
Message-ID: <1335228837.17237.302.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

     I am about to send version 2 of the mkey patches for
infiniband-diags to the list.  Notable changes are:

. both current mkey and new mkey (for ibportstate) may now be prompted
for in addition to specified on the command line (ie, identical to
saquery smkey support)

. mkey support touches (sadly, just a few) fewer files, due to SMP
handling cleanups committed earlier

. saquery's smkey handling has been fixed to allow the return of
authenticated SA data (this worked for only a few record types before)

. config file chmod and mkey option patches have been split out

     I think this covers most/all of the comments received from V1, with
the exception of the discussions surrounding multiple-mkey policies.
Given that the diags likely should support operations with a
single/specified mkey regardless of subnet policy, I think these patches
get us closer to that goal without standing in the way of future
discussions on how to get there.

     Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
