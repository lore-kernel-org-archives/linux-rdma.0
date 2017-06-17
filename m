From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 19/19] sunrpc: Disable splice for krb5i
Date: Sat, 17 Jun 2017 13:23:24 -0400
Message-ID: <A573E1EB-48DB-4E4A-B710-34914B0CF016@oracle.com>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net> <20170616152254.14210.48071.stgit@klimt.1015granger.net> <20170617150705.GA27917@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170617150705.GA27917-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 17, 2017, at 11:07 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> On Fri, Jun 16, 2017 at 11:22:54AM -0400, Chuck Lever wrote:
>> Running a multi-threaded 8KB fio test (70/30 mix), three or four out
>> of twelve of the jobs fail when using krb5i. The failure is an EIO
>> on a read.
> 
> Just curious: what is the backing fs that you tested with?  I'd be
> curious if you see this on XFS for example.

I was able to reproduce this with a tmpfs share and
with an XFS share on NVMe LUNs.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
