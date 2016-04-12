From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Tue, 12 Apr 2016 14:33:58 -0700
Message-ID: <570D69C6.6050800@sandisk.com>
References: <5702A46F.5070109@grimberg.me> <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org> <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org> <570548AB.4090802@grimberg.me>
 <20160406231658.GB11588@infradead.org> <570608C9.1070805@grimberg.me>
 <570623B9.8040108@mellanox.com> <570679B6.10409@grimberg.me>
 <20160407221359.GA16686@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407221359.GA16686-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/07/2016 03:13 PM, Christoph Hellwig wrote:
> The patch below fixes the issue for me.  But for SRP I'm still seeing
> lots of these failures even with the equivalent patch applied:
>
> [ 426.027905] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053203] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053265] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053270] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053273] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053276] scsi host8: ib_srp: Failed to map data (-12)
> [  426.053279] scsi host8: ib_srp: Failed to map data (-12)
>
> It seems the actual reproducer is xfs_repair as run by xfstests.

Hello Christoph,

So far I have not yet been able to reproduce the ib_srp mapping failure 
with kernel v4.6-rc3. How was ib_srp configured in your test (cat 
/etc/modprobe.d/ib_srp.conf)?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
