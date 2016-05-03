From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Tue, 3 May 2016 11:30:32 +0200
Message-ID: <20160503093032.GJ19931@lst.de>
References: <571A936F.7040409@sandisk.com> <571A9472.5050202@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571A9472.5050202-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 22, 2016 at 02:15:30PM -0700, Bart Van Assche wrote:
> Avoid that running xfstests on top of the SRP initiator triggers
> the call trace below. This patch has been tested by running the
> following shell command on an initiator system that has access
> to 3200 SRP LUNs:

As mentioned by the others a better changelog would be useful.

> 
> /etc/init.d/multipathd start
> while true; do
>   /etc/init.d/srpd start
>   sleep 400
>   /etc/init.d/srpd stop
>   for p in /sys/class/srp_remote_ports/*; do
>     echo 1 >$p/delete &
>   done
>   wait
>   dmsetup remove_all
> done

Any chance you could have a git repo with all your srp tests?  Having them
avaiable in a single place for others to use would really help with
test coverage I think.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
