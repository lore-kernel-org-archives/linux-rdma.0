From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 13:46:40 +0200
Message-ID: <5641D920.5000409@mellanox.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151110114145.GA2810-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 10/11/2015 13:41, Christoph Hellwig wrote:
> Oh, and while we're at it.  Can someone explain why we're even
> using rdma_read_chunk_frmr for IB?  It seems to work around the
> fact tat iWarp only allow a single RDMA READ SGE, but it's used
> whenever the device has IB_DEVICE_MEM_MGT_EXTENSIONS, which seems
> wrong.

I think Steve can answer it better than I can. I think that it is
just to have a single code path for both IB and iWARP. I agree that
the condition seems wrong and for small transfers rdma_read_chunk_frmr
is really a performance loss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
