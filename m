From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Tue, 24 Nov 2015 13:54:02 -0800
Message-ID: <5654DC7A.7080807@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221430.32702.86114.stgit@manet.1015granger.net>
 <5653B606.3070700@talpey.com> <20151124065225.GB29141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124065225.GB29141-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

On 11/23/2015 10:52 PM, Christoph Hellwig wrote:
> On Mon, Nov 23, 2015 at 07:57:42PM -0500, Tom Talpey wrote:
>> On 11/23/2015 5:14 PM, Chuck Lever wrote:
>>> FMR's ro_unmap method is already synchronous because ib_unmap_fmr()
>>> is a synchronous verb. However, some improvements can be made here.
>>
>> I thought FMR support was about to be removed in the core.
>
> Seems like everyone would love to kill it, but no one dares to do
> it just yet.  Reasons to keep FMRs:
>
>   - mthca doesn't support FRs but haven't been staged out
>   - RDS only supports FRMs for the IB transports (it does support FRs for
>     an entirely separate iWarp transports.  I'd love to know why we can't
>     just use that iWarp transport for IB as well).
>   - mlx4 hardware might be slower with FRs than FRMs (Or mentioned this
>     in reply to the iSER remote invalidation series).
>
> So at lest for 4.5 we're unlikely to be able to get rid of it alone
> due to the RDS issue.  We'll then need performance numbers for mlx4,
> and figure out how much we care about mthca.
>
As already indicated to Sagi [1], RDS IB FR support is work in
progress and I was hoping to get it ready for 4.5. There are few
issues we found with one of the HCA and hence the progress
slowed down. Looking at where we are, 4.6 merge window seems
to be realistic for me to get RDS FR support.

Now on the iWARP transport itself, it has been bit tough because
of lack of hardware to tests. I have been requesting test(s) in
previous RDS patches and haven't seen any interest so far. If
this continues to be the trend, I might as well get rid of
RDS iWARP support after couple of merge windows.

Regards,
Santosh
[1] http://www.spinics.net/lists/linux-nfs/msg53909.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
