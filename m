From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Tue, 3 May 2016 13:57:02 -0700
Message-ID: <5729109E.6040500@sandisk.com>
References: <571A936F.7040409@sandisk.com> <571A9472.5050202@sandisk.com>
 <20160503093032.GJ19931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503093032.GJ19931-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/03/2016 02:30 AM, Christoph Hellwig wrote:
> Any chance you could have a git repo with all your srp tests?  Having them
> available in a single place for others to use would really help with
> test coverage I think.

I will try to free up some time to work on this. I will need an SRP 
testsuite anyway before I simplify the SRP initiator by removing support 
for SG-lists with gaps (by setting q->limits.virt_boundary_mask).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
