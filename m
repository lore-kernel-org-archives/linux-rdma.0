From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Mon, 10 Aug 2015 16:44:29 -0700
Message-ID: <55C9375D.4030909@sandisk.com>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150806162438.GA27608-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/06/2015 09:24 AM, Christoph Hellwig wrote:
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
> ib_vers.h diff below:
 > [ ... ]

For the SRP initiator and target changes:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
