From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sat, 21 Aug 2010 16:50:46 -0400
Message-ID: <1282423846.20840.33.camel@obelisk.thedillows.org>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
	 <1282408043.20840.13.camel@obelisk.thedillows.org>
	 <AANLkTimFS=QkHd9+393mS1gQ5ZnL79jSDQaUZ8C_Xd2A@mail.gmail.com>
	 <201008212020.55028.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008212020.55028.bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-08-21 at 20:20 +0200, Bernd Schubert wrote:
> On Saturday, August 21, 2010, Bart Van Assche wrote:

> > What might help - depending on how the target is implemented - is
> > using an I/O depth larger than one. ib_srp sends all SRP_CMDs with the
> 
> It depends if we enable write-back cache or not. The older S2A architechture 
> does not mirror the cache at all and therefore write-back cache is supposed to 
> be disabled. The recent SFA architechture mirrors the write-back cache and so 
> it supposed to be enabled. With enabled witeback-cache an 'improved' command 
> processing is done (I don't know details myself). However, cache mirroring is 
> an expensive operation if the system can do 10GB/s and there IOs only will go 
> into the cache, if the size is not a multiple of 1024K. 1MiB IOs are directly 
> send to the disks. And now that leaves us with srp, where we see to many 1020K 
> request, which will need to be processed by the write-back cache....

You have a few options here -- if it was a 1024 KB request broken into a
1020 KB and a 4 KB request, you can hold onto the 1020 KB request for a
fraction of a second to see if the next request completes it. The 4 KB
request will almost always be the next request for the LUN. If the next
request doesn't fill out the stripe, then do the effort for write
mirroring.

That can be extended as well -- perhaps start the mirror of the 1020 KB
request, but you can decide not to mirror the 4 KB request since it
completes the full stripe write, and then you can just wait to complete
the 4 KB write once the full stripe write completes to disk, as you
would if a 1 MB, stripe-aligned request comes in.

And similarly for if the next request fills a stripe but spills into the
next stripe -- mirror only the portion that's needed and switch to
waiting for the disk write if you can make a full stripe on the next
request.

> > task attribute SIMPLE, so a target is allowed to process these
> > requests concurrently. For the ib_srpt target I see the following
> > results over a single QDR link and a NULLIO target (fio

> How exactly do you do that? Is that something I would try with our storage as 
> well? I guess only with a special firmware version, which I also do not have 
> access to.

Bart is referring to keeping multiple requests in flight. On your
client, use a non-zero -qd to xdd for example, or the --threads
--numjobs=X for fio he showed.

If you're not doing direct IO, then you have less direct control over
how the page cache will do its writeback, but I would expect it to
either try to have a decent queue depth or the block/mm developers may
be interested in patches to get there if it makes sense for a particular
device.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
