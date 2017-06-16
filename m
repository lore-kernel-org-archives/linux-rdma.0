From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: [PATCH v2 19/19] sunrpc: Disable splice for krb5i
Date: Fri, 16 Jun 2017 13:52:53 -0400
Message-ID: <20170616175253.GF12030@fieldses.org>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
 <20170616152254.14210.48071.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170616152254.14210.48071.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Just repeating some comments from the bug:

On Fri, Jun 16, 2017 at 11:22:54AM -0400, Chuck Lever wrote:
> Running a multi-threaded 8KB fio test (70/30 mix), three or four out
> of twelve of the jobs fail when using krb5i. The failure is an EIO
> on a read.
> 
> Troubleshooting confirmed the EIO results when the client fails to
> verify the MIC of an NFS READ reply. Bruce suggested the problem
> could be due to the data payload changing between the time the
> reply's MIC was computed on the server and the time the reply was
> actually sent.
> 
> krb5p gets around this problem by disabling RQ_SPLICE_OK.

And you verified that this does fix the problem in your case.

So, I think it's a simple fix and probably the best we can do without a
lot more work, so I'm happy applying it.

That said, I'm still curious about the performance:

> I would say that there is not much difference in this test.

We added an extra copy to the read path and it didn't seem to affect
throughput of streaming read much--I think that just says memory
bandwidth isn't the bottlneck in this case?  Which doesn't seem too
surprising.

I wonder what we should be looking for--maybe running the same test but
also measuring CPU usage somehow.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
