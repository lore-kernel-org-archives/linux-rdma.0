From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Fri, 7 Aug 2015 13:56:34 -0500
Message-ID: <55C4FF62.6060801@opengridcomputing.com>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150806162438.GA27608-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/6/2015 11:24 AM, Christoph Hellwig wrote:
> I've pushed out a new version.  Updates:
>
>   - the ib_recv_wr change Bart notices has been fixed.
>   - iser and isert have been converted
>   - the handling of the embedded WR in the qib software queue entry
>     has been fixed.
>
> Which means we're basically done now and the patch could use
> broader testing.
>
> The full patch will be too much for the list again, so here is the
> git commit:
>
> http://git.infradead.org/users/hch/scsi.git/commitdiff/a0027ed00fc3ae2686d8a843a724b50597115a71
>

This tests ok over iwarp/cxgb4 using NFSRDMA and user mode RDMA apps.

Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
