From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Mellanox target workaround in SRP
Date: Fri, 07 Jan 2011 17:35:17 -0500
Message-ID: <1294439717.6219.54.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have question regarding workaround introduced in commit 559ce8f1 of
the mainline tree:

    IB/srp: Work around data corruption bug on Mellanox targets
    
    Data corruption has been seen with Mellanox SRP targets when FMRs
    create a memory region with I/O virtual address != 0.  Add a
    workaround that disables FMR merging for Mellanox targets (OUI 0002c9).

I don't see how this can make a difference to the target -- it sees an
address and length, and there should be no visible difference to it when
it gets an FMR versus a direct-mapped region of the same space, right?
And how is it different than getting a direct or indirect descriptor
with a similar offset?

I could see there being a bug on the initiator HCA not liking such FMR
mappings, but then it should be keyed off of the vendor of our HCA and
not the target.

I'm sure this was tested and shown to fix the problem; I'm just confused
as to what the problem really was and if this is still relevant. Can
someone please enlighten me?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
