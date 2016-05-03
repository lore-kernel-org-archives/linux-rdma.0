From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Tue, 3 May 2016 17:01:23 -0400 (EDT)
Message-ID: <708298428.33647047.1462309283027.JavaMail.zimbra@redhat.com>
References: <571A936F.7040409@sandisk.com> <571A9472.5050202@sandisk.com> <20160503093032.GJ19931@lst.de> <5729109E.6040500@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5729109E.6040500-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>
Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Tuesday, May 3, 2016 4:57:02 PM
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference

On 05/03/2016 02:30 AM, Christoph Hellwig wrote:
> Any chance you could have a git repo with all your srp tests?  Having them
> available in a single place for others to use would really help with
> test coverage I think.

I will try to free up some time to work on this. I will need an SRP 
testsuite anyway before I simplify the SRP initiator by removing support 
for SG-lists with gaps (by setting q->limits.virt_boundary_mask).

Bart.

I am always happy to help test anything if needed.
I have a standing configuration in my lab always setup.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
