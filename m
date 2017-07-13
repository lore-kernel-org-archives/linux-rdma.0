From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rfc 3/3] nvmet-rdma: assign cq completion vector based on the port allowed cpus
Date: Thu, 13 Jul 2017 13:31:07 -0400
Message-ID: <D917872E-347A-48A5-8295-2563B6256E6C@oracle.com>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me> <1499007694-7231-4-git-send-email-sagi@grimberg.me> <20170713155003.GB2577@lst.de> <C2439AB7-BC2E-4B71-87CA-3F8313282828@oracle.com> <20170713172437.GA5236@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713172437.GA5236-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Jul 13, 2017, at 1:24 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> 
> On Thu, Jul 13, 2017 at 01:19:00PM -0400, Chuck Lever wrote:
>> 
>>> On Jul 13, 2017, at 11:50 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>>> 
>>> We really shouldn't be doing any of this in NVMe I think.  We'll need
>>> to go back to the cq pool API first.  The last version I had was here:
>>> 
>>> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq
>>> 
>>> and then do the affinity in common code.
>> 
>> This seems to address the problem I mentioned to you with properly
>> estimating send CQ size when using the rdma_rw API. If these are
>> going to be merged soon, I can drop the new API I proposed here:
>> 
>> http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=commit;h=2156cb956101da854f64918066710ff4e7affc5b
> 
> I'd need to find time to get back to it, and I have a few big
> chunks on my todo list.  Any chance you (or someone else interested)
> could take the series over?

Seems like it's right in Sagi's ballpark, and might be a pre-req
for his affinity work. If he's not interested, I can take it.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
