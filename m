From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libibrdmacm] Return errors from the library consistently
Date: Wed, 21 Oct 2009 11:25:35 -0700
Message-ID: <20109FFA005D46B3A2A34E0CF6F0CBEC@amr.corp.intel.com>
References: <20091020184157.GG14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020184157.GG14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Remove the return of -errno and always return codes via errno.
>As documented in librdmacm, these libraries are already documented
>to return -1 to indicate the code is in errno.
>
>Update rping to show a correct error reporting methodology.
>
>Also fix an errant return of 0 if the read/write syscalls return 0.
>
>Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks - both of these look good to me and tested fine.  I should push out new
releases of both libraries by the end of the week with these changes and ask
that they get pulled into OFED 1.5.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
