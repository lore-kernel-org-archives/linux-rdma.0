From: Stefan Roscher <ossrosch-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [ewg] [RFC] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Tue, 18 May 2010 13:04:05 +0200
Message-ID: <201005181304.05592.ossrosch@linux.vnet.ibm.com>
References: <20100506093949.55916ab0@alex-laptop> <20100507121936.283a18c6@alex-laptop> <adafx1xul8v.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafx1xul8v.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mel Gorman <MELGOR-g5DgMFWsQ8jQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

On Wednesday 12 May 2010 06:40:16 pm Roland Dreier wrote:
>  >  * added get_huge_page_size() to read the huge page size from
>  >    /proc/meminfo. This is done at ibv_fork_init() time.
> 
> That doesn't work on systems that have multiple huge page sizes (eg
> powerpc).  You can compare the code to get the size in libhugetlbfs.
> 
> Also I think the munging through /proc/pid/maps doesn't really work.
> First of all, essentially grepping for libhugetlbfs is not robust as I
> mentioned -- this will break in the same way for apps using huge pages
> directly.  

I agree that this two points (multiple huge page sizes and performance) are two critical
issues which we have to attack.
One suggestion from our side would be to use /proc/pid/smaps which would workaround
the multiple huge page size problem. It would not solve the perfomance issue, because
reading the file would assume long time even if we buffer the ranges and pagesize during 
fork_init.
Do you have an oppinion on that?

We appreciate your help!

regards Stefan

 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
