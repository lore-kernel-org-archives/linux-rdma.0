From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Thu, 26 May 2016 22:53:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
 <20160524210132.GB7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
 <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160526172244.GC27115-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Actually, I was thinking about ditching the common response buffer and
> > just overwriting the command buffer.
> 
> The sgl approach allows this by letting user-space set the in and out
> pointers to the same thing, without having problems with specifying
> the out length or requiring user space to parse netlink to find the
> reply.

For common handling, the framework needs to know how much memory to allocate for copy in/out purposes.  The location of the ioctl input data, and the resulting output response data, in the allocated buffer also need to be agreed upon by the framework and kernel client.

Ideally, the number of calls to copy to/from user should be minimized.

In my proposal, each ioctl is matched with a descriptor which defines the size of the kernel buffer needed for input/output, which is then allocated by the framework.  I had the response buffer overwrite the command buffer, with the kernel client writing the response at the start of the kernel buffer.  This is an area that needs discussion, but is at least separate from the uABI. 

Using an sgl for input would increase the number of copy from user calls.  I anticipate the common case of the command header and command data located as part of the same memory buffer.  If so, an input sgl would be less efficient.  I want to avoid copying the header to get a length, then copying the sgl, and then copying the sgl data.

Unless I'm missing something, using an sgl for output should work fine, and only adds a simple iterative loop into the code path.

If we want to support more optimal ioctl handling, we could use separate ioctl commands for sgl versus non-sgl, with all other aspects of the two commands the same.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
