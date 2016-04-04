From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Mon, 4 Apr 2016 15:58:31 -0700
Message-ID: <20160404225831.GA6725@infradead.org>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me>
 <5702A6AC.9020008@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5702A6AC.9020008-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 04, 2016 at 08:38:52PM +0300, sagig wrote:
> Odd, I see that Ming's patches made it to 4.5...
> 
> Can you verify that this patches exist in your tree:
> e827091cb1bc block: merge: get the 1st and last bvec via helpers
> 25e71a99f10e block: get the 1st and last bvec via helpers
> e0af29171aa8 block: check virt boundary in bio_will_gap()
> 7bcd79ac50d9 block: bio: introduce helpers to get the 1st and last bvec

I've done a clean rebuild because I didn't trust the previous one
lingering around, and the syptoms are slightly different now, in that I
still get the same spew of messages, but it seems like xfstests is
very slowly progressing regardless.

Also when testing srp I see similar messages with the same setup:

[  130.896116] scsi host7: ib_srp: Failed to map data (-12)
[  130.896225] scsi host7: ib_srp: Failed to map data (-12)
[  130.896232] scsi host7: ib_srp: Failed to map data (-12)
[  130.896235] scsi host7: ib_srp: Failed to map data (-12)
[  130.896835] scsi host7: ib_srp: Failed to map data (-12)
[  130.993339] scsi host7: ib_srp: Failed to map data (-12)
[  130.993345] scsi host7: ib_srp: Failed to map data (-12)
[  130.993349] scsi host7: ib_srp: Failed to map data (-12)
[  130.993841] scsi host7: ib_srp: Failed to map data (-12)
[  130.993844] scsi host7: ib_srp: Failed to map data (-12)
[  131.035723] scsi host7: ib_srp: Failed to map data (-12)
[  131.058006] scsi host7: ib_srp: Failed to map data (-12)
[  131.058059] scsi host7: ib_srp: Failed to map data (-12)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
