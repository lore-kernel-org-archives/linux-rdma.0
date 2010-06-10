From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.35
Date: Thu, 10 Jun 2010 12:50:59 -0700
Message-ID: <4C114223.1010309@oracle.com>
References: <adaiq6mo58m.fsf@roland-alpha.cisco.com>	<4C0D778C.8070108@oracle.com> <adar5kgm64d.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adar5kgm64d.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/09/2010 11:08 AM, Roland Dreier wrote:
>   >  Please also pick up the 3-patch set "Least attached vector support"
>   >  from Yevgeny on 2010-5-13? RDS changes depend on these.
>
> It's now post -rc2, so these obviously wait for 2.6.36 at best.
>
> However, I haven't replied to these patches in detail but in general I
> don't like this approach of "pick a random vector" since it is
> non-deterministic and not likely to end up with an optimal result.

What is the optimal way to do this, if it isn't to spread CQs evenly 
across all available vectors? (least attached vector != random.)

I guess we'll just round-robin modulo caps.num_comp_vectors for now, but 
I do think this should be up to the hca, not the ulp, since the ULP has 
no visibility into other ulp's usage of vectors.

Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
