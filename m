From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/47] Address issues detected by static analysis tools
Date: Mon, 09 Oct 2017 12:51:32 -0400
Message-ID: <1507567892.46071.44.camel@redhat.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-10-06 at 14:32 -0700, Bart Van Assche wrote:
> Hello Doug,
> 
> As we all know there are several static analysis tools available for
> the Linux
> kernel and these tools are valuable. I'm referring to increasing the
> gcc
> warning level (W=1), sparse and smatch. It is helpful to analyze new
> code with
> these tools before submitting a patch. These tools are most useful if
> existing
> code is clean. Hence this patch series that significantly reduces the
> number
> of complaints reported by static analysis tools. Please consider this
> patch
> series for kernel v4.15.

The series looks pretty good Bart.  I'd like some Intel eyes on the
hfi1 changes, and I'd like some people to report back that the rcu
changes in their code are good, and the Cc: Signed-off-by: mistakes in
the hns_roce parts needs fixed.  Then I'll be ready to take it.  Thanks
for all the work here.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
