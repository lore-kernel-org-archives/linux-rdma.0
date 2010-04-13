From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Tue, 13 Apr 2010 20:02:54 +0200
Message-ID: <1271181774.4807.1868.camel@twins>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	 <20100412160359.1d9074dc.akpm@linux-foundation.org>
	 <20100412235937.GF15629@obsidianresearch.com>
	 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
	 <adahbnfme0j.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbnfme0j.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-04-13 at 10:57 -0700, Roland Dreier wrote:
> Are those system calls the only possible way that virtual to physical
> mappings can change?  Can't page migration or something like that
> potentially affect things?  And even if you did have hooks into every
> system call that mattered (keep in mind that relying on glibc is not
> enough, since an MPI application may not use glibc) would decoding them
> and figuring out what happened really be preferable to a single event
> type that tells you exactly what address range was affected? 

Yeah, virtual<->physical maps can change through swapping, page
migration, memory compaction, huge-page aggregation (the latter two not
yet being upstream).

Even mlock() doesn't pin virtual<->physical maps.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
