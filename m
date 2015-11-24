From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/8] svcrdma: Remove svc_rdma_fastreg_mr::access_flags field
Date: Tue, 24 Nov 2015 11:04:04 -0500
Message-ID: <5AC80703-8CA1-4CB3-9F96-642C45F650A3@oracle.com>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net> <20151123222118.13040.24258.stgit@klimt.1015granger.net> <5653B4CA.5050806@talpey.com> <92B143FC-0F2C-48E4-9042-189883D76403@oracle.com> <20151124063903.GA12300@infradead.org> <7B9388F8-3A88-4F61-AB87-A1E6DB9902FE@oracle.com> <20151124160323.GA16427@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124160323.GA16427-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 11:03 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> On Tue, Nov 24, 2015 at 09:08:21AM -0500, Chuck Lever wrote:
>> Why don???t you fold my change into yours?
> 
> It's already included.  Well, sort of - I have removed used of the
> field, but forgot to remove the definition.  I will update it.

Excellent, that works for me.

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
