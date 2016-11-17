From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSD generic R/W API (sendto path) performance results
Date: Thu, 17 Nov 2016 10:04:54 -0500
Message-ID: <84B43CFF-EBF7-4758-8751-8C97102C5BCF@oracle.com>
References: <9170C872-DEE1-4D96-B9D8-E9D2B3F91915@oracle.com> <024601d23f7f$cef62500$6ce26f00$@opengridcomputing.com> <BA9DC9F7-C893-428B-AFE5-EFCCD13C9F25@oracle.com> <20161117124602.GA25821@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161117124602.GA25821-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 17, 2016, at 7:46 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> 
> On Wed, Nov 16, 2016 at 02:45:33PM -0500, Chuck Lever wrote:
>> Out of curiosity, I hacked up my NFS client to limit the size of RDMA
>> segments to 30 pages (the server HCA's max_sge).
>> 
>> A 1MB NFS READ now takes 9 segments. That forces the after-conversion
>> server to build single-Write chains and use 9 post_send calls to
>> transmit the READ payload, just like the before-conversion server.
>> 
>> Performance of before- and after-conversion servers is now equivalent.
>> 
>>              kB  reclen    write  rewrite    read    reread
>>         2097152    1024  1061237  1141614  1961410  2000223                                                                                  
> 
> What HCA is this, btw?

ConnectX-3 Pro, f/w 2.31.5050


> Also did you try to always register for > max_sge
> calls?  The code can already register all segments with the
> rdma_rw_force_mr module option, so it would only need a small tweak for
> that behavior.

For various reasons I decided the design should build one WR chain for
each RDMA segment provided by the client. Good clients expose just
one RDMA segment for the whole NFS READ payload.

Does force_mr make the generic API use FRWR with RDMA Write? I had
assumed it changed only the behavior with RDMA Read. I'll try that
too, if RDMA Write can easily be made to use FRWR.

But I'd like a better explanation for this result. Could be a bug
in my implementation, my design, or in the driver. Continuing to
investigate.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
