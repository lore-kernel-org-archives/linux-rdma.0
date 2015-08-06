From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 12:04:32 -0500
Message-ID: <55C393A0.6000002@opengridcomputing.com>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
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
> http://git.infradead.org/users/hch/scsi.git/commitdiff/a0027ed00fc3ae=
2686d8a843a724b50597115a71
>

Hey Christoph,

You missed amso1100 (and probably ipath) that have been moved to=20
drivers/staging...

   CC [M]  drivers/staging/amso1100/c2_qp.o
drivers/staging/amso1100/c2_qp.c: In function =E2c2_post_send=E2:
drivers/staging/amso1100/c2_qp.c:863: error: =E2struct ib_send_wr=E2 ha=
s no=20
member named =E2wr=E2

I'll disable them from my config so I can test your code on cxgb4, but =
I=20
wanted to let you know...

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
