From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Wed, 25 Nov 2015 09:09:20 -0800
Message-ID: <5655EB40.8070508@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221430.32702.86114.stgit@manet.1015granger.net>
 <5653B606.3070700@talpey.com> <20151124065225.GB29141@infradead.org>
 <5654DC7A.7080807@oracle.com> <20151125090009.GA11255@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151125090009.GA11255-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/25/2015 1:00 AM, Christoph Hellwig wrote:
> On Tue, Nov 24, 2015 at 01:54:02PM -0800, santosh shilimkar wrote:
>> As already indicated to Sagi [1], RDS IB FR support is work in
>> progress and I was hoping to get it ready for 4.5. There are few
>> issues we found with one of the HCA and hence the progress
>> slowed down. Looking at where we are, 4.6 merge window seems
>> to be realistic for me to get RDS FR support.
>
> Ok.
>
>> Now on the iWARP transport itself, it has been bit tough because
>> of lack of hardware to tests. I have been requesting test(s) in
>> previous RDS patches and haven't seen any interest so far. If
>> this continues to be the trend, I might as well get rid of
>> RDS iWARP support after couple of merge windows.
>
> I'd say drop the current iWarp transport if it's not testable.  The
> only real difference between IB and iWarp is the needed to create
> a MR for the RDMA READ sink, and we're much better of adding that into
> the current IB transport if new iWarp users show up.

Agree. I will probably do it along with RDS IB FR support in 4.6

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
