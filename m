From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Remote access to pmem on storage targets
Date: Tue, 26 Jan 2016 09:25:33 +0100
Message-ID: <20160126082533.GR24938@quack.suse.cz>
References: <06414D5A-0632-4C74-B76C-038093E8AED3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <06414D5A-0632-4C74-B76C-038093E8AED3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

On Mon 25-01-16 16:19:24, Chuck Lever wrote:
> I'd like to propose a discussion of how to take advantage of
> persistent memory in network-attached storage scenarios.
> 
> RDMA runs on high speed network fabrics and offloads data
> transfer from host CPUs. Thus it is a good match to the
> performance characteristics of persistent memory.
> 
> Today Linux supports iSER, SRP, and NFS/RDMA on RDMA
> fabrics. What kind of changes are needed in the Linux I/O
> stack (in particular, storage targets) and in these storage
> protocols to get the most benefit from ultra-low latency
> storage?
> 
> There have been recent proposals about how storage protocols
> and implementations might need to change (eg. Tom Talpey's
> SNIA proposals for changing to a push data transfer model,
> Sagi's proposal to utilize DAX under the NFS/RDMA server,
> and my proposal for a new pNFS layout to drive RDMA data
> transfer directly).
> 
> The outcome of the discussion would be to understand what
> people are working on now and what is the desired
> architectural approach in order to determine where storage
> developers should be focused.
> 
> This could be either a BoF or a session during the main
> tracks. There is sure to be a narrow segment of each
> track's attendees that would have interest in this topic.

So hashing out details of pNFS layout isn't interesting to many people.
But if you want a broader architectural discussion about how to overcome
issues (and what those issues actually are) with the use of persistent
memory for NAS, then that may be interesting. So what do you actually want?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
