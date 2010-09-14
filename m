From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDS/IB: add _to_node() macros for numa and use {k,v}malloc_node()
Date: Tue, 14 Sep 2010 16:53:20 -0700
Message-ID: <4C900AF0.2040908@oracle.com>
References: <4C892C9C.4060304@oracle.com> <4C8C9422.2070306@Voltaire.com> <4C8C94B8.9030107@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C8C94B8.9030107-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/12/2010 01:52 AM, Or Gerlitz wrote:
> Hi Andy, looking on this net-next-2.6 patch, I wonder if you can
> elaborate on your "significantly helps performance" comment - what
> improvement you see with this patch?

 > What about the QP/CQ memory, are they better be placed in node-local
 > to the HCA manner?

Hi Or, I'm afraid I don't have exact numbers for you.. those changes 
were part of a series of tweaks and fixes for bottlenecks in rds code.

On our numa box, the HCA is attached to a particular package of CPUs & 
memory. Having the in-memory structures that the hca is accessing in 
node-local RAM seemed to measurably help, although reducing contention 
helped even more. Chris Mason says it seemed like init-time allocations 
seemed to benefit while runtime allocations were not helped, or even hurt.

Clearly this is not enough data to go on, beyond the conclusion that yes 
it's something that should be looked at more closely. Big machines are 
still rather scarce, which makes it harder.

Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
