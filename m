From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Mellanox target workaround in SRP
Date: Mon, 10 Jan 2011 10:51:13 -0800
Message-ID: <adaipxw8ue6.fsf@cisco.com>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294439717.6219.54.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org> (David Dillow's
	message of "Fri, 07 Jan 2011 17:35:17 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Maybe we can use MST's current email to ask him... Michael, do you have
any memory of the issue we worked around here?

 > I have question regarding workaround introduced in commit 559ce8f1 of
 > the mainline tree:
 > 
 >     IB/srp: Work around data corruption bug on Mellanox targets
 >     
 >     Data corruption has been seen with Mellanox SRP targets when FMRs
 >     create a memory region with I/O virtual address != 0.  Add a
 >     workaround that disables FMR merging for Mellanox targets (OUI 0002c9).
 > 
 > I don't see how this can make a difference to the target -- it sees an
 > address and length, and there should be no visible difference to it when
 > it gets an FMR versus a direct-mapped region of the same space, right?
 > And how is it different than getting a direct or indirect descriptor
 > with a similar offset?
 > 
 > I could see there being a bug on the initiator HCA not liking such FMR
 > mappings, but then it should be keyed off of the vendor of our HCA and
 > not the target.
 > 
 > I'm sure this was tested and shown to fix the problem; I'm just confused
 > as to what the problem really was and if this is still relevant. Can
 > someone please enlighten me?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
