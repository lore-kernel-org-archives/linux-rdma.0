From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 10:16:34 -0500
Message-ID: <56420A52.1080309@talpey.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org> <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
 <F60E8BA6-D728-44E4-9331-0C23AB96E634@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F60E8BA6-D728-44E4-9331-0C23AB96E634-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/10/2015 9:34 AM, Chuck Lever wrote:
> 2. Is there a reason IB is not using the allphys MR for RDMA Read?
> That would be much more efficient. On the NFS server that MR isn't
> exposed, thus it is safe to use.

True, but only if the layout of the buffer's physical pages do not
exceed the local RDMA Read scatter limit. If the size is large then
the privileged MR will require additional RDMA Read operations, which
can be more expensive. It's certainly a valid optimization, if the
buffer "fits".

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
